import 'package:client_app/domain/classes/model_class.dart';

class ConnectionModel extends ModelClass {
  ConnectionModel({
    this.connectionCreatedAt,
    this.connectionModifiedAt,
    this.connectionId = '',
    this.connectionBankId,
    this.connectionAccessToken,
    this.connectionAuthCode,
    this.connectionWalletId,
    this.connectionNickname,
    this.requestId,
    this.connectionAccountNumber = '',
    this.connectionBank,
  });

  int? connectionCreatedAt;
  int? connectionModifiedAt;
  String connectionId;
  String? connectionBankId;
  String? connectionAccessToken;
  String? connectionAuthCode;
  String? connectionWalletId;
  String? connectionNickname;
  String? requestId;
  String connectionAccountNumber;
  dynamic connectionBank;

  static ConnectionModel fromJson(Map<String, dynamic> json) {
    return ConnectionModel(
      connectionCreatedAt: json['connection_created_at'],
      connectionModifiedAt: json['connection_modified_at'],
      connectionId: json['connection_id'],
      connectionBankId: json['connection_bank_id'],
      connectionWalletId: json['connection_wallet_id'],
      connectionAuthCode: json['connection_authorization_code'],
      connectionAccessToken: json['connection_access_token'],
      connectionNickname: json['connection_nickname'],
      connectionAccountNumber: json['connection_account_number'],
      connectionBank: json['connection_bank_data'] != null ? json['connection_bank_data'][0] : ''
    );
  }
}

