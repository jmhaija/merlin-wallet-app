import 'package:client_app/domain/classes/model_class.dart';

class WalletModel extends ModelClass {
  WalletModel({
    this.walletId,
    this.walletCreatedAt,
    this.walletBalance,
    this.walletModifiedAt,
    this.walletAddress,
    required this.walletUserId,
    required this.walletCurrency
  });

  String? walletId;
  int? walletCreatedAt;
  int? walletModifiedAt;
  double? walletBalance;
  String? walletAddress;
  String walletCurrency;
  String walletUserId;
}
