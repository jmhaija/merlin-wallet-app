import 'dart:convert';
import 'package:client_app/providers/api_service_provider.dart';

class EntityManager {
  dynamic result;
  late final results;

  Future<Map<String, dynamic>> createData(Map<String, dynamic> newData, String endpoint) async {
    var res = await ApiServiceProvider().create(endpoint, newData);
    if (res['ok']) {
      result = jsonDecode(res['payload']);
    }
    return result;
  }

  Future<dynamic> getData(String endpoint, {dynamic data}) async {
    dynamic result;
    await ApiServiceProvider().retrieve(endpoint, data: data).then((res) => {
          if (res['ok']) {result = jsonDecode(res['payload'])}
        });
    return result;
  }

  Future<bool> updateData(Map<String, dynamic> newData, String endpoint) async {
    bool result = false;
    await ApiServiceProvider().update(endpoint, newData).then((value) => {
          if (value['ok'] && jsonDecode(value['payload'])['success'] == true ) {result = true}
        });
    return result;
  }

  Future<bool> deleteData(String endpoint, {data}) async {
    bool result = false;
    await ApiServiceProvider().delete(endpoint, data: data).then((value) => {
          if (value['ok']) {result = true}
        });
    return result;
  }
}
