import 'dart:io';

import 'package:client_app/domain/models/wallet_model.dart';
import 'package:client_app/providers/storage_service_provider.dart';
import 'package:client_app/providers/validators_provider.dart';
import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'package:client_app/managers/wallet_manager.dart';

import 'package:client_app/providers/biometric_authentication_provider.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key, this.recipientInfo, this.walletAddress});

  final Map<String, dynamic>? recipientInfo;
  final String? walletAddress;
  @override
  _SendMoney createState() => _SendMoney();
}

class _SendMoney extends State<SendMoney> {
  Size size = WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio;
  Map<String, dynamic> customerData = {};

  dynamic addressObj;

  String imagePath = '';
  String _displayEmail = '';
  String _displayFullname = '';
  List? allUserInfo;
  final TextEditingController _passwordController = TextEditingController();

  dynamic _profile_image_file;
  final ImagePicker picker = ImagePicker();
  static const _locale = 'fil';
  static final format = NumberFormat.simpleCurrency(locale: _locale);
  final _controller = TextEditingController();
  final validator = ValidatorProvider();
  bool authenticated = false;

  String amount = '';
  late double sum;
  late double walletBalance;
  late WalletModel wallet;
  double amountInput_ = 0.0;

  static final _symbol = format.currencySymbol;
  CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(locale: _locale, symbol: '$_symbol ');

  bool routeBack = false;

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        automaticallyImplyLeading: routeBack,
        backgroundColor: ColorConstant.midnight,
      ),
      backgroundColor: ColorConstant.midnight,
      body: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _profile_image_file != null
                    ? getProfileImage(FileImage(_profile_image_file))
                    : getProfileImage(const AssetImage('assets/images/images.png')),
                const SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: Column(children: [
                      Text(
                        _displayFullname,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ColorConstant.white,
                          fontSize: 20,
                          fontFamily: 'Caros',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                      Text(
                        _displayEmail,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ColorConstant.white,
                          fontSize: 15,
                          fontFamily: 'Caros',
                          height: 1.25,
                        ),
                      ),
                    ])),
                const Padding(padding: EdgeInsets.only(top: 30)),
              ],
            ),
            Expanded(
              child: Container(
                width: size.width,
                padding: const EdgeInsets.only(left: 50, right: 50, top: 80),
                decoration: const BoxDecoration(
                  color: ColorConstant.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.00),
                    topRight: Radius.circular(40.00),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(fontSize: 20),
                        // key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _controller,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, currencyTextInputFormatter],
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                              left: 20,
                            ),
                            hintText: dictionaryObj['hint_word']['AmountHint'],
                            border: const UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                            )),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (amountInput) {
                          setState(() {
                            if (amountInput.isEmpty) {
                              amountInput_ = 0.0;
                            } else {
                              amount = amountInput;
                              amountInput = amountInput.replaceAll(_symbol, '');
                              amountInput = amountInput.replaceAll(',', '');
                              amountInput_ = double.parse(amountInput);
                            }
                          });
                        }
                      ),
                      const SizedBox(height: 30),
                      RoundRectButtonWidget(
                        subject: dictionaryObj['search']['SendMoney'],
                        onPressed: amountInput_ != 0.0
                          ? () async {
                              await securityCheck();
                              if (authenticated) Navigator.pushNamed(context, '/transaction_receipt_page');
                            }
                          : null,
                      ),
                    ],
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getProfileData() async {
    String internalEmail = '';

    if (widget.walletAddress != '' && widget.walletAddress != null && widget.recipientInfo == null) {
      String walletAd = widget.walletAddress.toString();
      // EasyLoading.show(status: dictionaryObj['send_money']['verifyingWalletAddress']);
      allUserInfo = await WalletManager().getUserInfoByWalletAddress(walletAd);
      // if(allUserInfo!.isEmpty) {
      //   EasyLoading.showError(dictionaryObj['send_money']['ErrorWhileRetrievingWallet']);
      //   Navigator.of(context, rootNavigator: false).pop();
      // }

      _displayEmail = allUserInfo![0]['user_info'][0]['user_email'].toString();
      internalEmail = allUserInfo![0]['user_info'][0]['user_id'].toString();
    }

    customerManager
        .getProfileData(internalEmail != '' ? internalEmail : widget.recipientInfo!['userId'])
        .then((value) => {
              _displayFullname = value['resources']['profile']['profile_firstname'] +
                  ' ' +
                  value['resources']['profile']['profile_lastname'],
              sharedPreferences.setString('receiver_fullname', _displayFullname),
              if (value['success'])
                {
                  if (value['resources']['profile']['profile_image_path'] != null)
                    {
                      StorageServiceProvier()
                          .retrieveFile(value['resources']['profile']['profile_image_path'])
                          .then((value) => {setState(() => _profile_image_file = value)})
                    }
                }
              else
                {
                  _profile_image_file = null,
                }
            });
    setState(() {});
    _displayEmail = widget.recipientInfo!['userEmail'].toString();
  }

  Future<void> securityCheck() async {
    BuildContext dialogContext;
    authenticated = false;
    if (sharedPreferences.getBool('is_auth_enabled') != null && sharedPreferences.getBool('is_auth_enabled')! == true) {
      EasyLoading.show(status: dictionaryObj['chat']['verifying']);
      bool isAuthenticated = await BiometricAuthenticationProvider().authenticateUser();
      if (isAuthenticated) {
        EasyLoading.showSuccess('Verified successfully');
        sharedPreferences.setDouble('amount_sent', amountInput_);
        sharedPreferences.setString('receiver_email', _displayEmail);
        Navigator.pushNamed(context, '/transaction_receipt_page');
      } else {
        EasyLoading.showError('Verification failed');
      }
    } else {
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            dialogContext = context;
            return SimpleDialog(
                key: GlobalKey(),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                title: Text(dictionaryObj['chat']['sendMoneyConfirm']),
                contentPadding: const EdgeInsets.all(30.0),
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  RoundRectButtonWidget(
                      subject: dictionaryObj['chat']['confirmButton'],
                      onPressed: () async {
                        if (await customerManager.authenticateUser(_passwordController.text)) {
                          setState(() => authenticated = true);
                          _passwordController.clear();
                          await sharedPreferences.setDouble('amount_sent', amountInput_);
                          await sharedPreferences.setString('receiver_email', _displayEmail);
                          Navigator.of(context, rootNavigator: false).pop();
                        } else {
                          _passwordController.clear();
                          EasyLoading.showError(dictionaryObj['chat']['passwordMsg']);
                        }
                      }),
                ]);
          });
    }
  }

  String getCurrency() {
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencySymbol;
  }

  CircleAvatar getProfileImage(selectedImage) {
    return CircleAvatar(
      radius: 58,
      backgroundImage: selectedImage,
    );
  }
}
