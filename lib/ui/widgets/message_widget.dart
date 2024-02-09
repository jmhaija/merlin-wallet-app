import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/utils/size_utils.dart';
import 'package:client_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {super.key,
      required this.chatID,
      required this.createdAt,
      required this.messageContent,
      required this.createdBy,
      required this.isMe,
      required this.isChatRelated});
  final Timestamp createdAt;
  final String messageContent;
  final String createdBy;
  final bool isMe;
  final bool isChatRelated;
  final String chatID;
  static const _locale = 'fil';
  static final format = NumberFormat.simpleCurrency(locale: _locale);
  static final currencySymbol = format.currencySymbol;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(22);
    const borderRadius = BorderRadius.all(radius);
    final date = DateTime.fromMillisecondsSinceEpoch(Utils.toTimeStampConverter(createdAt));
    final timeFormat = DateFormat('h:mm a').format(date);
    final yearFormat = DateFormat('yyyy-MM-dd').format(date);
    if (isChatRelated) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 9),
            child: Row(
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isMe)
                  const SizedBox(
                    width: 10,
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(2),
                constraints: BoxConstraints(maxWidth: (MediaQuery.of(context).size.width * 0.70)),
                decoration: BoxDecoration(
                  color: isMe ? ColorConstant.lightblue : ColorConstant.grey,
                  borderRadius: isMe
                      ? borderRadius.subtract(const BorderRadius.only(bottomRight: radius))
                      : borderRadius.subtract(const BorderRadius.only(bottomLeft: radius)),
                ),
                child: buildMessage(context),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Row(
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  timeFormat,
                  style: const TextStyle(fontSize: 12, color: ColorConstant.midnight),
                ),
                const Text(' '),
                Text(
                  yearFormat,
                  style: const TextStyle(fontSize: 9, color: Color.fromARGB(255, 113, 115, 117)),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
            height: 20,
          ),
        ],
      );
    } else {
      return const SizedBox(width: 0, height: 0);
    }
  }

  Widget buildMessage(context) {
    const radius = Radius.circular(10);
    const borderRadius = BorderRadius.all(radius);
    if(messageContent.contains(globalSettings['inchat-transfer-prefix'])) {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 1.8,
        child: ListTile(
          leading: isMe 
            ? Transform.translate(
              offset: const Offset(-15, 0), 
              child: SizedBox(
                width: 40,
                child: Image.asset('assets/images/icons/send-money.png')
              ))
            : Transform.translate(
              offset: const Offset(-16, 0), 
              child: SizedBox(
                width: 40,
                child: Image.asset('assets/images/icons/receive_money.png'), 
              )
            ),
          title: Transform.translate(
            offset: const Offset(-16, 0), 
            child: Text(
              messageContent.replaceAll(globalSettings['inchat-transfer-prefix'], ''),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? ColorConstant.orangeA500 : ColorConstant.bluePelorous,
                fontSize: getFontSize(20)
              )
            )
          ),
          subtitle: isMe
            ?  Transform.translate(
                offset: const Offset(-16, 0), 
                child: Text(
                  'Money sent!', 
                  style: TextStyle(
                    color: ColorConstant.whiteA70001,
                  )
                )
              ) 
            : Transform.translate(
                offset: const Offset(-16, 0), 
                child: const Text('You received money!')
              ),
          onTap: () => {}
        )
      );
    }
    return Column(
      children: <Widget>[
        SelectableText.rich(
          TextSpan(
            text: messageContent,
            style: TextStyle(
              fontFamily: 'Sans Work',
              color: isMe ? ColorConstant.white : ColorConstant.black,
            ),
          ),
          toolbarOptions: const ToolbarOptions(copy: true, selectAll: true, paste: false, cut: false),
        )
      ],
    );
  }
}
