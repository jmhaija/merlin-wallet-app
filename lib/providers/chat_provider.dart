import 'package:client_app/domain/models/chat_room_model.dart';
import 'package:client_app/domain/models/message_model.dart';
import 'package:client_app/domain/models/user_model.dart';
import 'package:client_app/providers/exception_handling_provider.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatProvider {
  static String myUserId = sharedPreferences.getString('user_id')!;
  static String myUserEmail = sharedPreferences.getString('user_email')!;
  static void clearUserData() {
    myUserId = '';
    myUserEmail = '';
  }

  static void setUserData() {
    if (sharedPreferences.getString('user_id') != null) {
      myUserId = sharedPreferences.getString('user_id')!;
      myUserEmail = sharedPreferences.getString('user_email')!;
    }
  }

  // Gets all the chat list
  static Stream<List<ChatRoomModel>> getChatRooms() {
    return _firestore
      .collection('chatrooms')
      .where('existingParticipants', arrayContains: myUserEmail)
      .orderBy('last_message_at', descending: true)
      .snapshots()
      .transform(Utils.transformer(ChatRoomModel.fromJson));
  }
  
  //Send message
  static Future<void> sendMessage(String chatRoomID, String message) async {
    final chatRoomDoc = _firestore.collection('chatrooms').doc(chatRoomID);
    var userEmails = [];
    dynamic lastReadAtList;
    Timestamp currentTime = Timestamp.now();

    await chatRoomDoc.get().then((value) => value.data()!.forEach((key, value) {
      if(key == 'last_read_at') {
        lastReadAtList = value;
      }
      if(key == 'participants') {
        userEmails = value;
      }
    }));

    //check if participants has this chatroom id, if not add the chatid to their chatrooms
    final userRef = _firestore.collection('users')
    .where('user_email', whereIn: userEmails)
    .get();

    List exitedParticipantsUser = [];
    String msgId = uuid.v4();
    await userRef.then((users) => {
      users.docs.forEach((user) {
        if(!user.data()['chatrooms'].contains(chatRoomID)){
          exitedParticipantsUser.add(user);
        }
      })
    });

    for (var user in exitedParticipantsUser) {
      var chatrooms = user['chatrooms'];
      chatrooms.add(chatRoomID);
      _firestore.collection('users').doc(user['user_id'])
      .update({
        'chatrooms': chatrooms
      });
    }

    // update my last_read_at timestamp to the current time
    lastReadAtList[myUserId] = currentTime;

    final newMessageObject = {
      'last_message_at': currentTime,
      'recent_message': {
        'message_id': msgId,
        'content': message,
        'created_at': currentTime,
        'created_by': myUserId,
        'is_read': false,
      },
      'last_read_at': lastReadAtList,
      'existingParticipants': userEmails
    };

    await chatRoomDoc.update(newMessageObject);

    for (var user in userEmails) {
      _firestore.collection('users')
        .where('user_email', isEqualTo: user)
        .get()
        .then((value) {
          if(value.docs.first.data()['login_status'] == 'logIn' && value.docs.first.data()['user_id'] != myUserId) {
          var deviceToken = value.docs.first.data()['device_token'];
          FirebaseFunctions.instance.httpsCallable('sendNotification').call(<String, dynamic> {
            'deviceToken': deviceToken,
            'title': myUserEmail,
            'body': message,
            'chatData': {
              'chat_id': chatRoomID
            }
          });
          }
        });
    }

    final messageDocInstance = _firestore.collection('messages')
    .doc(chatRoomID)
    .collection(chatRoomID)
    .doc(msgId);

    MessageModel messageModelInstance = MessageModel(
      chatId: chatRoomID,
      messageId: msgId,
      messageCreatedAt: currentTime,
      messageCreatedBy: myUserId,
      messageContent: message,
    );

    // add new message object into firestore
    _firestore.runTransaction((transaction) async {
      transaction.set(messageDocInstance, messageModelInstance.toJson());
    });
  }

  //Add device token to User
  static Future<void> setDeviceToken(token) async {
    final userDoc = _firestore.collection('users').doc(myUserId);

    await userDoc.update({
      'device_token': token
    });
  }

  //Set User Log in Status
  static Future<void> addUpdateUserStatus(userStatus) async {
    DocumentReference userDoc;
    if(sharedPreferences.getString('user_id') != null){
      await getUser(myUserId).then((value) async {
        if(value != null){
          if(sharedPreferences.getString('user_id') != ''){
            userDoc = _firestore.collection('users').doc(myUserId);
            await userDoc.update({
              'login_status':  userStatus
            });
          }
        }
      });
    }
  }


  static Future<bool> updateMessage(String chatID) async {
    bool updatedDone = false;
    var chatRoomDoc = _firestore.collection('chatrooms').doc(chatID);
    dynamic lastReadAtList;
    await chatRoomDoc.get()
      .then((value) {
        if(value.exists){
          value.data()!.forEach((key, value) {
            if(key == 'last_read_at') { lastReadAtList = value; }
          });
        }
      });
    if(lastReadAtList != null){
      //update current user's 'last_read_at' to the current timestamp
      lastReadAtList[myUserId] = Timestamp.now();
      await chatRoomDoc.update({'last_read_at' : lastReadAtList});
      updatedDone = true;
    }
    return updatedDone;
  }

  //Get Messages from Firestore
  static Stream<List<MessageModel>> getMessagesFirestore(String chatRoomID) {
    return _firestore
      .collection('messages')
      .doc(chatRoomID)
      .collection(chatRoomID)
      .snapshots().transform(Utils.transformer(MessageModel.fromJson));
  }

  static Stream<List<ChatRoomModel>> getChatInfo(String chatRoomID) {
    return _firestore
        .collection('chatrooms')
        .where('chat_id', isEqualTo: chatRoomID)
        .snapshots()
        .transform(Utils.transformer((ChatRoomModel.fromJson)));
  }

  // ----------------------------
  //getChatRoom function
  static Future<ChatRoomModel> getChatRoom(String chatRoomId) async {
    late ChatRoomModel chatRoom;
    var chatDoc = _firestore.collection('chatrooms').doc(chatRoomId);
    await chatDoc.get().then((chat) => {
          chatRoom = ChatRoomModel(
              chatId: chatRoomId,
              chatTitle: chat.data()!['chat_title'],
              recentMessage: chat.data()!['recent_message'],
              participants: chat.data()!['participants'],
              createdAt: chat.data()!['created_at'],
              createdBy: chat.data()!['created_by'],
              lastReadAt: chat.data()!['last_read_at'],
              chatStatus: chat.data()!['chat_status'])
        });
    return chatRoom;
  }

  //addChat function
  static Future<ChatRoomModel> addChatRoom(Map<dynamic, dynamic> selectedUser) async {
    // add myUsername into participants array
    List participantsList = [myUserEmail];
    // if selectedUser is not me, add to participants array
    if(myUserEmail != selectedUser['userEmail']) {
      participantsList.add(selectedUser['userEmail']);
    }
    // create a chatroom and add it to the chatrooms
    final refChatRoom = _firestore.collection('chatrooms');
    final refChatRoomDoc = refChatRoom.doc();
    ChatRoomModel chatRoomInstance = ChatRoomModel(
      chatId: refChatRoomDoc.id,
      createdAt: Timestamp.now(),
      participants: participantsList,
      chatTitle: participantsList.join(', '),
      createdBy: myUserId,
      recentMessage: {},
      lastMsgTime: Timestamp.now(),
      lastReadAt: {},
      chatStatus: [{
        myUserId: true,
      }]
    );
    await refChatRoom.doc(refChatRoomDoc.id).set(chatRoomInstance.toJson());
    // add the chatroom ID  to the all the participants' chatrooms array
    final refUsers = _firestore.collection('users');
    var participantsIdList = [];
    List<dynamic> userChatrooms = [];
    for (var participant in participantsList) {
      refUsers.where('user_email', isEqualTo: participant)
        .get()
        .then((value) => {
          participantsIdList.add(value.docs[0].data()['user_id'])
        });
    }
    for(var userId in participantsIdList) {
      var userDoc = refUsers.doc(userId);
      await userDoc.get().then((value) => {
        userChatrooms = value.data()!['chatrooms']
      });
      userChatrooms.add(refChatRoomDoc.id);
      await userDoc.update({'chatrooms': userChatrooms});

    }
    return chatRoomInstance;
  }

  //updateChatRoomTitle function
  static Future<dynamic> updateChatRoomTitle(String chatRoomId, String newTitle) async {
    List result = [];
    DocumentReference chatRoomDoc = _firestore.collection('chatrooms').doc(chatRoomId);

    await chatRoomDoc
        .update({'chat_title': newTitle})
        .catchError((error, stackTrace) => {
          if (error.toString().contains('not-found'))
            {
              result.add({'chatroom-404': ExceptionHandlingProvider(404).generateExceptionResponse()}),
            }
        })
        .then((dynamic value) => {
          if (result.isEmpty)
            {
              result.add({'200': 'Successfully updated chat title.'})
            }
        });
    return result;
  }

  //ExitChatRoom function
  static Future<dynamic> exitChatRoom(String chatRoomId) async {
    DocumentReference chatRoomDoc = _firestore.collection('chatrooms').doc(chatRoomId);
    DocumentReference myUserDoc = _firestore.collection('users').doc(myUserId);
    await myUserDoc.update({
      'chatrooms': FieldValue.arrayRemove([chatRoomId])
    })
    .then((dynamic value) async {
      if (value == null) {
        //1. check chatrooms, participants,
        var participantsList = await chatRoomDoc.get().then((dynamic value) => value.data()['participants']);
        var existingParticipants = participantsList;
        existingParticipants.remove(myUserEmail);
        chatRoomDoc.update({
          'existingParticipants': existingParticipants
        });
        //2. check users documents for each participants
        var usersRef = await _firestore.collection('users')
        .where('user_email', whereIn: participantsList).get();
        //3. if all of them do not have this chatroom id, delete
        int actualParticipantsNumber = 0; //actual participants number except for exited members
        for (var userDoc in usersRef.docs) {
          if(await userDoc.data()['chatrooms'].contains(chatRoomId)){
            actualParticipantsNumber++;
          }
        }
        if(actualParticipantsNumber == 0){
          await chatRoomDoc.delete();
        }
      }
    });
  }

  static Future<UserModel> addUser(Map<String, dynamic> userData) async {
    final refUsers = _firestore.collection('users');
    final refUserDoc = refUsers.doc(userData['userId']);

    UserModel userModel = UserModel(chatRooms: [], userId: userData['userId'], userEmail: userData['userEmail']);

    await refUsers.doc(refUserDoc.id).set(userModel.toJson());
    return userModel;
  }

  static Future<dynamic> getUser(String userid) async {
    final refUsers = _firestore.collection('users');
    final refUserDoc = refUsers.doc(userid);
    return refUserDoc.get().then((value) => value.data());
  }

  static Future<dynamic> getExistingChatRoomIfExists(String userEmail) async {
    if(userEmail != myUserEmail){
      return _firestore.collection('chatrooms')
        .where('participants', arrayContains: myUserEmail)
        .get()
        .then((chats) {
          if(chats.docs.isNotEmpty){
            for (var chatroom in chats.docs) {
              if(chatroom['participants'].length == 2 && chatroom['participants'].contains(userEmail)){
                return ChatRoomModel.fromJson(chatroom.data());
              }
            }
          } else {
            return null;
          }
        }
      );
    }
  }
   //Delete chatroom function
  static Future<void> removeChatRoomFromUserDoc(String chatRoomId) async {
    var userIds = [];
    // remove myself from this chat room and check if there's any participants left
    await _firestore.collection('users')
      .where('chatrooms', arrayContains: chatRoomId)
      .get().then((users) => {
        users.docs.forEach((user) => {
          userIds.add(user.data()['user_id'])
        })
      });
      for (var userId in userIds) {
        await _firestore.collection('users')
          .doc(userId)
          .update({
            'chatrooms': FieldValue.arrayRemove([chatRoomId])
          }
        );
      }
  }

  static Future<void> deleteChatRoom(chatRoomID)async {
    await _firestore.collection('chatrooms').doc(chatRoomID).delete();
  }

  static Future<void> deleteUser(userID) async {
    await _firestore.collection('users').doc(userID).delete();
  }

  static Future<dynamic> removeUserFromChatrooms(userEmail) async {
    final refChatrooms = _firestore.collection('chatrooms');
    refChatrooms
      .where('participants', arrayContains: userEmail)
      .get()
      .then((chats) async {
        if(chats.docs.isNotEmpty){
          for(var chat in chats.docs) {
            var chatId = chat.data()['chat_id'];
            var participantsList = chat.data()['participants'] as List;
            var myParticipantIdx = participantsList.indexWhere((element) => element.contains(myUserEmail));
            participantsList[myParticipantIdx] = 'Deleted account';
            var chatDoc = refChatrooms.doc(chatId);

            await chatDoc.update({
              'existingParticipants': FieldValue.arrayRemove([userEmail]), // remove the user from existingParticipants
              'participants': participantsList // set myEmail to 'Deleted account' in participant array
            });

          }
        } else {
          return null;
        }
      }
    );
  }
}
