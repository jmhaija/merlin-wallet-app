import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/domain/models/connection_model.dart';
import 'package:client_app/providers/bank_provider.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';

import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ApplyOTPNumber extends StatefulWidget {
  ApplyOTPNumber({super.key, this.connectId});

  String? connectId;
  @override
  ApplyOTPNumberState createState() => ApplyOTPNumberState();
}

class ApplyOTPNumberState extends State<ApplyOTPNumber> {

  String dialCode = '';
  String phone = '';
  List<dynamic> otpCode = [];
  TextEditingController phontTextController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: countryConfigs['isoCode']);
  ConnectionModel connectionModel = ConnectionModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: AppbarWidget(actions: const [], routeBack: true, subject: dictionaryObj['otp']['PhoneVerify']),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 120),
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(children: [
                            InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                dialCode = number.dialCode as String;
                                phone = phontTextController.text;
                              },
                              onInputValidated: (bool value) {
                                phone = value ? phontTextController.text : '';
                              },
                              selectorConfig: const SelectorConfig(
                                trailingSpace: false,
                                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.onUserInteraction,
                              initialValue: number,
                              textFieldController: phontTextController,
                              formatInput: false,
                              keyboardType: const TextInputType.numberWithOptions(),
                            ),
                            const SizedBox(height: 30),
                            RoundRectButtonWidget(
                              subject: dictionaryObj['otp']['Send'],
                              onPressed: () async {
                                if (phone.isEmpty) {
                                  await EasyLoading.showInfo(dictionaryObj['enter_otp']['PhoneNum']);
                                } else {
                                  connectionModel = await connectionManager.getConnectionByConnectionId(widget.connectId.toString());
                                  connectionModel.requestId = await BankProvider().getOtp(phone);
                                  if (connectionModel.requestId != '') {
                                    Navigator.pushNamed(context, '/otp');
                                  } else {
                                    EasyLoading.showError(dictionaryObj['enter_otp']['Failed']);
                                    debugPrint('There are no requestId');
                                  }
                                }
                              },
                            ),
                          ]),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
