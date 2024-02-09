import 'package:client_app/domain/models/wallet_model.dart';
import 'package:client_app/managers/session_manager.dart';
import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/managers/entity_manager.dart';
import 'package:client_app/domain/entities/customer_entity.dart';

class CustomerManager extends EntityManager {
  SessionManager sessionManager = SessionManager();

  bool resultedData = false;
  List<Map<String, dynamic>> allData = [];

  bool populatorFunc(Map<String, dynamic> inputValue) {
    bool result = false;
    customerEntity.populateEntity(inputValue);
    if (customerEntity.getState() == 'populated') {
      result = true;
    }
    return result;
  }

  Future<bool> login(Map<String, dynamic> newData) async {
    WalletModel walletInfo;
    Map<String, dynamic> customerData;
    await createData({
      'auth': {
        'user_email':
            (newData['email'] == customerEntity.email) ? customerEntity.email.toString() : newData['email'].toString(),
        'user_password': newData['password'].toString()
      }
    }, '/sessions')
        .then((value) async => {
              if (value['success'] == true)
                {
                  customerData = value['resources']['user'],
                  if (value['resources']['profile'] != null)
                    customerData.addAll({'profile': value['resources']['profile']}),
                  await sharedPreferences.setString('session_id', value['resources']['session']['session_id']),
                  await sharedPreferences.setString('session_token', value['resources']['session']['session_token']),
                  await sharedPreferences.setInt('session_expires', value['resources']['session']['session_expires']),
                  await sharedPreferences.setString('user_id',
                      (value['resources']['user']['user_id'] != null) ? value['resources']['user']['user_id'] : ''),
                  await sharedPreferences.setString('user_name',
                      (value['resources']['user']['user_name'] != null) ? value['resources']['user']['user_name'] : ''),
                  await sharedPreferences.setString(
                      'user_email',
                      (value['resources']['user']['user_email'] != null)
                          ? value['resources']['user']['user_email']
                          : ''),
                  await sharedPreferences.setString('user_status', value['resources']['user']['user_status']),
                  await sharedPreferences.setString('user_ref', value['resources']['user']['user_ref']),
                  await sharedPreferences.setString('user_tos', value['resources']['user']['user_tos'].toString()),
                  await sharedPreferences.setString('user_kyc', value['resources']['user']['user_kyc'].toString()),
                  await sharedPreferences.setString(
                      'profile_first_and_last_name',
                      (value['resources']['profile']['profile_firstname'] != null ||
                              value['resources']['profile']['profile_lastname'] != null)
                          ? value['resources']['profile']['profile_firstname'] +
                              ' ' +
                              value['resources']['profile']['profile_lastname']
                          : ''),
                  sessionManager.sessionEntity.populateEntity(value['resources']['session']),
                  walletInfo = await walletManager.getWalletInfo(sharedPreferences.getString('user_id')!),
                  await sharedPreferences.setString('wallet_id', walletInfo.getResource()['wallet_id']),
                  populatorFunc(customerData),
                  if (sharedPreferences.getString('wallet_id') != null)
                    {
                      await sharedPreferences.setString('wallet_id', walletInfo.getResource()['wallet_id']),
                      await sharedPreferences.setString('wallet_address', walletInfo.getResource()['wallet_address']),
                      await getMyConnections(),
                    },
                  resultedData = true,
                }
            });
    return resultedData;
  }

  Future<bool> createUser(Map<String, dynamic> newData) async {
    var userData = {
      'user': {
        'user_email':
            (newData['email'] == customerEntity.email) ? customerEntity.email.toString() : newData['email'].toString(),
        'user_password': newData['password']
      }
    };
    var createdUser = await createData(userData, '/users');
    if (createdUser['success'] == true) {
      sharedPreferences.setString('session_id', createdUser['resources']['session']['session_id'].toString());
      sharedPreferences.setString('session_token', createdUser['resources']['session']['session_token'].toString());
      sharedPreferences.setInt('session_expires', createdUser['resources']['session']['session_expires']);
      sharedPreferences.setString('user_id', createdUser['resources']['user']['user_id']);
      sharedPreferences.setString('user_status', createdUser['resources']['user']['user_status']);
      customerEntity.customerStatus = createdUser['resources']['user']['user_status'];
      customerEntity.userModifiedAt = createdUser['resources']['user']['user_modified_at'];
      customerEntity.userCreatedAt = createdUser['resources']['user']['user_created_at'];
      customerEntity.userId = createdUser['resources']['user']['user_id'];
      customerEntity.userRef = createdUser['resources']['user']['user_ref'];
      customerEntity.tos = createdUser['resources']['user']['user_tos'];
      customerEntity.customerKYC = createdUser['resources']['user']['user_kyc'];
      customerEntity.emailPreview = createdUser['resources']['email']['preview'];
      await walletManager.createWallet();
      resultedData = true;
    } else {
      resultedData = false;
    }
    return resultedData;
  }

