import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/providers/bank_provider.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class OTP extends StatefulWidget {
  const OTP({
    super.key,
  });
  @override
  State<OTP> createState() => _OTPStatePage();
}
bool isOnTimer = true;

class _OTPStatePage extends State<OTP> {
  List<dynamic> otpCode = [];
  var otpController1 = TextEditingController();
  var otpController2 = TextEditingController();
  var otpController3 = TextEditingController();
  var otpController4 = TextEditingController();
  var otpController5 = TextEditingController();
  var otpController6 = TextEditingController();
  String stringOtpCode = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      isOnTimer = true;
    });
    return Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: AppbarWidget(actions: const [], routeBack: true, subject: dictionaryObj['otp']['OTP']),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(children: [
                            const SizedBox(height: 30),
                            buildTimer(59),
                            Form(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SingleOtpCodeField(context, otpCode, otpController1),
                                SingleOtpCodeField(context, otpCode, otpController2),
                                SingleOtpCodeField(context, otpCode, otpController3),
                                SingleOtpCodeField(context, otpCode, otpController4),
                                SingleOtpCodeField(context, otpCode, otpController5),
                                SingleOtpCodeField(context, otpCode, otpController6),
                                const SizedBox(height: 30),
                              ],
                            )),
                            const SizedBox(height: 30),
                            RichText(
                            text: TextSpan(
                                text: dictionaryObj['otp']['Resend'],
                                style: const TextStyle(color: ColorConstant.midnight),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    setState(() {
                                      otpCode = [];
                                    });
                                    otpController1.clear();
                                    otpController2.clear();
                                    otpController3.clear();
                                    otpController4.clear();
                                    otpController5.clear();
                                    otpController6.clear();
                                    connectionManager.connectionModelInstance.requestId = await BankProvider().getOtp(sharedPreferences.getString('phone')!);
                                  }
                                )
                              ),
                            const SizedBox(height: 30),
                            RoundRectButtonWidget(
                              subject: dictionaryObj['otp']['Confirm'],
                              onPressed: () async {
                                for (var code in otpCode) {
                                  stringOtpCode += code;
                                }
                                if (!isOnTimer) {
                                  EasyLoading.showError(dictionaryObj['otp']['VerificationExpired']);
                                  Navigator.pushReplacementNamed(context, '/my-wallet');
                                  return;
                                } else if(stringOtpCode.isEmpty){
                                  await EasyLoading.showInfo(dictionaryObj['otp']['VericationCode']);
                                } else if (stringOtpCode.length == 6) {
                                  if (await BankProvider().load(
                                      connectionManager.connectionModelInstance,
                                      double.parse(sharedPreferences.getDouble('load_amount')!.toStringAsFixed(2)),
                                      stringOtpCode,
                                      sharedPreferences.getString('partner-access-token')!)) {
                                    debugPrint(dictionaryObj['otp']['SuccessLoadMoney']);
                                    await walletManager.updateWallet({
                                      'walletData': {
                                        'wallet_id': sharedPreferences.getString('wallet_id'),
                                        'wallet_balance': double.parse(sharedPreferences.getDouble('wallet_balance')!.toStringAsFixed(2))
                                      }
                                    });
                                    await EasyLoading.showSuccess('\$${sharedPreferences.getDouble('load_amount')!} loaded to your wallet successfully!');
                                    sharedPreferences.remove('phone');
                                    sharedPreferences.remove('load_amount');
                                    Navigator.pushReplacementNamed(context, '/my-wallet');
                                  } else {
                                    await EasyLoading.showError(dictionaryObj['loading']['ErrorMessage']);
                                    Navigator.pushReplacementNamed(context, '/my-wallet');
                                    debugPrint('loading failed');
                                  }
                                } else {
                                  await EasyLoading.showInfo(dictionaryObj['otp']['ValidVerificationCode']);
                                  debugPrint(dictionaryObj['otp']['ValidOTP']);
                                  otpController1.clear();
                                  otpController2.clear();
                                  otpController3.clear();
                                  otpController4.clear();
                                  otpController5.clear();
                                  otpController6.clear();
                                  otpCode.clear();
                                }
                                stringOtpCode = '';
                              }
                            ),
                          ]),
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
  
  SingleOtpCodeField(BuildContext context, List<dynamic> otpCode, otpController) {
    return SizedBox(
      height: 30,
      width: 30,
      child: TextField(
        controller: otpController,
        onChanged: (value) {
          if(value == ''){
            otpCode.removeLast();
          }
          FocusScope.of(context).nextFocus();
          otpCode.add(value);
        },
        style: Theme.of(context).textTheme.headline6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Row buildTimer(int time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(dictionaryObj['otp']['ExpireMsg']),
        TweenAnimationBuilder(
          tween: Tween(begin: 59.0, end: 0.0),
          duration: Duration(seconds: time),
          builder: (context, value, child) =>
              Text('00:${value.toInt()}', style: const TextStyle(color: ColorConstant.lightblue)),
          onEnd: () {
            isOnTimer = false;
          },
        ),
      ],
    );
  }
}