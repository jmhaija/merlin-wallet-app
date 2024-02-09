import 'package:client_app/domain/classes/model_class.dart';

class LoadModel extends ModelClass {
  LoadModel({
    required this.loadId,
    required this.loadAmount,
    required this.loadWalletId,
    required this.loadConnectionId
  });

  final String loadId;
  final double loadAmount;
  final String loadWalletId;
  final String loadConnectionId;

  static LoadModel fromJson(Map<String, dynamic> json) =>
    LoadModel(
      loadId: json['load_id'], 
      loadAmount: json['load_amount'] as double, 
      loadWalletId: json['load_wallet_id'],
      loadConnectionId: json['load_connection_id'],
    );

  Map<String, dynamic> toJson() => {
    'load_id': loadId,
    'load_amount': loadAmount.toString(),
    'load_wallet_Id': loadWalletId,
    'load_connection_id': loadConnectionId
  };
}
