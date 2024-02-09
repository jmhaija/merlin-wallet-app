import 'package:client_app/ui/pages/verification_code.dart';
import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/providers/validators_provider.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ForgotPasswordEmail extends StatefulWidget {
  const ForgotPasswordEmail({super.key});

  @override
  State<ForgotPasswordEmail> createState() => _ForgotPasswordEmail();
}

class _ForgotPasswordEmail extends State<ForgotPasswordEmail> {
  bool flag = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final validator = ValidatorProvider();
  late var email = '';

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppbarWidget(
      subject: dictionaryObj['forgot_password']['ForgotPassword'],
      actions: const [],
      routeBack: true,
    ),
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 200),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: ColorConstant.midnight, blurRadius: 15.0, offset: Offset(0, 3))
                      ]),
                  child: Column(
                    children: <Widget>[
                      Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autocorrect: false,
                                validator: (email) => email != null &&
                                        email.isNotEmpty &&
                                        !validator.checkEmailValidation(email)
                                    ? dictionaryObj['login_page']['EnterValidEmail']
                                    : null,
                                onChanged: (String? emailText) {
                                  setState(() => {email = emailText!.toLowerCase()});
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: dictionaryObj['hint_word']['EmailHint'],
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                          ]))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                RoundRectButtonWidget(
                  subject: dictionaryObj['forgot_password']['ConfirmEmail'],
                  onPressed: () {
                    if (_formKey.currentState!.validate() && email.isNotEmpty) {
                      customerEntity.email = email;
                      String newData = email;

                      EasyLoading.show(status: dictionaryObj['Loading']);
                      customerManager.sendEmailVerificationCode(newData).then((result) => {
                            if (result['success'])
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerificationCode(verificationemail: newData),
                                    )),
                                EasyLoading.showSuccess(dictionaryObj['forgot_password']['EmailSent'],
                                    duration: const Duration(milliseconds: 50))
                              }
                            else
                              {
                                EasyLoading.dismiss(),
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: Text(dictionaryObj['forgot_password']['EmailNotExist']),
                                    content: Text(dictionaryObj['forgot_password']['ChooseOtherEmail']),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                ),
                              }
                          });
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(dictionaryObj['registration_page']['Error']),
                          content: Text(dictionaryObj['forgot_password']['ChooseOtherEmail']),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  } 
}
