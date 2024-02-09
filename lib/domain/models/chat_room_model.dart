import 'package:client_app/domain/classes/model_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel extends ModelClass {

  ChatRoomModel({
    required this.chatId,
    required this.chatTitle,
    required this.recentMessage,
    required this.participants,
    this.lastMsgTime,
    required this.createdAt,
    required this.createdBy,
    required this.lastReadAt,
    this.chatStatus
  });
  final String chatId;
  final String chatTitle;
  final Timestamp createdAt;
  final String createdBy;
  final List<dynamic> participants;
  final Timestamp? lastMsgTime;
  final Map<String, dynamic> recentMessage;
  final dynamic lastReadAt;
  final dynamic? chatStatus;
  
  static dynamic getChatModelProperties() {
    return ChatRoomModel;
  }

  static ChatRoomModel fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      chatId: json['chat_id'], 
      chatTitle: json['chat_title'], 
      participants: (json['participants'] != null) ? json['participants'] : [],
      lastMsgTime: (json['last_message_at'] != null) ? json['last_message_at'] : null,
      createdAt:(json['created_at'] != null) ? json['created_at'] : null,
      createdBy: (json['created_by'] != null) ? json['created_by'] : '',
      recentMessage: {
        'messageID': (json['recent_message']['message_id'] != null) ? json['recent_message']['message_id'] : '',
        'content': (json['recent_message']['content'] != null) ? json['recent_message']['content'] : '',
        'createdAt': (json['recent_message']['created_at'] != null) ? json['recent_message']['created_at'] : null,
        'createdBy': (json['recent_message']['created_by'] != null) ? json['recent_message']['created_by'] : ''
      },
      lastReadAt: (json['last_read_at'] != null) ? json['last_read_at'] : {},
      chatStatus: (json['chat_status'] != null)? json['chat_status'] : null
    );
  }

  
  Map<String, dynamic> toJson() => {
    'chat_id': chatId,
    'chat_title': chatTitle,
    'recent_message': recentMessage,
    'participants': participants,
    'last_message_at': lastMsgTime,
    'created_at': createdAt,
    'created_by': createdBy,
    'last_read_at': lastReadAt,
    'chat_status': chatStatus
  };

}
