
import 'package:client_app/domain/classes/model_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends ModelClass {

  MessageModel({
    required this.chatId,
    required this.messageId,
    required this.messageContent,
    required this.messageCreatedAt,
    required this.messageCreatedBy,
  });
  final String chatId;
  final String messageId;
  final String messageContent;
  final Timestamp messageCreatedAt;
  final String messageCreatedBy;


  static dynamic getMessageProperties() {
    return MessageModel;
  }

  static MessageModel fromJson(Map<String, dynamic> json) {
    return MessageModel (
      chatId: (json['chat_id'] != null) ? json['chat_id'] : '',
      messageId: (json['message_id'] != null) ? json['message_id'] : '',
      messageContent: (json['message_content'] != null) ? json['message_content'] : '', 
      messageCreatedAt: (json['message_created_at'] != null) ? json['message_created_at'] : null, 
      messageCreatedBy: (json['message_created_by'] != null) ? json['message_created_by'] : '',
    );
  }
  
  Map<String, dynamic> toJson() => {
    'chat_id': chatId,
    'message_id': messageId,
    'message_content': messageContent,
    'message_created_at': messageCreatedAt,
    'message_created_by': messageCreatedBy,
  };
}
