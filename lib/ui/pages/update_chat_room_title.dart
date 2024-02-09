import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/ui/widgets/appbar.dart';

class UpdateChatRoomTitle extends StatefulWidget {
  const UpdateChatRoomTitle(
      {Key? key, required this.beforeTitle, required this.chatid})
      : super(key: key);

  @override
  State createState() => _UpdateChatRoomTitleState();
  final beforeTitle;
  final chatid;
}

class _UpdateChatRoomTitleState extends State<UpdateChatRoomTitle> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = widget.beforeTitle;
    return Scaffold(
      appBar: AppbarWidget(
        subject: dictionaryObj['chat']['EditChatRoomName'],
        actions: [
          TextButton(
            onPressed: () async {
              await ChatProvider.updateChatRoomTitle(
                  widget.chatid, _textController.text);
              Navigator.pushNamed(context, '/chats_page');
            },
            child: Text(dictionaryObj['OK']),
          ),
        ],
        routeBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: widget.beforeTitle,
            suffixIcon: IconButton(
                icon: const Icon(Icons.backspace_outlined),
                onPressed: () => {
                      _textController.clear(),
                    }),
          ),
        ),
      ),
    );
  }
}
