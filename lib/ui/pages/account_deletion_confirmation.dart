

import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';

class AccountDeletionConfirmationPage extends StatefulWidget {
  const AccountDeletionConfirmationPage({super.key});

  @override
  _AccountDeletionConfirmationPageState createState() => _AccountDeletionConfirmationPageState();
}

class _AccountDeletionConfirmationPageState extends State<AccountDeletionConfirmationPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
			appBar: AppbarWidget(actions:const [], routeBack: false, subject: ''),
			backgroundColor: ColorConstant.white,
			body: Center(
				child: Padding(
					padding: const EdgeInsets.all(30.0),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
						 Text(
								dictionaryObj['delete_account']['DeletedSuccessfully'],
								style: const TextStyle(
									fontSize: 15,
									color: ColorConstant.black,
									decorationColor: null,
									decoration: TextDecoration.none,
									fontWeight: FontWeight.normal,
								),
								textAlign: TextAlign.left,
							),
							const SizedBox(height: 20),
							ElevatedButton(
								onPressed: () =>  Navigator.pushNamed(context, '/logout'),
								style: ElevatedButton.styleFrom(
									backgroundColor: ColorConstant.midnight,
								),
								child: Text(
									dictionaryObj['chat']['confirmButton'],
								)
							)
						]
					)
				)	
			)
		);
  }
}