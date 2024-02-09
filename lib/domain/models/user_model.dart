import 'package:client_app/domain/classes/model_class.dart';

class UserModel extends ModelClass {
  UserModel({
    required this.userId,
    required this.userEmail,
    required this.chatRooms,
  });
  
  final String userId;
  final String userEmail;
  final List<dynamic> chatRooms;

  static dynamic getUserProperties() {
    return UserModel;
  }

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    userId: json['user_id'],
    userEmail: json['user_email'],
    chatRooms: (json['chatrooms'] != null) ? json['chatrooms'] : [],
  );
  
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_email': userEmail,
    'chatrooms': (chatRooms.isNotEmpty) ? chatRooms : [],
  };
}
