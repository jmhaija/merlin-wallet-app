import 'package:client_app/providers/bank_provider.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/providers/validators_provider.dart';

class Account extends StatefulWidget {

  const Account({super.key});
  @override
  State<Account> createState() => _Account();
}

class _Account extends State<Account> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String account = '';
  final validator = ValidatorProvider();
  TextEditingController accountController = TextEditingController();

  @override
  void initState() {
    accountController.text = ''; 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        actions: const [],
        routeBack: true,
        subject: dictionaryObj['account_page']['Account']
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
                        BoxShadow(
                          color: ColorConstant.midnight,
                          blurRadius: 15.0,
                          offset: Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (account) => account != null && account.isNotEmpty
                                  ? null
                                  : dictionaryObj['account_page']['SetAccount'],
                                onChanged: (String? accountText) {
                                  setState(() { account = accountText!;});
                                },
                                decoration: InputDecoration(
                                  errorMaxLines: 3,
                                  border: InputBorder.none,
                                  hintText: dictionaryObj['hint_word']['AccountHint'],
                                  hintStyle: const TextStyle(
                                    color: ColorConstant.bluegrey
                                  ),
                                ),
                              ),
                            ),
                            
                          ]),
                        ),
                      ]
                    )
                  ),
                  const SizedBox(height: 20),
                  RoundRectButtonWidget(
                    subject: dictionaryObj['account_page']['SetAccount'],
                    onPressed: () async {
                      sharedPreferences.setString('connection_account_number', account);
                      await BankProvider().authorizeCustomer();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}