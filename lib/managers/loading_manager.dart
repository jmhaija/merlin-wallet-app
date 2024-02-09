import 'package:client_app/domain/models/loading_model.dart';
import 'package:client_app/domain/models/unload_model.dart';
import 'package:client_app/managers/entity_manager.dart';

class LoadingManager extends EntityManager {
  LoadingManager() {
    loadInstance.setCollectionURI('/loads');
    unLoadInstance.setCollectionURI('/unloads');
  }

  late LoadModel loadInstance;
  late UnLoadModel unLoadInstance;

  Future<dynamic> load(newData) async {
    var data = await createData(newData, loadInstance.getCollectionURI());
    return data['sucess'];
  }

  Future<dynamic> unLoad(newData) async {
    var data = await createData(newData, unLoadInstance.getCollectionURI());
    return data['sucess'];
  }
}
