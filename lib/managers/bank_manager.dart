import 'package:client_app/managers/entity_manager.dart';
import 'package:client_app/domain/models/bank_model.dart';

class BankManager extends EntityManager {
  BankManager() {
    bankInstance.setCollectionURI('/banks');
  }

  BankModel bankInstance = BankModel();

  Future<dynamic> getBank(String bankId) async {
    var bank = await getData('${bankInstance.getCollectionURI()}/$bankId');
    bankInstance.generateInstance(bank['resources']['bank']);
    return bankInstance;
  }

  Future<dynamic> getBanks() async {
    var banks = await getData(bankInstance.getCollectionURI());
    List<BankModel> bankInstances = [];
    for (var bank in banks['resources']['banks']) {
      bankInstance.generateInstance(bank);
      bankInstances.add(bankInstance);
    }
    return bankInstances;
  }
}
