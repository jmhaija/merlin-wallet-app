import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/providers/validators_provider.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:url_launcher/url_launcher.dart';

class EmailRegistrationPage extends StatefulWidget {
  const EmailRegistrationPage({super.key});

  @override
  State<EmailRegistrationPage> createState() => _EmailRegistrationPageState();
}

class _EmailRegistrationPageState extends State<EmailRegistrationPage> {
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  final validator = ValidatorProvider();
  bool isTOSChecked = false;
  bool signUpClicked = true;
  String password = '';
  TextEditingController dateController = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  late var email = '';

  @override
  void initState() {
    dateController.text = ''; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Scaffold(
                  appBar: AppbarWidget(
                    subject: dictionaryObj['registration_page']['EmailRegistration'],
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
                                        key: _registrationFormKey,
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
                                          Row(children: const <Widget>[Expanded(child: Divider())]),
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
                                                hintText: dictionaryObj['hint_word']['PassHint'],
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
                              CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text.rich(TextSpan(
                                    text: dictionaryObj['TOS'],
                                    style: const TextStyle(fontSize: 13, color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: dictionaryObj['ClickableTOS'],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              await launchUrl(Uri.parse('https://merlinpayments.com/privacy.html'));
                                            }),
                                    ])),
                                checkColor: ColorConstant.bluegrey,
                                value: isTOSChecked,
                                onChanged: (bool? value) {
                                  setState(() => {isTOSChecked = value!});
                                },
                              ),
                              const SizedBox(height: 10),
                              RoundRectButtonWidget(
                                subject: dictionaryObj['start']['SignUp'],
                                onPressed: signUpClicked
                                    ? () async {
                                        if (_registrationFormKey.currentState!.validate() && isTOSChecked && email.isNotEmpty && password.isNotEmpty) {
                                          customerEntity.email = email;
                                          Map<String, dynamic> userData = {'email': email, 'password': password};
                                          setState(() {
                                            signUpClicked = false;
                                          });
                                          customerManager.createUser(userData).then((success) async => {
                                                if (success)
                                                  {
                                                    //sharedPreferences.setString('user_status', dictionaryObj['user_status']['Secure']),
                                                    sharedPreferences.remove('user_email'),
                                                    await ChatProvider.addUser({
                                                      'userId': sharedPreferences.getString('user_id'),
                                                      'userEmail': userData['email'],
                                                    }),
                                                    if (await customerManager.login(userData))
                                                      {
                                                        EasyLoading.dismiss(),
                                                        Navigator.pushNamed(context, '/home_page')
                                                      },
                                                    EasyLoading.showSuccess(
                                                        dictionaryObj['registration_page']['SuccessEmail'],
                                                        duration: const Duration(milliseconds: 50))
                                                  }
                                                else
                                                  {
                                                    setState(() {
                                                      signUpClicked = true;
                                                    }),
                                                    EasyLoading.dismiss(),
                                                    showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                                title: Text(
                                                                    dictionaryObj['registration_page']['EmailExists']),
                                                                content: Text(dictionaryObj['registration_page']
                                                                    ['EnterValid']),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed: () => Navigator.pop(context, 'OK'),
                                                                    child: Text(dictionaryObj['OK']),
                                                                  ),
                                                                ]))
                                                  }
                                              });
                                        } else {
                                          setState(() {
                                            signUpClicked = true;
                                          });
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Text(dictionaryObj['registration_page']['Error']),
                                              content: Text(dictionaryObj['registration_page']['EnterValid']),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'OK'),
                                                  child: Text(dictionaryObj['OK']),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontFamily: 'WorkSans'),
                                      foregroundColor: ColorConstant.midnight),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login', arguments: <String, String>{'email': email});
                                  },
                                  child: Text(dictionaryObj['HaveAccount']))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )));
        }));
  }
}