  Future<bool> createProfile(Map<String, dynamic> newData) async {
    var profileData = {
      'profile': {
        'profile_user_id': (newData['user_id'] == customerEntity.userId)
            ? customerEntity.userId.toString()
            : newData['user_id'].toString(),
        'profile_firstname': newData['firstname'].toString(),
        'profile_lastname': newData['lastname'].toString(),
        'profile_dob': newData['dob'].toString(),
        'profile_phone': newData['phone'].toString(),
        'profile_address': newData['address']
      }
    };
    var createdProfile = await createData(profileData, '/profiles');
    if (createdProfile['success'] == true) {
      customerEntity.profileCreatedAt = createdProfile['resources']['profile_created_at'];
      customerEntity.profileModifiedAt = createdProfile['resources']['profile_modified_at'];
      customerEntity.profileId = createdProfile['resources']['profile_id'];
      resultedData = true;
    } else {
      resultedData = false;
    }
    return resultedData;
  }

  Future<Map<String, dynamic>> sendEmailVerificationCode(String? emailInput) async {
    var newData = {
      'emailCode': {'user_email': emailInput}
    };
    var createdUser = await createData(newData, '/validation-code');
    if (createdUser['success']) {
      resultedData = true;
    }
    return createdUser;
  }

  Future<bool> validateCode(String? emailInput, int? verificationCode) async {
    var results = await createData({
      'verificationData': {'verification_code': verificationCode.toString(), 'verification_user_email': emailInput}
    }, '/validate-code');
    if (results['success'] == true) {
      return true;
    }

    return false;
  }

  Future<bool> updatePassword(String? emailInput, Map<String, dynamic>? newPass, int? verificationCode) async {
    await (updateData({
      'newPassword': {
        'old_password': null,
        'new_password': newPass!['password'],
      }
    }, '/passwords/$emailInput'))
        .then((value) async => {value ? resultedData = true : resultedData = false});
    return resultedData;
  }

  Future<bool> changePassword( String? emailInput ,Map<String, dynamic>? newPass) async {
     await (updateData({
      'newPassword': {
        'old_password': newPass!['old_password'],
        'new_password': newPass['password'],
      }
    }, '/passwords/$emailInput'))
        .then((value) async => {
          value ? resultedData = true : resultedData = false
          });
    return resultedData;
  }

  Future<bool> updateUser(Map<String, dynamic> newData, String id) async {
    await updateData({
      'user_email': (newData['email'] == customerEntity.email) ? customerEntity.email : newData['email'],
      'user_tos': (newData['tos'] == customerEntity.tos) ? customerEntity.tos : newData['tos'].toString()
    }, '/users/$id')
        .then((value) async => {
              if (value)
                {
                  await getData('/users/$id').then((value) => {
                        if (value.isNotEmpty)
                          {
                            if (populatorFunc(value)) {resultedData = true}
                          }
                      })
                }
            });
    return resultedData;
  }

  Future<bool> updateProfile(Map<String, dynamic> newData, String userId) async {
    Map<String, dynamic> customerData;
    Map<String, dynamic> updatedProfile;
    Map<String, dynamic> filteredProfile;
    await updateData(newData, '/profiles/$userId').then((value) async => {
          if (value)
            {
              customerData = customerEntity.getResource(),
              await getData('/profiles/$userId').then((value) => {
                    if (value['success'] == true && value['resources']['profile'] != null)
                      {
                        updatedProfile = value['resources']['profile'],
                        updatedProfile.remove('_id'),
                        customerData.addAll({'profile': updatedProfile}),
                        populatorFunc(customerData),
                        resultedData = true
                      }
                  })
            }
        });
    return resultedData;
  }

