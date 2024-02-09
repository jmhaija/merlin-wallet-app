import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/ui/widgets/balance_widget.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/utils/size_utils.dart';
import 'package:flutter/material.dart';

import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/providers/notification_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userStatus = sharedPreferences.getString('user_status').toString();

  @override
  void initState() {
    userStatus = sharedPreferences.getString('user_status').toString();
    super.initState();
    ChatProvider.setUserData();
    if (sharedPreferences.getString('device_token') != NotificationProvider().token) {
      ChatProvider.setDeviceToken(sharedPreferences.getString('device_token'));
    }
    ChatProvider.addUpdateUserStatus('logIn');
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: AppbarWidget(subject: dictionaryObj['start']['WelcomMsg'], actions: const [], routeBack: false),
          body: SingleChildScrollView(
              child: Column(children: [
            const SizedBox(height: 30),
            const BalanceWidget(flag: false),
            Padding(
              padding: getPadding(top: 10.0, left: 40, right: 15),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () => {
                        if (globalSettings['environment'] == 'production')
                          showComingSoonToast()
                        else
                          Navigator.pushNamed(context, '/lookup_email'),
                      },
                      icon: Image.asset('assets/images/send.png'),
                      iconSize: 45,
                    ),
                    Text(dictionaryObj['home']['Send']),
                    const SizedBox(height: 30),
                    Column(children: [
                      IconButton(
                        onPressed: () => showComingSoonToast(),
                        icon: Image.asset('assets/images/insurance.png'),
                        iconSize: 45,
                      ),
                      Text(dictionaryObj['home']['Insurance']),
                    ]),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => {
                        if (globalSettings['environment'] == 'production')
                          showComingSoonToast()
                        else
                          Navigator.pushNamed(context, '/mybanks_page')
                      },
                      icon: Image.asset('assets/images/bank.png'),
                      iconSize: 45,
                    ),
                    Text(dictionaryObj['home']['Banks']),
                    const SizedBox(height: 30),
                    Column(children: [
                      IconButton(
                        onPressed: () => showComingSoonToast(),
                        icon: Image.asset('assets/images/invest.png'),
                        iconSize: 45,
                      ),
                      Text(dictionaryObj['home']['Investment'])
                    ]),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => showComingSoonToast(),
                      icon: Image.asset('assets/images/bill.png'),
                      iconSize: 45,
                    ),
                    Text(dictionaryObj['home']['Bills']),
                    const SizedBox(height: 30),
                    Column(children: [
                      IconButton(
                        onPressed: () => showComingSoonToast(),
                        icon: Image.asset('assets/images/reward.png'),
                        iconSize: 45,
                      ),
                      Text(dictionaryObj['home']['Rewards'])
                    ]),
                  ],
                ),
                const SizedBox(width: 10),
                Column(children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/chats_page'),
                    icon: Image.asset('assets/images/chat_icon.png'),
                    iconSize: 80,
                    color: ColorConstant.lightBlue80026,
                  ),
                  Text(dictionaryObj['home']['Chat'])
                ])
              ]),
            ),
            Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.only(top: 30.0, left: 70, bottom: 30, right: 70),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: ColorConstant.midnight, blurRadius: 15.0, offset: Offset(0, 3))
                    ]),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () => showComingSoonToast(),
                      icon: Image.asset('assets/images/community.png'),
                      iconSize: 90,
                    ),
                    Text(
                      dictionaryObj['home']['Communities'],
                      style: const TextStyle(
                        fontSize: 19,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ))
          ])),
        ));
  }
}
