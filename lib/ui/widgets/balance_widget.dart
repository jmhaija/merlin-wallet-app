import 'package:auto_size_text/auto_size_text.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/domain/models/wallet_model.dart';
import 'package:client_app/utils/size_utils.dart';
import 'package:flutter/material.dart';

import 'package:client_app/utils/globals.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BalanceWidget extends StatefulWidget {

  const BalanceWidget({Key? key , required this.flag}) : super(key: key);

  final bool flag;
  @override
  BalanceWidgetState createState() => BalanceWidgetState();
}

class BalanceWidgetState extends State<BalanceWidget> {
  String accountNumberPlaceHolder = '';
  static final _locale = countryConfigs['currency_locale'];
  static final format = NumberFormat.simpleCurrency(locale: _locale);
  static final currencySymbol = format.currencySymbol;
  static dynamic customerData;

  Future<dynamic> getWalletBalance() async {
    customerData = customerEntity.getResource();
    WalletModel wallet = await walletManager.getWalletInfo(sharedPreferences.getString('user_id')!);
    return wallet.getResource()['wallet_balance'];
  }

  String walletHolderName() => customerData['profile'] != null &&
        customerData['profile']['profile_firstname'] != null &&
        customerData['profile']['profile_firstname'] != '' &&
        customerData['profile']['profile_lastname'] != null &&
        customerData['profile']['profile_lastname'] != ''
    ? '${customerData['profile']['profile_firstname']} ${customerData['profile']['profile_lastname']}'.toUpperCase()
    : sharedPreferences.getString('user_email').toString().toLowerCase();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getWalletBalance(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return const SizedBox();
            } else {
              final balance = snapshot.data;
              final value = NumberFormat('#,##0.00', 'en_US');
              return Center(
                child: Container(
                  width: getHorizontalSize(300.00),
                  padding: getPadding(left: 18, top: 17, right: 18, bottom: 17),
                  decoration: const BoxDecoration(
                    color: ColorConstant.darkblue,
                  ).copyWith(
                    borderRadius: BorderRadius.circular(getHorizontalSize(12.00)),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/blue_wave_background.png'),
                      fit: BoxFit.cover
                    )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Available Balance
                      Padding(
                        padding: getPadding(top: 1),
                        child: Text(
                          'Available Balance'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant.whiteA700,
                            fontSize: getFontSize(10.45),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ).copyWith(height: getVerticalSize(1.00))
                        )
                      ),
                      // show balance with currency
                      Padding(
                        padding: getPadding(top: 34),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: AutoSizeText(
                                  '$currencySymbol ${value.format(balance).toString()}'.tr,
                                  style: TextStyle(
                                    color: ColorConstant.whiteA70001,
                                    fontSize: 50,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                  ).copyWith(
                                    letterSpacing: getHorizontalSize(0.36), height: getVerticalSize(1.00)
                                  ),
                                  maxLines: 1,
                                  minFontSize: 20,
                                )
                              )
                            )
                          ],
                        )
                      ),
                      // wallet holder name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,                        
                        children: [
                          if( widget.flag == false ) ... [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child:ElevatedButton.icon(
                                onPressed: ()=> {
                                  globalSettings['environment'] == 'production'
                                    ? showComingSoonToast()
                                    : Navigator.pushNamed(context, '/my-wallet')
                                }, 
                                icon: const Icon(Icons.wallet), 
                                label: const Text('Go to wallet'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstant.lightBlue50026,
                                ),
                              )
                            )
                          ] else ... [
                            const Padding(padding: EdgeInsets.all(20))
                          ],
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              walletHolderName(),
                              softWrap: true,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                color: ColorConstant.whiteA700,
                                fontSize: getFontSize(11.94),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ).copyWith(
                                letterSpacing: getHorizontalSize(1.19), 
                                height: getVerticalSize(2.00)
                              )
                            )
                          ),
                        ] ,
                      )
                    ]
                  ),
                )
              );
            }
        }
      },
    );
  }
}
