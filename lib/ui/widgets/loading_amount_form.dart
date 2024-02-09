import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/domain/models/wallet_model.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:client_app/providers/validators_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'package:client_app/ui/pages/OTP_phone_number.dart';

class LoadingForm {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final validator = ValidatorProvider();
  String amount = '';
  static const _locale = 'fil';
  static final format = NumberFormat.simpleCurrency(locale: _locale);
  static final _symbol = format.currencySymbol;
  CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(locale: _locale, enableNegative: false, symbol: '$_symbol ');
      
  void showLoadingAmountForm(connection, context) {
    double sum;
    double walletBalance;
    WalletModel wallet;
    double amountInput_ = 0.0;
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              height: 400,
              color: ColorConstant.white,
              child: Column(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 25)),
                  Center(
                      child: Text(dictionaryObj['loading']['EnterAmount'],
                          style: const TextStyle(
                              fontSize: 32, color: ColorConstant.midnight, fontWeight: FontWeight.w500))),
                  Padding(
                    padding: const EdgeInsets.only(top: 65, bottom: 25, left: 30, right: 30),
                    child: TextFormField(
                        style: const TextStyle(fontSize: 15),
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _controller,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, currencyTextInputFormatter],
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                              left: 20,
                            ),
                            hintText: dictionaryObj['hint_word']['AmountHint'],
                            border: const UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(100.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                            )),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (amountInput) {
                          amount = amountInput;
                          amountInput = amountInput.replaceAll(_symbol, '');
                          amountInput = amountInput.replaceAll(',', '');
                          amountInput_ = double.parse(amountInput);
                        }),
                  ),
                  ElevatedButton.icon(
                      icon: const Icon(Icons.file_download_outlined, size: 35.0),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        backgroundColor: ColorConstant.midnight,
                        foregroundColor: ColorConstant.white
                      ),
                      onPressed: () async => {
                            if (_controller.text.isEmpty)
                              {await EasyLoading.showInfo(dictionaryObj['loading']['LoadingValidation'])}
                            else
                              {
                                wallet = await walletManager.getWalletInfo(sharedPreferences.getString('user_id')!),
                                walletBalance = double.parse(wallet.getResource()['wallet_balance'].toString()),
                                sharedPreferences.setDouble('load_amount', amountInput_),
                                sum = amountInput_ + walletBalance,
                                sharedPreferences.setDouble('wallet_balance', sum),
                                _controller.clear(),
                                // Navigator.pop(context),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ApplyOTPNumber(connectId: connection)),),
                                // Navigator.pushNamed(context, '/otp_number')
                              }
                          },
                      label: Text(dictionaryObj['loading']['AddButton']))
                ],
              ));
        });
  }
}
