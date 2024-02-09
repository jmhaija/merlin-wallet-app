import 'package:client_app/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:client_app/utils/globals.dart';
import 'package:intl/intl.dart';

class TransactionReceiptPage extends StatefulWidget {
  const TransactionReceiptPage({super.key});
  @override
  State<TransactionReceiptPage> createState() => _TransactionReceipt();
}

class _TransactionReceipt extends State<TransactionReceiptPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    String? senderName = sharedPreferences.getString('profile_first_and_last_name');
    String? senderEmail = sharedPreferences.getString('user_email');
    double? amountSent = sharedPreferences.getDouble('amount_sent');
    const double updatedWalletAmount = 50.0;
    String? receiverName = sharedPreferences.getString('receiver_fullname');
    String? receiverEmail = sharedPreferences.getString('receiver_email');
    const String transactionId = '12345';

    return Scaffold(
        appBar: AppBar(
            title: Text(
              dictionaryObj['transaction_receipt']['Confirmation'],
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: ColorConstant.midnight,
            actions: <Widget>[
              IconButton(
                icon: const Text('Done', style: TextStyle(fontSize: 18, color: Colors.white)),
                iconSize: 50.0,
                tooltip: 'Done',
                onPressed: () => {
                  Navigator.pushNamed(context, '/home_page'),
                },
              ),
            ]),
        backgroundColor: ColorConstant.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FadeTransition(
                          opacity: _animation,
                          child: const Icon(
                            Icons.check,
                            color: Color.fromARGB(255, 62, 144, 66),
                            size: 80,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(dictionaryObj['transaction_receipt']['Confirmed'], style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorConstant.midnight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Text(dictionaryObj['transaction_receipt']['Sender'] + senderName , style: const TextStyle(color: ColorConstant.white, fontSize: 19)),
                          Text(senderEmail!, style: const TextStyle(color: ColorConstant.white, fontSize: 15)),
                          const SizedBox(height: 13.0),
                          Text(dictionaryObj['transaction_receipt']['AmountSent'] + amountSent.toString(),
                              style: const TextStyle(color: ColorConstant.white, fontSize: 19)),
                          const SizedBox(height: 13.0),
                          const Text('Updated Wallet Amount: $updatedWalletAmount',
                              style: TextStyle(color: ColorConstant.white, fontSize: 19)),
                          Text(senderEmail + dictionaryObj['transaction_receipt']['Wallet'],
                              style: const TextStyle(color: ColorConstant.white, fontSize: 15)),
                          const SizedBox(height: 8.0),
                          const Divider(
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8.0),
                          Text(dictionaryObj['transaction_receipt']['Receiver'] +  receiverName,
                              style: const TextStyle(color: ColorConstant.white, fontSize: 19)),
                          Text(receiverEmail!, style: const TextStyle(color: ColorConstant.white, fontSize: 15)),
                          const SizedBox(height: 8.0),
                          const Divider(
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8.0),
                          Text(dictionaryObj['transaction_receipt']['TransactionDate'] + formattedDate,
                              style: const TextStyle(color: ColorConstant.white, fontSize: 19)),
                          const SizedBox(height: 15.0),
                          Text(dictionaryObj['transaction_receipt']['ConfirmationId'] + transactionId,
                              style: const TextStyle(color: ColorConstant.white, fontSize: 19)),
                          const SizedBox(height: 3.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
