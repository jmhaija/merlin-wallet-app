import 'package:client_app/ui/pages/my_wallet.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:flutter/material.dart';


class ToWallet extends StatelessWidget{
  const ToWallet({super.key});

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async=> false,
			child: Scaffold(
				appBar: AppbarWidget(
					actions: const [],
					routeBack: false, 
					subject: 'Wallet',
				),
				body: const MyWalletPage()
			)
		);
	}
}