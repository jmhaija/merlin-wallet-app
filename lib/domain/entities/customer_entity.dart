import 'package:client_app/domain/classes/entity_class.dart';

class CustomerEntity extends EntityClass {

  CustomerEntity();
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  bool? customerKYC;
  String? customerStatus;
  String? username;
  String profileId = '';
  String userId = '';
  String? dob;
  int? tos;
  String? phone;
  int? userCreatedAt;
  int? userModifiedAt;
  int? profileCreatedAt;
  int? profileModifiedAt;
  String? userRef;
  Map<String, dynamic>? address;
  String? emailPreview;

  Map<String, dynamic> getCustomerData() {
    return getResource();
  }

}