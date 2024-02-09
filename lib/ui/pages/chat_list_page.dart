import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/domain/models/chat_room_model.dart';
import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/ui/widgets/chat_list_header.dart';
import 'package:client_app/ui/widgets/chat_list_body.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key, this.chatIdTodDelete}) : super(key: key);
  final String? chatIdTodDelete;
  @override
  ChatsPageState createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage> {
  String userStatus = sharedPreferences.getString('user_status').toString();
  @override
  void initState() {
    userStatus = sharedPreferences.getString('user_status').toString();
    super.initState();
    ChatProvider.setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: const ChatHeaderWidget(),
        body: Column(
          children: <Widget>[
            if (userStatus == 'unverified') ...[
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: ColorConstant.midnight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(1.0),
                        topRight: Radius.circular(1.0),
                      ),
                    ),
                    child: buildText(dictionaryObj['chat_list_page']['UserNotVerifiedMessage'], 30)),
              ),
            ] else ...[
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: ColorConstant.midnight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1.0),
                      topRight: Radius.circular(1.0),
                    ),
                  ),
                  child: StreamBuilder<List<ChatRoomModel>>(
                    stream: ChatProvider.getChatRooms(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return buildText(dictionaryObj['chat_list_page']['ErrorMessage'], 24);
                          } else {
                            final chats = snapshot.data;
                            if (chats!.isEmpty) {
                              return buildText(dictionaryObj['chat_list_page']['StartFirstChat'], 30);
                            } else {
                              List<ChatRoomModel> existingChats = [];
                              for (var chat in chats) {
                                if (widget.chatIdTodDelete != chat.chatId) {
                                  existingChats.add(chat);
                                }
                              }
                              return ChatBodyWidget(chats: existingChats);
                            }
                          }
                      }
                    },
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildText(String text, double textFontSize) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: textFontSize, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
}
