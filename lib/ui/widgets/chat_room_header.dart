import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/ui/pages/main_page_container.dart';
import 'package:flutter/material.dart';

import 'package:client_app/utils/globals.dart';

class ChatRoomHeaderWidget extends StatelessWidget {
  const ChatRoomHeaderWidget({
    required this.name,
    required this.chatid,
    Key? key,
  }) : super(key: key);
  final String name;
  final String chatid;

  String addEllipsisRemoveCommas(String myString) {
    int startSlice = 0;
    if (myString.startsWith(',')) {
      startSlice = 1;
    }
    myString = myString.substring(startSlice);
    return (myString.length <= 20) ? myString : '${myString.substring(0, 15)}...';
  }

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        padding: const EdgeInsets.all(16).copyWith(left: 0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox.square(dimension: 5.0),
                BackButton(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  onPressed: () async {
                    sharedPreferences.setString('get_notifications', '');
                    var chatroom = await ChatProvider.getChatRoom(chatid);
                    if (chatroom.recentMessage.isEmpty) {
                      await ChatProvider.removeChatRoomFromUserDoc(chatid);
                      // ignore: use_build_context_synchronously
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPageContainerScreen(route: '/chats_page')));
                    } else {
                      await ChatProvider.updateMessage(chatid);
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPageContainerScreen(route: '/chats_page')));
                    }
                  },
                ),
                const CircleAvatar(
                  radius: 18.0,
                  backgroundImage: AssetImage('assets/images/images.png'),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  child: Text(
                    addEllipsisRemoveCommas(name),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // DM chatroom does not allow to change the chatroom title
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //   return UpdateChatRoomTitle(beforeTitle: name, chatid: chatid);
                    // }));
                  },
                ),
              ],
            )
          ],
        ),
      );

  Widget buildIcon(IconData icon) => Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
        child: Icon(icon, size: 25, color: Colors.white),
      );
}
