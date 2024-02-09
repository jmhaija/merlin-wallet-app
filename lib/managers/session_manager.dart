
import 'package:client_app/domain/entities/session_entity.dart';
import 'package:client_app/managers/entity_manager.dart';
import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/utils/globals.dart';

class SessionManager extends EntityManager{
  SessionEntity sessionEntity = SessionEntity();

  Future<bool> startSession(Map<String, dynamic> data) async {
    bool resultedData = false;
    await createData(data, '/sessions').then((value) => {
          if (sessionEntity.getState() == 'populated')
            {
              //have local storage to store the session data locally
            }
        });
    return resultedData;
  }

  Future<bool> endSession() async {
    bool resultedData = false;
    clearSession();
    await ChatProvider.addUpdateUserStatus('logOut');
    ChatProvider.clearUserData();
    customerManager.clearCustomer();
    var sessionId = sharedPreferences.getString('session_id');
    await deleteData('/sessions/$sessionId').then((value) {
      if (sessionEntity.getState() == 'prestine') {
        //remove all session from local storage here...
        sharedPreferences.getKeys().forEach((key) {
          if(key != 'is_auth_enabled') {
            sharedPreferences.remove(key);
          }       
        });
        resultedData = true;
      }
    });
    return resultedData;
  }

  Future<Map> getSession(String sessionId) async {
    Map result = {};
    await EntityManager().getData('/sessions', data: sessionId)
      .then((value) => {
        if (sessionEntity.getState() == 'populated') {
          //have local storage to store the session data locally
          result = value,
        }
      });
    return result;
  }

  getSessionToken() {
    if (sessionEntity.getSessionToken().isNotEmpty) {
      return sessionEntity.getSessionToken();
    }
  }

  clearSession() {
    sessionEntity.clearInstance();
    
  }

  getSessionEntity() {
    return sessionEntity;
  }
}
