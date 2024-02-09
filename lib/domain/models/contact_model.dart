import 'dart:convert';

import 'package:client_app/domain/classes/model_class.dart';

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact extends ModelClass {
  Contact({
    required this.contactID,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.email,
  });

  String contactID;
  String? fName;
  String? lName;
  String? phone;
  String? email;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    contactID: json['contactID'],
    fName: json["fName"],
    lName: json["lName"],
    phone: json["phone"],
    email: json["email"]
  );

  Map<String, dynamic> toJson() => {
    "contactID": contactID,
    "fName": fName,
    "lName": lName,
    "phone": phone,
    "email": email,
  };

  Map<String, dynamic> getContactData() {
    return getResource();
  }
}
