import 'package:client_app/domain/classes/model_class.dart';

class TransferModel extends ModelClass {
  TransferModel({
    required this.transferId,
		required this.senderWalletId,
		required this.receiverWalletId,
    required this.transferDescription,
		required this.transferAmount,
  });

  final String transferId;
	final String senderWalletId;
  final String receiverWalletId;
  final String transferDescription;
  final double transferAmount;

  TransferModel fromJson(Map<String, dynamic> json) => TransferModel(
		transferId: json['transfer_id'],
		senderWalletId: json['sender_wallet_id'],
		receiverWalletId: json['receiver_wallet_id'],
		transferDescription: json['transfer_description'],
		transferAmount: json['transfer_amount'] as double,
	);

  Map<String, dynamic> toJson() => {
		'transfer_id': transferId,
		'sender_wallet_id': senderWalletId,
		'receiver_wallet_id': receiverWalletId,
		'transfer_description': transferDescription,
		'transfer_amount': transferAmount.toString(),
	};
}
