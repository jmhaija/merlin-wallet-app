


import 'package:client_app/managers/entity_manager.dart';
import 'package:client_app/domain/models/wallet_model.dart';
import 'package:client_app/utils/globals.dart';

class WalletManager extends EntityManager {
  
  bool resultedData = false;
  WalletModel walletModelInstance = WalletModel(
    walletUserId: sharedPreferences.getString('user_id')!,
    walletCurrency: 'PHP'
  );
  
  Future<bool> createWallet() async {
    Map<String, dynamic> walletData = {
      'wallet': {
        'wallet_user_id': (sharedPreferences.getString('user_id')!.isEmpty) ? sharedPreferences.getString('user_id')  : customerEntity.userId,
        'wallet_currency': 'PHP'
      }
    };
    var createWallet = await createData(walletData, '/wallets');
    if(createWallet['success']) {
      walletModelInstance.generateInstance(createWallet['resources']['wallet']);
      sharedPreferences.setString('wallet_id', walletModelInstance.getResource()['wallet_id']!);
      resultedData = true;
    } else {
      resultedData = false;
    }
    return resultedData;
  }


  Future<WalletModel> getWalletInfo(String userId) async {
    String endpoint = '/wallets';

    var createWallet = await getData(endpoint, data: {'q': userId});

    if(createWallet['success']) {
      walletModelInstance.generateInstance(createWallet['resources']['wallet']);
      resultedData = true;
    } else {
      resultedData = false;
    }
    return walletModelInstance;
  }


  Future<dynamic> getUserInfoByWalletAddress(String walletAd) async {
    String endpoint = '/wallets/$walletAd';
    List result;

    var walletData = await getData(endpoint);
    if(walletData == null) {
      return result = [];
    }

    if(walletData['success'])  {
      result = walletData['resources']['allData'];
    } else {
      result = [];
    }

    return result;
  }

  Future<bool> updateWallet(Map <String, dynamic> newData) async {
    return (await updateData(newData, '/wallets')) ? true : false;
  }

}