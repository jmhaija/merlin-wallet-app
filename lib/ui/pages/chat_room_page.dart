import 'package:client_app/domain/models/chat_room_model.dart';
import 'package:client_app/ui/widgets/chat_room_header.dart';
import 'package:client_app/ui/widgets/messages_widget.dart';
import 'package:client_app/ui/widgets/new_message_widget.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:flutter/rendering.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    required this.chat,
    Key? key,
  }) : super(key: key);
  final ChatRoomModel chat;

  @override
  ChatRoomPageState createState() => ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoom> {
  final ScrollController _scrollController = ScrollController();
  bool isVisible = false;

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

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.bounceOut);
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                    extendBodyBehindAppBar: true,
                    backgroundColor: ColorConstant.midnight,
                    body: NotificationListener<UserScrollNotification>(
                      onNotification: (notification) {
                        setState(() {
                          if (notification.direction == ScrollDirection.reverse) {
                            isVisible = true;
                          }
                        });
                        return true;
                      },
                      child: SafeArea(
                          child: Column(children: [
                        ChatRoomHeaderWidget(name: removeMyUserName(widget.chat.participants), chatid: widget.chat.chatId),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: ColorConstant.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25)),
                          ),
                          child: MessagesWidget(chatId: widget.chat.chatId, scrollController: _scrollController),
                        )),
                        NewMessageWidget(chatRoomId: widget.chat.chatId)
                      ]))),
                    floatingActionButton: isVisible
                      ? Stack(children: [
                          Positioned.fill(
                            child: Overlay(
                              initialEntries: [
                                OverlayEntry(
                                  builder: (context) {
                                    return Positioned(
                                      top: MediaQuery.of(context).size.height * 0.25,
                                      left: 150,
                                      height: 50,
                                      width: MediaQuery.of(context).size.width * 0.38,
                                      child: FloatingActionButton(
                                        backgroundColor: ColorConstant.darkblue,
                                        onPressed: _scrollDown,
                                        child: const Icon(Icons.arrow_downward)
                                      )
                                    );
                                  },
                                )
                              ]
                            )
                          )
                        ]
                      )
                      : null
                    )
                  )
                );
            }
          );
  }
}
