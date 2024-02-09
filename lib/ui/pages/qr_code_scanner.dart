import 'dart:io';

import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/pages/send_money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:client_app/managers/wallet_manager.dart';
import 'package:client_app/utils/globals.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  QRCodeScannerState createState() => QRCodeScannerState();
}

class QRCodeScannerState extends State<QRCodeScanner> {
	final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
	Barcode? result;
	QRViewController? controller;
	@override
  void initState() {
		super.initState();
	}


	@override
	void reassemble() {
		super.reassemble();
		if(Platform.isAndroid) {
			controller!.pauseCamera();
		} else if (Platform.isIOS) {
			controller!.resumeCamera();
		}
	}
	
	 @override
	 Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: ColorConstant.white,
			body: Column(children: <Widget>[
				Expanded( 
					flex: 4,
					child: QRView(key: qrKey, onQRViewCreated: _onQrViewCreated,),
				),
				 Expanded(
					flex: 2,
					child: Center(
						child: Text(dictionaryObj['ScanQR'])
					),
				)
			]),
		);
	 }

	 void _onQrViewCreated(QRViewController controller) {
		this.controller = controller;
		List? data = [];

		controller.scannedDataStream.listen((scannedData) async {
			result = scannedData;
			// setState(() async {
			// });
			controller.pauseCamera();
			EasyLoading.show(status: dictionaryObj['send_money']['verifyingWalletAddress']);
      data = await WalletManager().getUserInfoByWalletAddress(result!.code.toString());
      if(data!.isEmpty) {
        EasyLoading.showError(dictionaryObj['send_money']['ErrorWhileRetrievingWallet']);
				controller.resumeCamera();
      } else {
				EasyLoading.showSuccess(dictionaryObj['send_money']['verifiedWalletAddress']);
				Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendMoney(walletAddress: result!.code.toString(),)));
			}
		});
	 }

	 @override
	 void dispose() {
		controller?.dispose();
		super.dispose();
	 }
}