import 'package:client_app/domain/classes/model_class.dart';

class UnLoadModel extends ModelClass {
  UnLoadModel({
    required this.unloadId,
    required this.unloadAmount,
    required this.unloadWalletId,
    required this.unloadConnectionId,
  });

  final String unloadId;
  final double unloadAmount;
  final String unloadWalletId;
  final String unloadConnectionId;

  static UnLoadModel fromJson(Map<String, dynamic> json) =>
    UnLoadModel(
      unloadId: json['unload_id'], 
      unloadAmount: json['unload_amount'] as double, 
      unloadWalletId: json['unload_wallet_id'],
      unloadConnectionId: json['unload_connection_id']
    );

  Map<String, dynamic> toJson() => {
    'unload_id': unloadId,
    'unload_amount': unloadAmount.toString(),
    'unload_wallet_id': unloadWalletId,
    'unload_connection_id': unloadConnectionId,
  };
}


