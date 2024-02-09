import 'dart:convert';
import 'package:client_app/domain/classes/model_class.dart';

BankModel bankFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankToJson(BankModel data) => json.encode(data.toJson());

class BankModel extends ModelClass {
  BankModel({
    this.bankId,
    this.bankFullName, 
    this.bankShortName, 
    this.bankRefCode, 
    this.bankCountry, 
    this.bankRegionCode, 
    this.bankLogo,
    this.bankCreatedAt
  });

  String? bankId;
  String? bankFullName;
  String? bankShortName;
  String? bankRefCode;
  String? bankCountry;
  int? bankRegionCode;
  String? bankLogo;
  int? bankCreatedAt;


  static BankModel fromJson(Map<String, dynamic> json) =>
    BankModel(
      bankId: json['bank_id'], 
      bankFullName: json['bank_full_name'],
      bankShortName: json['bank_short_name'],
      bankRefCode: json['bank_ref_code'],
      bankCountry: json['bank_country'],
      bankRegionCode: int.parse(json['bank_region_code']),
      bankLogo: json['bank_logo'],
      bankCreatedAt: int.parse(json['bank_created_at'])
    );

  Map<String, dynamic> toJson() => {
    'bank_id': bankId,
    'bank_full_name': bankFullName,
    'bank_short_name': bankShortName,
    'bank_ref_code': bankRefCode,
    'bank_country': bankCountry,
    'bank_region_code': bankRegionCode.toString(),
    'bank_logo': bankLogo,
    'bank_created_at': bankCreatedAt.toString(),
  };
}
