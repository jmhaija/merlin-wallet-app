import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/pages/reset_password.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VerificationCode extends StatefulWidget {
  VerificationCode({
    this.verificationemail,
    super.key,
  });
  String? verificationemail;
  @override
  State<VerificationCode> createState() => _VerificationCode();
}

class _VerificationCode extends State<VerificationCode> {
  var otpController1 = TextEditingController();

  bool timerZero = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Scaffold(
                  appBar: AppbarWidget(actions: const [], routeBack: true, subject: dictionaryObj['otp']['OTP']),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(children: [
                                      buildTimer(60),
                                      const SizedBox(height: 30),
                                      Form(
                                          child: Column(children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: ColorConstant.midnight,
                                                    blurRadius: 15.0,
                                                    offset: Offset(0, 3))
                                              ]),
                                          child: TextFormField(
                                            controller: otpController1,
                                            onChanged: (String? code) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(color: Colors.grey[400]),
                                              hintText: dictionaryObj['hint_word']['VerificationCode'],
                                            ),
                                          ),
                                        ),
                                      ])),
                                      const SizedBox(height: 30),
                                      RoundRectButtonWidget(
                                          subject: dictionaryObj['otp']['Confirm'],
                                          onPressed: () async {
                                            if (timerZero) {
                                              EasyLoading.showError(dictionaryObj['otp']['VerificationExpired']);
                                              return;
                                            } else if (otpController1.text == '') {
                                              await EasyLoading.showInfo(dictionaryObj['otp']['VericationCode']);
                                            } else if (otpController1.text.length == 5) {
                                              customerManager
                                                  .validateCode(
                                                      widget.verificationemail, int.parse(otpController1.text))
                                                  .then((value) => {
                                                        if (value)
                                                          {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ResetPassword(
                                                                    verificationemail: widget.verificationemail,
                                                                    verificationCode: int.parse(otpController1.text),
                                                                  ),
                                                                )),
                                                          }
                                                        else
                                                          {
                                                            EasyLoading.showError(
                                                                dictionaryObj['forgot_password']['WrongCode']),
                                                          }
                                                      });
                                            } else {
                                              await EasyLoading.showInfo(dictionaryObj['otp']['ValidVerificationCode']);
                                              debugPrint(dictionaryObj['otp']['ValidOTP']);
                                              otpController1.clear();
                                            }
                                          }),
                                    ]),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }

  // ignore: non_constant_identifier_names
  SingleOtpCodeField(BuildContext context, List<dynamic> otpCode, otpController) {
    return SizedBox(
      height: 30,
      width: 30,
      child: TextField(
        controller: otpController,
        onChanged: (value) {
          if (value == '') {
            otpCode.removeLast();
          }
          FocusScope.of(context).nextFocus();
          otpCode.add(value);
        },
        style: Theme.of(context).textTheme.headline5,
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
          builder: (context, value, child) => !timerZero
              ? Text('00:${value.toInt()}', style: const TextStyle(color: ColorConstant.lightblue))
              : RichText(
                  text: TextSpan(
                      text: dictionaryObj['otp']['Resend'],
                      style: const TextStyle(color: ColorConstant.midnight),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          setState(() {
                            timerZero = false;
                          });
                          otpController1.clear();
                          customerManager.sendEmailVerificationCode(widget.verificationemail).then((result) => {
                                if (result['success'])
                                  {
                                    Navigator.pop(context),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VerificationCode(verificationemail: widget.verificationemail),
                                        )),
                                    EasyLoading.showSuccess(dictionaryObj['forgot_password']['EmailSent'],
                                        duration: const Duration(milliseconds: 50))
                                  }
                              });
                        })),
          onEnd: () {
            setState(() {
              timerZero = true;
            });
          },
        ),
      ],
    );
  }
}
