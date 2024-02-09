import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/domain/models/message_model.dart';
import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/ui/widgets/message_widget.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';

class MessagesWidget extends StatefulWidget {
  const MessagesWidget({
    required this.chatId,
    required this.scrollController,
    Key? key,
  }) : super(key: key);
  final String chatId;
  final ScrollController? scrollController;
  
  @override
  MessagesWidgetState createState() => MessagesWidgetState();
}

class MessagesWidgetState extends State<MessagesWidget> {
  List<MessageModel> messages = [];
  String myUserId = sharedPreferences.getString('user_id').toString();
  var myStreamBuilder;

  @override 
  void initState() {
    super.initState();
    myStreamBuilder =  StreamBuilder<List<MessageModel>>(
      stream: ChatProvider.getMessagesFirestore(widget.chatId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return buildText(dictionaryObj['chat_list_page']['ErrorMessage']);
            } else {
              if (snapshot.data!.isEmpty
                || snapshot.data!.first.messageContent.isEmpty
              ) {
                return buildText(dictionaryObj['start']['Hi']);
              } else {
                final filteredMessages = snapshot.data!.toList()
                  ..sort((a, b) => b.messageCreatedAt.compareTo(a.messageCreatedAt));
                messages = filteredMessages;
                return buildMessages(context, widget.chatId);
              }
            }
        }
      },
    );
  }

  @override
  void dispose() {
  widget.scrollController?.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) => Container(
        child: myStreamBuilder
      );


  Widget buildMessages(BuildContext context, String chatID) {
    return Stack(
          children: [ ListView.builder(
          controller: widget.scrollController,
          physics: const BouncingScrollPhysics(),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageWidget(
              createdAt: messages[index].messageCreatedAt,
              createdBy: messages[index].messageCreatedBy,
              messageContent: messages[index].messageContent,
              isMe: messages[index].messageCreatedBy.toString() == myUserId,
              isChatRelated: messages[index].chatId.toString() == chatID,
              chatID: chatID
            );
          }
          ),
    ]);
  }

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: const TextStyle(fontSize: 24, color: ColorConstant.midnight),
    ),
  );
}
