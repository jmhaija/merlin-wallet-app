import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:client_app/utils/globals.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:client_app/managers/customer_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email = '';
  late String password = '';
  late bool emailOk;
  bool onPressed = false;

  CustomerManager customerManager = CustomerManager();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: WillPopScope(
                child: Scaffold( 
                    body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 400,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/merlinc-logo-white.png'),
                          fit: BoxFit.cover,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: ColorConstant.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(color: ColorConstant.darkblue, blurRadius: 15.0, offset: Offset(0, 3))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Form(
                                      key: _formKey,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      child: Column(children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: const BoxDecoration(
                                              border: Border(bottom: BorderSide(color: ColorConstant.bluegrey))),
                                          child: TextFormField(
                                            onChanged: (String? emailText) {
                                              setState(() {
                                                email = (emailText!).toLowerCase();
                                                emailOk = EmailValidator.validate(email);
                                              });
                                            },
                                            validator: (email) => email != null && !EmailValidator.validate(email)
                                                ? dictionaryObj['login_page']['EnterValidEmail']
                                                : null,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: dictionaryObj['hint_word']['EmailHint'],
                                              hintStyle: TextStyle(color: Colors.grey[400]),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            validator: (pass) =>
                                                pass == '' ? dictionaryObj['login_page']['EnterPass'] : null,
                                            obscureText: true,
                                            onChanged: (String? pass) {
                                              setState(() {
                                                password = pass!;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: dictionaryObj['hint_word']['PassHint'],
                                              hintStyle: TextStyle(color: Colors.grey[400]),
                                            ),
                                          ),
                                        )
                                      ]))
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            RoundRectButtonWidget(
                              subject: dictionaryObj['login_page']['Login'],
                              onPressed: () async {
                                if (email.isNotEmpty && password.isNotEmpty) {
                                  customerEntity.email = email;
                                  customerEntity.password = password;

                                  Map<String, dynamic> credentials = {
                                    'email': customerEntity.email.toString(),
                                    'password': customerEntity.password,
                                  };

                                  EasyLoading.show(status: dictionaryObj['login_page']['LoggingIn']);

                                  if (await customerManager.login(credentials)) {
                                    EasyLoading.showSuccess('Logged in successfully');
                                    Navigator.pushNamed(context, '/home_page');
                                  } else {
                                    EasyLoading.showError('Login attempt failed');
                                  }
                                } else {
                                  ShowDialog();
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                                style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontFamily: 'WorkSans'),
                                    foregroundColor: ColorConstant.midnight),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Text(dictionaryObj['NoAccount'])),
                            TextButton(
                                style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontFamily: 'WorkSans'),
                                    foregroundColor: ColorConstant.midnight),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/forgot_password_email');
                                },
                                child: Text(dictionaryObj['login_page']['ForgotPass']))
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
                onWillPop: () async => false));
      },
    ));
  }

  ShowDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(dictionaryObj['login_page']['Failed']),
        content: Text(dictionaryObj['login_page']['CorrectCred']),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, dictionaryObj['OK']),
            child: Text(dictionaryObj['OK']),
          ),
        ],
      ),
    );
  }
}
