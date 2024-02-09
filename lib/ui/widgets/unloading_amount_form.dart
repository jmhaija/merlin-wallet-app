import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/domain/models/wallet_model.dart';
import 'package:client_app/providers/bank_provider.dart';
import 'package:client_app/utils/globals.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class UnloadingForm {
  final _controller = TextEditingController();
  static const _locale = 'fil';
  static final format = NumberFormat.simpleCurrency(locale: _locale);
  static final _symbol = format.currencySymbol;
  CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(locale: _locale, enableNegative: false, symbol: '$_symbol ');
  late double sum;
  final _accountController = TextEditingController();
  double amountInput_ = 0.0;
  String accountNumber = '';
  Future<String> getWalletBalance() async {
    WalletModel wallet = await walletManager.getWalletInfo(sharedPreferences.getString('user_id')!);
    return wallet.getResource()['wallet_balance'].toString();
  }

  void showUnloadingAmountForm(context, {accountNumber, connId}) {
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
              child: Column(children: <Widget>[
                const Padding(padding: EdgeInsets.only(top: 25)),
                Center(
                    child: Text(dictionaryObj['unloading']['EnterAmount'],
                        style:
                            const TextStyle(fontSize: 32, color: ColorConstant.midnight, fontWeight: FontWeight.w500))),
                Padding(
                    padding: const EdgeInsets.only(top: 65, bottom: 25, left: 30, right: 30),
                    child: Column(children: <Widget>[
                      TextField(
                          style: const TextStyle(fontSize: 15),
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
                            amountInput = amountInput.replaceAll(_symbol, '');
                            amountInput = amountInput.replaceAll(',', '');
                            amountInput_ = double.parse(amountInput);
                          }),
                    ])),
                ElevatedButton.icon(
                    icon: const Icon(Icons.file_upload_outlined, size: 25.0),
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        backgroundColor: ColorConstant.midnight,
                        foregroundColor: ColorConstant.white),
                    onPressed: () async => {
                          if (_controller.text.isEmpty)
                            {await EasyLoading.showInfo(dictionaryObj['unloading']['EnterAmount'])}
                          else
                            {
                              sum = double.parse(
                                      walletManager.walletModelInstance.getResource()['wallet_balance'].toString()) -
                                  amountInput_,
                              if (amountInput_ <=
                                  double.parse(
                                      walletManager.walletModelInstance.getResource()['wallet_balance'].toString()))
                                {
                                  if (await BankProvider().unload(accountNumber, amountInput_))
                                    {
                                      debugPrint(dictionaryObj['unloading']['UnloadSuccessfully']),
                                      await walletManager.updateWallet({
                                        'walletData': {
                                          'wallet_id': sharedPreferences.getString('wallet_id'),
                                          'wallet_balance': sum
                                        }
                                      }),
                                      _controller.clear(),
                                      _accountController.clear(),
                                      await EasyLoading.showSuccess(
                                          '\$${amountInput_.toStringAsFixed(2)} withdrawn successfully!'),
                                      Navigator.pushReplacementNamed(context, '/my-wallet'),
                                    }
                                  else
                                    {
                                      debugPrint('unloading failed'),
                                    }
                                }
                            },
                        },
                    label: Text(dictionaryObj['unloading']['TransferMoney']))
              ]));
        });
  }
}
