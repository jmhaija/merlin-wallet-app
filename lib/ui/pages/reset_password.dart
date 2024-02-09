import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/providers/validators_provider.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:client_app/ui/widgets/round_rect_button.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, this.verificationemail, this.verificationCode});
  final verificationemail;
  final verificationCode;
  @override
  State<ResetPassword> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  bool signUpClicked = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password = '';
  final validator = ValidatorProvider();
  TextEditingController dateController = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  @override
  void initState() {
    dateController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Scaffold(
                  appBar: AppbarWidget(
                    subject: dictionaryObj['forgot_password']['ResetPassword'],
                    actions: const [],
                    routeBack: true,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 180),
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
                                              obscureText: true,
                                              controller: pass,
                                              validator: (password) => password != null &&
                                                      password.isNotEmpty &&
                                                      !validator.checkPasswordValidation(password)
                                                  ? dictionaryObj['password_page']['PasswordValidation']
                                                  : null,
                                              onChanged: (String? passwordText) {
                                                setState(() {
                                                  password = passwordText!;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                errorMaxLines: 3,
                                                border: InputBorder.none,
                                                hintText: dictionaryObj['hint_word']['NewPassHint'],
                                                hintStyle: TextStyle(color: Colors.grey[400]),
                                              ),
                                            ),
                                          ),
                                          Row(children: const <Widget>[Expanded(child: Divider())]),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              obscureText: true,
                                              validator: (password) => password != pass.text
                                                  ? dictionaryObj['password_page']['MatchPassword']
                                                  : null,
                                              onChanged: (String? passwordText) {
                                                setState(() {
                                                  password = passwordText!;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                errorMaxLines: 3,
                                                border: InputBorder.none,
                                                hintText: dictionaryObj['password_page']['ConfirmPassword'],
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
                                subject: dictionaryObj['forgot_password']['ResetPassword'],
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() && password.isNotEmpty) {
                                    customerEntity.password = password;
                                    Map<String, dynamic> newData = {
                                      'password': password,
                                    };
                                    EasyLoading.show(status: dictionaryObj['Loading']);
                                    customerManager
                                        .updatePassword(widget.verificationemail, newData, widget.verificationCode)
                                        .then((success) => {
                                              if (success)
                                                {
                                                  Navigator.pushReplacementNamed(context, '/login'),
                                                  EasyLoading.showSuccess(dictionaryObj['password_page']['SuccessPass'],
                                                      duration: const Duration(milliseconds: 50))
                                                }
                                              else
                                                {
                                                  EasyLoading.showError(
                                                      'Something went wrong. Could not create the password')
                                                }
                                            });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )));
        });
  }
}
