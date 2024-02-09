
import 'package:client_app/domain/models/connection_model.dart';
import 'package:client_app/managers/entity_manager.dart';

class ConnectionManager extends EntityManager {
  bool resultedData = false;
  ConnectionModel connectionModelInstance = ConnectionModel();

  Future<bool> createConnection(Map<String, dynamic> newData) async {
    var createConn = await createData(newData, '/connections');

    if (createConn['success'] == true) {
      connectionModelInstance.generateInstance(createConn['resources']['connection']);
      resultedData = true;
    } else {
      resultedData = false;
    }
    return resultedData;
  }

  Future<bool> updateConnectionData(Map<String, dynamic> newData, String id) async {
    return (await updateData(newData, '/connections/$id')) ? true : false;
  }

  Future<List<ConnectionModel>> getConnectionsByWalletId(String connectionWalletId) async { 
    String endpoint = '/connections';
    List<ConnectionModel> connectionInstances = [];
    var getConnectionsByWalletId = await getData(endpoint, data: {'q': connectionWalletId});
    if (getConnectionsByWalletId != null && getConnectionsByWalletId['success']) {
      for (var connectionData in getConnectionsByWalletId['resources']['connections']) {
        connectionModelInstance = ConnectionModel.fromJson(connectionData);
        connectionInstances.add(connectionModelInstance);
      }
    }
    return connectionInstances;
  }

  Future<ConnectionModel> getConnectionByConnectionId(String connectionId) async {
    String endpoint = '/connections/$connectionId';
    var connection = await getData(endpoint);
    connectionModelInstance = ConnectionModel.fromJson(connection['resources']['connection']);
    return connectionModelInstance;
  }

  Future<bool> updateNickname(Map<String, dynamic> newData, String id) async {
    var updateNick = await updateData({
      'connection_nickname': (newData['connectionNickname'] == connectionModelInstance.connectionNickname)
          ? connectionModelInstance.connectionNickname
          : newData['connectionNickname']
    }, '/connections/$id');
    return updateNick ? true : false;
  }

  Future<void> deleteConnection(endpoint) async {
    var deleteConn = await deleteData('/connections');

    if (deleteConn) {
      connectionModelInstance.clearInstance();
    }
  }
}
