import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:client_app/ui/widgets/custom_button.dart';
import 'package:client_app/constants/color_constant.dart';

class QRGeneratorWidget extends StatefulWidget {
  QRGeneratorWidget({super.key, this.userInfo});

  String? userInfo;
  @override
  QRGeneratorWidgetState createState() => QRGeneratorWidgetState();
}

class QRGeneratorWidgetState extends State<QRGeneratorWidget> {
  final TextEditingController _dataController = TextEditingController();
  String? qrData;
  @override
  void initState() {
    super.initState();
    _dataController.text = widget.userInfo ?? '';
  }

  //user first and last under qr code
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child:Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: AppbarWidget(
          subject: 'QR Code Address',
          actions: const [],
          routeBack: false,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(35),
              child: Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(2),
                  child: QrImage(
                    data: sharedPreferences.getString('wallet_address').toString(),
                    version: QrVersions.auto,
                    size: 200,
                    gapless: false,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                    height: 50,
                    width: 170,
                    text: 'Scan QR Code'.tr,
                    variant: ButtonVariant.FillLightBlue50026,
                    fontStyle: ButtonFontStyle.PoppinsMedium14,
                    prefixWidget: Container(
                        margin: getMargin(right: 3), child: Icon(Icons.qr_code_scanner, color: ColorConstant.gray50)),
                    onTap: () => {Navigator.pushNamed(context, '/qr-code-scanner')}),
                const SizedBox(height: 30),
                TextField(
                  enabled: false,
                  controller: _dataController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.00)))),
                )
              ]),
            )
          ],
        )
      )
    );
  }
}
