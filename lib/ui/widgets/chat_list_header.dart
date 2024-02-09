import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';

class ChatHeaderWidget extends StatelessWidget with PreferredSizeWidget {
  const ChatHeaderWidget({
    Key? key,
  }) : super(key: key);

  // show the dialog
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        dictionaryObj['start']['Chats'],
        style: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: ColorConstant.midnight,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add, size: 30),
          iconSize: 30.0,
          color: Colors.white,
          tooltip: dictionaryObj['chat']['SearchUser'],
          onPressed: () async => {
            if(sharedPreferences.getString('user_status') == 'verified'){
              Navigator.pushNamed(context, '/search_username_chat')
            } else if(sharedPreferences.getString('user_status') != 'verified' && sharedPreferences.getString('user_status') != 'registered'){
              await customerManager.getUser(sharedPreferences.getString('session_id')!),
              if(sharedPreferences.getString('user_status') == 'unverified'){
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Verification needed!'),
                    content: const Text('To be able to search your friends check your inbox to verify your email!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              } else {
                Navigator.pushNamed(context, '/search_username_chat')  
              }
            } else {
              Navigator.pushNamed(context, '/search_username_chat')
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void setState(Null Function() param0) {}
}
