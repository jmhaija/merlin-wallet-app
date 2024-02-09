import 'package:client_app/domain/models/transaction_model.dart';
import 'package:client_app/managers/entity_manager.dart';

class TransactionManager extends EntityManager {
  TransactionModel transactionModelInstance = TransactionModel(
    transactionCreatedAt: 0,
    transactionId: '',
    transactionAmount: 0.0,
    transactionType: '',
    transactionTo: '',
    transactionFrom: '',
    transactionDescription: ''
	);

  Future<List> getTransactionsByQuery(String transactionWalletId) async {
    String endpoint = '/transactions';
    List transactions = [];
    var getTransactionsByWalletId = await getData(endpoint, data: {'q': {'wallet_id': transactionWalletId}});

    if (getTransactionsByWalletId['success']) {
      for (var transactionData in getTransactionsByWalletId['resources']['transactions']) {
        transactionModelInstance.generateInstance(transactionData);
        transactions.add(transactionModelInstance);
      }
    }
    return transactions;
  }

  Future<TransactionModel> getTransactionById(String transactionId) async {
    String endpoint = '/transactions/:$transactionId';

    var getTransactionByTheId = await getData(endpoint);

    if (getTransactionByTheId['sucess']) {
      transactionModelInstance.generateInstance(getTransactionByTheId['resources']['transaction']);
    }

    return transactionModelInstance;
  }
}
