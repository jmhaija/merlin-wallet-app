import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/providers/validators_provider.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:client_app/ui/widgets/round_rect_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  bool signUpClicked = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String new_password = '';
  String old_password = '';
  final validator = ValidatorProvider();
  TextEditingController dateController = TextEditingController();
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  @override
  void initState() {
    dateController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: AppbarWidget(
          subject: dictionaryObj['forgot_password']['ResetPassword'],
          actions: const [],
          routeBack: true,
        ),
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
                                    controller: oldPass,
                                    validator: (password) => password != null &&
                                            password.isNotEmpty &&
                                            !validator.checkPasswordValidation(password)
                                        ? dictionaryObj['password_page']['PasswordValidation']
                                        : null,
                                    onChanged: (String? passwordText) {
                                      setState(() {
                                        old_password = passwordText!;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      errorMaxLines: 3,
                                      border: InputBorder.none,
                                      hintText: dictionaryObj['hint_word']['OldPassHint'],
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),
                                ),
                                Row(children: const <Widget>[Expanded(child: Divider())]),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: newPass,
                                    validator: (password) => password != null &&
                                            password.isNotEmpty &&
                                            !validator.checkPasswordValidation(password)
                                        ? dictionaryObj['password_page']['PasswordValidation']
                                        : null,
                                    onChanged: (String? passwordText) {
                                      setState(() {
                                        new_password = passwordText!;
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
                                    validator: (password) => password != newPass.text
                                        ? dictionaryObj['password_page']['MatchPassword']
                                        : null,
                                    onChanged: (String? passwordText) {
                                      setState(() {
                                        new_password = passwordText!;
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
                      subject: dictionaryObj['forgot_password']['ChangePass'],
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && new_password.isNotEmpty && old_password.isNotEmpty) {
                          customerEntity.password = new_password;
                          Map<String, dynamic> newData = {
                            'old_password': old_password,
                            'password': new_password,
                          };
                          String? myUserEmail = sharedPreferences.getString('user_email');
                          EasyLoading.show(status: dictionaryObj['Loading']);
                          customerManager.changePassword(myUserEmail, newData).then((success) => {
                                if (success)
                                  {
                                    Navigator.pushReplacementNamed(context, '/settings'),
                                    EasyLoading.showSuccess(dictionaryObj['password_page']['SuccessPass'],
                                        duration: const Duration(milliseconds: 50))
                                  }
                                else
                                  {EasyLoading.showError(dictionaryObj['forgot_password']['WrongPassword'] , dismissOnTap: true)}
                              });
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
