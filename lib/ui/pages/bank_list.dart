import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';

class AddBankPage extends StatefulWidget {
  const AddBankPage({super.key});

  @override
  AddBankPageState createState() => AddBankPageState();
}

class AddBankPageState extends State<AddBankPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        actions: const [], 
        routeBack: true, 
        subject: dictionaryObj['banks']['AddBanks']
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 55),
        child: Center(
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              splashColor: ColorConstant.splashColor,
              onTap: () async {
                sharedPreferences.setString('bank_id', '123');
                Navigator.pop(context);
                Navigator.pushNamed(context, '/account');
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Ink.image(
                    image: const AssetImage('./assets/images/ublogo.png'),
                    width: 135,
                    height: 65,
                    fit: BoxFit.fitHeight,
                  ),
                  Text(
                    dictionaryObj['banks']['UnionBank'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
