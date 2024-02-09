import 'package:client_app/domain/models/connection_model.dart';
import 'package:client_app/providers/exception_handling_provider.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:client_app/facades/http_facade.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BankProvider {
  String unionClientid = dotenv.get('UNION_CLIENTID', fallback: 'Client id not found');
  String unionRedirectURI = dotenv.get('UNION_REDIRECT_URI', fallback: 'redirect uri not found');
  String unionResType = dotenv.get('UNION_RESPONSE_TYPE', fallback: 'response type not found');
  String unionType = dotenv.get('UNION_TYPE', fallback: 'type not found');
  String unionPartnerid = dotenv.get('UNION_PARTNERID', fallback: 'partner id not found');
  String unionCustomerAuthUri = dotenv.get('UNION_CUSTOMER_AUTH_URI', fallback: 'uri not provided');
  String unionClientSecretid = dotenv.get('UNION_CLIENTSECRETID', fallback: 'Client secret id not found');
  String unionPartnerPassword = dotenv.get('UNION_PARTNERPASSWORD', fallback: 'partner pass not provided');
  String unionPartnerUsername = dotenv.get('UNION_PARTNERUSERNAME', fallback: 'partner username not provided');
  String unionPartnerAuthUri = dotenv.get('UNION_PARTNER_AUTH_URI', fallback: 'partner auth uri not provided');
  String unionLoadUri = dotenv.get('UNION_LOAD_URI', fallback: 'load uri not provided');
  String unionUnloadUri = dotenv.get('UNION_UNLOAD_URI', fallback: 'unload uri not provided');
  String unionVerifyOtpUri = dotenv.get('UNION_VERIFYOTP_URI', fallback: 'verify otp not provided');
  String unionOtpUri = dotenv.get('UNION_GET_OTP_URI', fallback: 'otp uri not found');
  String unionParterTokenUri = dotenv.get('UNION_PARTNER_ACCESS_TOKEN_URI', fallback: 'partner access token not found');
  String unionPartnerAccessTransferUri = dotenv.get('UNION_PARTNERACCESSTOKEN_TRANSFERS_URI',
      fallback: 'partner access token transfers scope uri not provided');

  Future<void> authorizeCustomer() async {
    var uScope = globalSettings['union_scopes'];
    await launchUrl(
      Uri.parse(
        '$unionCustomerAuthUri?client_id=$unionClientid&response_type=$unionResType&scope=$uScope&type=$unionType&partnerId=$unionPartnerid&redirect_uri=$unionRedirectURI'
      ),
      mode: LaunchMode.externalApplication
    );
  }

  Future<bool> load(ConnectionModel cm, double amount, String otp, String partnerAccessToken) async {
    bool result = false;
    if (await verifyOtp(cm, otp, partnerAccessToken)) {
      debugPrint('otp verified');
      final now = DateTime.now();
      String uniqueSendRefID = now.microsecondsSinceEpoch.toString();
      String connectionAccessToken = cm.connectionAccessToken ?? '';
      String requestId = cm.requestId ?? '';
      late String error = '';

      final DateTime currentTime = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');
      final String currentTimeFormatted = formatter.format(currentTime);

      Map<String, String> headers = {
        'accept': 'application/json',
        'content-Type': 'application/json',
        'x-ibm-client-id': unionClientid,
        'x-ibm-client-secret': unionClientSecretid,
        'x-partner-id': unionPartnerid,
        'authorization': 'Bearer $connectionAccessToken'
      };
      Map<String, Object> data = {
        'senderRefId': 'M$uniqueSendRefID',
        'tranRequestDate': currentTimeFormatted,
        'requestId': '2711C83E7AB7BFE8BB2729B3A8FC8DB1', //replace with requestId later
        'otp': otp,
        'amount': {'currency': 'PHP', 'value': amount.toString()},
        'remarks': 'Payment remarks',
        'particulars': 'Payment particulars',
        'info': [
          {'index': 1, 'name': 'Payor', 'value': 'Juan Dela Cruz'},
          {'index': 2, 'name': 'InvoiceNo', 'value': '12345'}
        ]
      };
      try {
        await HttpFacade()
          .create(Uri.parse(unionLoadUri), header: headers, json.encode(data))
          .then((value) => {
            if (value['ok'] && value['httpStatus'] == 201)
              {result = true}
          });
      } catch (e) {
        if (e.toString().contains('unauthorized')) {
          throw ExceptionHandlingProvider(401).generateExceptionResponse();
        }
      }
    }
    return result;
  }


  Future<bool> verifyOtp(ConnectionModel cm, String otp, String partnerAccessToken) async {
    bool result = false;
    String requestId = cm.requestId ?? '';
    Map<String, String> headers = {
      'accept': 'application/json',
      'content-Type': 'application/json',
      'x-ibm-client-id': unionClientid,
      'x-ibm-client-secret': unionClientSecretid,
      'authorization': 'Bearer $partnerAccessToken',
      'x-partner-id': unionPartnerid
    };
    Map<String, Object> data = {'requestId': requestId, 'pin': otp};
    try {
      await HttpFacade()
      .create(Uri.parse(unionVerifyOtpUri), header: headers, json.encode(data))
      .then((value) => {
        if ((json.decode(value['payload'])['message'] == 'OTP Verified')) {result = true}
      })
      .catchError((e) => print(e));
    } catch (e) {
      if (e.toString().contains('unauthorized')) {
        throw ExceptionHandlingProvider(401).generateExceptionResponse();
      }
    }
    return result;
  }

  Future<String> getOtp(String phone) async {
    String result = '';
    String partnerAccessToken = await getPartnerAccessToken('otp');
    sharedPreferences.setString('partner-access-token', partnerAccessToken);
    Map<String, String> headers = {
      'accept': 'application/json',
      'content-Type': 'application/json',
      'x-ibm-client-id': unionClientid,
      'x-ibm-client-secret': unionClientSecretid,
      'authorization': 'Bearer $partnerAccessToken',
      'x-partner-id': unionPartnerid
    };

    Map<String, Object> data = {
      'senderId': 'UnionBank', 
      'mobileNumber': phone.toString()
    };

    try {
      await HttpFacade()
      .create(Uri.parse(unionOtpUri), header: headers, json.encode(data))
      .then((value) => {
        if (value['ok'] && value['httpStatus'] == 200){
          result = jsonDecode(value['payload'])['requestId'].toString()
        }
      })
      .catchError((e) => print(e));
    } catch (e) {
      if (e.toString().contains('unauthorized')) {
        throw ExceptionHandlingProvider(401).generateExceptionResponse();
      }
    }
    return result;
  }

 Future<bool> unload(accountNumber, amount) async {
    String partnerAccessToken = '';
    bool resultedData = false;
    partnerAccessToken = await getPartnerAccessToken('transfers');
    try {
      if (partnerAccessToken != '') {
        // Need below for custom sender reference id
        final now = DateTime.now();
        String uniqueSendRefID = now.microsecondsSinceEpoch.toString();
        // Need below for transaction time format
        final DateTime currentTime = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');
        final String currentTimeFormatted = formatter.format(currentTime);

        //Headers fro Transfering from Partner to customer UB account
        Map<String, String> headersForUnload = {
          'x-ibm-client-id': unionClientid,
          'x-ibm-client-secret': unionClientSecretid,
          'x-partner-id': unionPartnerid,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': 'Bearer $partnerAccessToken'
        };

      Map<dynamic, dynamic> bodyForUnload = {
        'senderRefId': 'M$uniqueSendRefID', // Change this senderRefID every single run or it will show error.
        'tranRequestDate': currentTimeFormatted, // 2017-10-10T12:11:50.333
        'accountNo': accountNumber, // This is sandbox acc they gave us. testing account#: 109101707431
        'amount': {'currency': 'PHP', 'value': amount},
        'remarks': 'Withdraw - Merlink',
        'particulars': '',
        'info': [
          {'index': 1, 'name': 'Recipient', 'value': 'Mr Niaz'},
          {'index': 2, 'name': 'Message', 'value': 'Team Dinner pls'}
        ]
      };

        await HttpFacade()
            .create(
          Uri.parse(unionUnloadUri),
          json.encode(bodyForUnload),
          header: headersForUnload,
        )
            .then((value) {
          if (value['ok'] && value['httpStatus'] == 201) {
            resultedData = true;
          }
        }).catchError((error) => print(error));
      }
    } catch (e) {
      if (e.toString().contains('not-found')) {
        throw ExceptionHandlingProvider(404).generateExceptionResponse();
      }
      if (e.toString().contains('unauthorized')) {
        throw ExceptionHandlingProvider(401).generateExceptionResponse();
      }
      if (e.toString().contains('forbidden')) {
        throw ExceptionHandlingProvider(403).generateExceptionResponse();
      }
      if (e.toString().contains('method not allowed')) {
        throw ExceptionHandlingProvider(405).generateExceptionResponse();
      }
      if (e.toString().contains('conflict')) {
        throw ExceptionHandlingProvider(409).generateExceptionResponse();
      }
      if (e.toString().contains('Too Many Requests')) {
        throw ExceptionHandlingProvider(429).generateExceptionResponse();
      }
    }
    return resultedData;
  }

  Future<String> getPartnerAccessToken(String scope) async {
    String result = '';
    //Getting Access Token below
    Map<String, String> headersForAccessToken = {
      'accept': 'application/json',
      'content-type': 'application/x-www-form-urlencoded'
    };

    Map<dynamic, dynamic> bodyFieldsForAccToken = {
      'grant_type': 'password',
      'client_id': unionClientid,
      'username': unionPartnerUsername,
      'password': unionPartnerPassword,
      'scope': scope
    };

    try {
      await HttpFacade()
      .create(
        Uri.parse(unionPartnerAuthUri),
        json.decode(json.encode(bodyFieldsForAccToken)),
        header: headersForAccessToken,
      )
      .then((value) => {
          if (value['ok'] && value['httpStatus'] == 200) {
            result = jsonDecode(value['payload'])['access_token'],
          }
        }
      )
      .catchError((error) => print(error));
    } catch (e) {
      if (e.toString().contains('unauthorized')) {
        throw ExceptionHandlingProvider(401).generateExceptionResponse();
      }
    }
    return result;
  }
}

