import 'package:client_app/providers/biometric_authentication_provider.dart';
import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class NewMessageWidget extends StatefulWidget {
  const NewMessageWidget({
    required this.chatRoomId,
    key,
  }) : super(key: key);
  final String chatRoomId;

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  static final String _locale = countryConfigs['currency_locale'];
  static final NumberFormat format = NumberFormat.simpleCurrency(locale: _locale);
  static final String currencySymbol = format.currencySymbol;
  static final String inchatTransferPrefix = '${globalSettings['inchat-transfer-prefix']}$currencySymbol';
  
  String message = ''; 
  bool sendMoneyFlag = false;
  String idUser = sharedPreferences.getString('user_id').toString();

  final TextEditingController _regularMessagecontroller = TextEditingController();
  final TextEditingController transferTextController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController(); 
  

  // sending message
  void sendMessage(String incomingMessage) async {
    FocusScope.of(context).unfocus();
    await ChatProvider.sendMessage(widget.chatRoomId, incomingMessage);
    setState(() {
      message = '';
      sendMoneyFlag = false;
    });
    _regularMessagecontroller.clear();
    transferTextController.clear();
  }

  void visibilityFunc() {
    if (!sendMoneyFlag) {
      setState(() {
        _regularMessagecontroller.clear();
        sendMoneyFlag = true;
      });
    } else {
      setState(() {
        transferTextController.clear();
        sendMoneyFlag = false;
      });
    }
  }

  void sendingFunc() {
    String tempMessage = '$inchatTransferPrefix ';
    if (transferTextController.text.isNotEmpty) {
      securityCheck(tempMessage);
    } else if (message.isNotEmpty) {
      tempMessage = message;
      sendMessage(tempMessage);
    }
  }

  void securityCheck(String tempMessage) async {
    if (sharedPreferences.getBool('is_auth_enabled') != null && sharedPreferences.getBool('is_auth_enabled')!) {
      EasyLoading.show(status: dictionaryObj['chat']['verifying']);
      bool isAuthenticated = await BiometricAuthenticationProvider().authenticateUser();
      if (isAuthenticated) {
        EasyLoading.showSuccess('Verified successfully');
        sendMessage('$tempMessage ${double.parse(transferTextController.text).toStringAsFixed(2).toString().trim()}');
      } else {
          EasyLoading.showError('Verification failed', dismissOnTap: true);
      }
    } else {
      showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text(dictionaryObj['chat']['sendMoneyConfirm']),
        contentPadding: const EdgeInsets.all(20.0),
        children: [
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          RoundRectButtonWidget(
            subject: dictionaryObj['chat']['confirmButton'],
            onPressed: () async => {
              if (await customerManager.authenticateUser(_passwordController.text)) {
                _passwordController.clear(),
                Navigator.pop(context),
                sendMessage(
                  tempMessage +
                  double.parse(transferTextController.text).toStringAsFixed(2).toString().trim()
                )
              } else {
                _passwordController.clear(), 
                EasyLoading.showError(dictionaryObj['chat']['passwordMsg'], dismissOnTap: true)
              }
            }),
          ]
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    color: ColorConstant.midnight,
    padding: const EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(width: 5),
        // show Currency Icon button to show the number pad
        Visibility(
          visible: !sendMoneyFlag,
          child: GestureDetector(
            onTap: globalSettings['environment'] == 'production' ? showComingSoonToast : visibilityFunc,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstant.darkblue,
              ),
              child: Text(
                currencySymbol, 
                style: const TextStyle(color: ColorConstant.white, fontSize: 28)
              ),
            ),
          )
        ),
        // show Cancel button to go back to the regular message field
        Visibility(
          visible: sendMoneyFlag,
          child: GestureDetector(
            onTap: visibilityFunc,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstant.darkblue,
              ),
              child: const Icon(Icons.clear, color: Colors.white, size: 25),
            ),
          )
        ),
        // show TextFormField for money transfer
        Visibility(
          visible: sendMoneyFlag,
          child: Expanded(
            child: TextFormField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              controller: transferTextController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: '${dictionaryObj['chat']['sendMoneyTitle']} $currencySymbol',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          )
        ),
        const SizedBox(width: 5),
        // show TextFormField for regular message
        Visibility(
          visible: !sendMoneyFlag,
          child: Expanded(
            child: TextFormField(
              controller: _regularMessagecontroller,
              minLines: 1,
              maxLines: 5,
              autocorrect: false,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: dictionaryObj['chat']['Msg'],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) => setState(() {
                message = value;
              }),
            ),
          )
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: sendingFunc,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstant.darkblue,
            ),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ),
        const SizedBox(width: 5),
      ],
    ),
  );
}
