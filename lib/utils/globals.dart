library client_app.globals;

import 'dart:convert';

import 'package:client_app/domain/entities/customer_entity.dart';
import 'package:client_app/domain/models/connection_model.dart';
import 'package:client_app/managers/bank_manager.dart';
import 'package:client_app/managers/connection_manager.dart';
import 'package:client_app/managers/wallet_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client_app/managers/customer_manager.dart';
import 'package:client_app/providers/json_reader_provider.dart';

CustomerManager customerManager = CustomerManager();
CustomerEntity customerEntity = CustomerEntity();
WalletManager walletManager = WalletManager();
ConnectionManager connectionManager = ConnectionManager();
BankManager bankManager = BankManager();
dynamic globalSettings;
dynamic countryConfigs;
String appVersion = versionNumber();

List<ConnectionModel> myConnections = [];
late SharedPreferences sharedPreferences;

Map<String, dynamic> dictionaryObj = {};

//biometric status
bool bioEnabled = false;

var appState;
// localStorage - sharedPreferences
void installSharedPreferencesService() async {
  sharedPreferences = await SharedPreferences.getInstance();
}

Future<Map<String, dynamic>> dictionaryReader() async {
  await readJson('assets/dict/en-CA.json').then((value) {
    return dictionaryObj.addAll(json.decode(value));
  });
  return dictionaryObj;
}

Future<List<ConnectionModel>> getMyConnections() async {
  myConnections = await connectionManager.getConnectionsByWalletId(sharedPreferences.getString('wallet_id')!); 
  return myConnections;
}

// app version number
String versionNumber() {
  return globalSettings['version'];
}

showComingSoonToast(){
  EasyLoading.showToast('coming soon', duration: const Duration(milliseconds: 500));
}
