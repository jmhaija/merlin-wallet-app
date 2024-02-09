import 'package:client_app/domain/classes/model_class.dart';

class TransactionModel extends ModelClass {
  TransactionModel({
    required this.transactionCreatedAt,
    required this.transactionId,
    required this.transactionAmount,
    required this.transactionType,
    required this.transactionTo,
    required this.transactionFrom,
    required this.transactionDescription
  });

  final int transactionCreatedAt;
  final String transactionId;
  final double transactionAmount;
  final String transactionType;
  final String transactionTo;
  final String transactionFrom;
  final String transactionDescription;

  static TransactionModel fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionCreatedAt: (json['transaction_created_at'] != null) ? int.parse(json['transaction_created_at']) : 0,
      transactionId: json['transaction_id'],
      transactionAmount: (json['transaction_amount'] != null) ? double.parse(json['transaction_amount']) : 0,
      transactionType: json['transaction_type'],
      transactionTo: json['transaction_to'],
      transactionFrom: json['transaction_from'],
      transactionDescription: json['transaction_description']
    );
  }

  Map<String, dynamic> toJson() => {
      'transaction_created_at': transactionCreatedAt.toString(),
      'transaction_id': transactionId,
      'transaction_amount': transactionAmount.toString(),
      'transaction_type': transactionType,
      'transaction_to': transactionTo,
      'transaction_from': transactionFrom,
      'transaction_description': transactionDescription    
  };
}
