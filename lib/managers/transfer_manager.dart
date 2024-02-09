import 'package:client_app/domain/models/transfer_model.dart';
import 'package:client_app/managers/entity_manager.dart';

class TransferManager extends EntityManager {
  TransferModel transferModelInstance = TransferModel(
      transferId: '', senderWalletId: '', receiverWalletId: '', transferDescription: '', transferAmount: '');

  Future<bool> createTransfer(Map<String, dynamic> newData) async {
    var createTransfer = await createData(newData, '/transfers');
    return createTransfer['success'];
  }
}