  Future<Map<String, dynamic>> getProfileData(String userId) async {
    var data;
    await getData('/profiles/$userId').then((value) => {
          if (value['success'] == true && value['resources']['profile'] != null)
            {
              data = value,
            }
        });
    return data;
  }

  Future<bool> getUser(String sessionId) async {
    await getData('/sessions/$sessionId').then((value) => {
          if (value['resources']['user'].isNotEmpty)
            {
              sharedPreferences.setString('user_status', value['resources']['user']['user_status']),
              if (populatorFunc(value['resources']['user'])) {resultedData = true}
            }
        });
    return resultedData;
  }

  Future<dynamic> searchUserName(String username) async {
    List<Map> foundUsers = [];
    await getData('/usernames', data: {'q': username}).then((result) => {
          if (result != null)
            {
              if (result['success'] == true)
                {
                  (result['resources']['usernames']).forEach((username) => {
                        foundUsers.add({'userId': username['user_id'], 'userEmail': username['user_email']}),
                      })
                }
            }
        });
    dynamic myUserElement;
    for (var element in foundUsers) {
      if (element['userEmail'] == sharedPreferences.getString('user_email')) {
        myUserElement = element;
      }
    }
    foundUsers.remove(myUserElement);
    return foundUsers;
  }

  CustomerEntity getCustomerInstance() {
    return customerEntity;
  }

  Future<bool> createPassword(int verificationCode, String emailInput, String newPassword) async {
    Map<String, dynamic> convertedData = {
      'newPassword': {
        'password_user_email': emailInput,
        'password_new_password': newPassword,
        'password_code': verificationCode
      }
    };
    var result = await createData(convertedData, '/register');
    return result['success'] == true ? true : false;
  }

  Future<bool> createUsername(String username) async {
    Map<String, dynamic> convertedData = {
      'user': {'user_id': sharedPreferences.getString('user_id'), 'user_name': username}
    };
    var result = await createData(convertedData, '/usernames');
    if (result['success'] == true) {
      if (populatorFunc({
        'user_created_at': customerEntity.userCreatedAt,
        'user_modified_at': customerEntity.userModifiedAt,
        'user_id': customerEntity.userId,
        'user_email': customerEntity.email,
        'user_name': username,
        'user_ref': customerEntity.userRef,
        'user_tos': customerEntity.tos,
        'user_status': customerEntity.customerStatus,
        'user_kyc': customerEntity.customerKYC,
        'profile_created_at': customerEntity.profileCreatedAt,
        'profile_modified_at': customerEntity.profileModifiedAt,
        'profile_id': customerEntity.profileId,
        'profile_user_id': customerEntity.userId,
        'profile_firstname': customerEntity.firstname,
        'profile_lastname': customerEntity.lastname,
        'profile_dob': customerEntity.dob
      })) {
        resultedData = true;
      }
    } else {
      resultedData = false;
    }
    return resultedData;
  }

  Future<bool> deleteCustomer(dynamic reason) async {
    // delete user and user's  chat data from firebase
    String userId = sharedPreferences.getString('user_id')!;
    String userEmail = sharedPreferences.getString('user_email')!;
    await ChatProvider.getUser(userId)
    .then((user) async {
      int numOfchatrooms = user['chatrooms'].length;
      if(numOfchatrooms > 0) await ChatProvider.removeUserFromChatrooms(userEmail);
      await ChatProvider.deleteUser(userId);
    });
    // delete user from database
    return await deleteData('/users/${sharedPreferences.getString('user_id')}', data: reason);
  }

  Future<bool> authenticateUser(password) async {
    var result = await createData({
      'auth': {'user_email': sharedPreferences.getString('user_email'), 'user_password': password}
    }, '/authenticate-user');
    return result['success'];
  }

  void clearCustomer() {
    customerEntity.clearInstance();
    customerEntity = CustomerEntity();
  }
}
