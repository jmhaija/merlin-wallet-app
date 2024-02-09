import 'package:client_app/domain/models/chat_room_model.dart';
import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/utils/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:intl/intl.dart';
import 'package:client_app/utils/utils.dart';

class ChatBodyWidget extends StatefulWidget {
  ChatBodyWidget({
    required this.chats,
    Key? key,
  }) : super(key: key);
  List<ChatRoomModel> chats;

  @override
  ChatBodyWidgetState createState() => ChatBodyWidgetState();
}

class ChatBodyWidgetState extends State<ChatBodyWidget> {
  List<ChatRoomModel> chats = [];
  @override
  initState() {
    super.initState();
    chats = widget.chats;
  }

  String removeMyUserName(List<dynamic> participants) {
    if (participants.length > 1) {
      String myUserEmail = sharedPreferences.getString('user_email')!;
      String updatedTitle = '';
      List<String> participantsWithoutMe = [];
      for (var participant in participants) {
        if (myUserEmail != participant) {
          participantsWithoutMe.add(participant);
        }
      }
      updatedTitle = participantsWithoutMe.join(', ');
      return updatedTitle;
    } else {
      return participants.join(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: buildChats(),
    );
  }

  String formatTimestamp(Timestamp? lastChatTimestamp) {
    if (lastChatTimestamp == null) {
      return '';
    }
    String formattedTimestamp = '';
    final now = DateTime.now();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(Utils.toTimeStampConverter(lastChatTimestamp));
    final timeFormat = DateFormat('h:mm a').format(createdAt);
    final monthFormat = DateFormat('MMM, d').format(createdAt);
    final yearFormat = DateFormat('yyyy-MM-dd').format(createdAt);
    if ((now.year == createdAt.year)) {
      if (now.day == createdAt.day) {
        if (now.month != createdAt.month) {
          formattedTimestamp = monthFormat;
        } else {
          formattedTimestamp = timeFormat;
        }
      } else if (now.day != createdAt.day) {
        formattedTimestamp = monthFormat;
      }
    } else {
      formattedTimestamp = yearFormat;
    }
    return formattedTimestamp;
  }

  showUnreadChat(chat) => Card(
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(25.0),
        ),
        surfaceTintColor: ColorConstant.bluegrey,
        child: showReadChat(chat),
      );

  showReadChat(chat) => ListTile(
        tileColor: ColorConstant.foregroundColor,
        leading: const CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage('assets/images/images.png'),
        ),
        title: Text(
          removeMyUserName(chat.participants),
          style: const TextStyle(fontSize: 17, color: Colors.black),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          !chat.recentMessage['content'].contains(globalSettings['inchat-transfer-prefix']) 
            ? chat.recentMessage['content']
            : chat.recentMessage['content'].replaceAll(globalSettings['inchat-transfer-prefix'], ''),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
          maxLines: 1,
        ),
        trailing: Text(formatTimestamp(chat.recentMessage['createdAt']),
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(15.0),
        ),
        onTap: () async {
          sharedPreferences.setString('get_notifications', chat.chatId);
          await ChatProvider.updateMessage(chat.chatId);
          await Navigator.pushNamed(context, '/chat-room', arguments: chat);
        },
      );

  Widget buildChats() => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.chats.length,
        itemBuilder: (context, index) {
          final chat = widget.chats[index];
          final lastMsgTimeMilliseconds = chat.lastMsgTime!.seconds;
          final myLastReadAtTime = chat.lastReadAt[sharedPreferences.getString('user_id')]?.seconds ?? 0;
          if (chat.recentMessage['content'].isNotEmpty) {
            return SizedBox(
                height: 75,
                child: Slidable(
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      extentRatio: 0.3,
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          borderRadius: BorderRadius.circular(15.0),
                          label: dictionaryObj['chat']['DeleteChat'],
                          onPressed: (context) => {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                title: Text(
                                  dictionaryObj['chat']['DeleteChat'],
                                  style: const TextStyle(color: ColorConstant.black),
                                ),
                                content: Text(
                                  dictionaryObj['chat']['ConfirmDelete'],
                                  style: const TextStyle(color: ColorConstant.black),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      dictionaryObj['chat']['CancelDelete'],
                                      style: const TextStyle(color: ColorConstant.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => {ChatProvider.exitChatRoom(chat.chatId), Navigator.pop(context)},
                                    child: Text(
                                      dictionaryObj['OK'],
                                      style: const TextStyle(color: ColorConstant.black),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          },
                        )
                      ],
                    ),
                    child: (lastMsgTimeMilliseconds > myLastReadAtTime) ? showUnreadChat(chat) : showReadChat(chat)));
          }
          return const SizedBox();
        },
      );
}
