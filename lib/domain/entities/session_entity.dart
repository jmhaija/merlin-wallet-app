import 'package:client_app/domain/classes/entity_class.dart';

class SessionEntity extends EntityClass{

  SessionEntity();
  late final String _sessionID;
  late final int _sessionExpiry;
  late final String _sessionToken;

  void _setSessionID(String id){
    setResourceID(_sessionID);
  }

  String getSessionID(){
    return _sessionID;
  }
  
  void setSessionExpiry(int expiry){
    _sessionExpiry = expiry;
  }
  int getSessionExpiry(){
    return _sessionExpiry;
  }
  void _setSessionToken(String token){
    _sessionToken = token;
  }
  
  String getSessionToken(){
    return _sessionToken;
  }
}