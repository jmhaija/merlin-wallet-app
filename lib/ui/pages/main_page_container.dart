
import 'dart:convert';

import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/managers/main_page_container_controller.dart';
import 'package:client_app/managers/session_manager.dart';
import 'package:client_app/ui/pages/OTP.dart';
import 'package:client_app/ui/pages/OTP_phone_number.dart';
import 'package:client_app/ui/pages/account_deletion_confirmation.dart';
import 'package:client_app/ui/pages/account_number.dart';
import 'package:client_app/ui/pages/bank_list.dart';
import 'package:client_app/ui/pages/change_password.dart';
import 'package:client_app/ui/pages/chat_list_page.dart';
import 'package:client_app/ui/pages/chat_room_page.dart';
import 'package:client_app/ui/pages/home_page.dart';
import 'package:client_app/ui/pages/lookup_email.dart';
import 'package:client_app/ui/pages/qr_code_scanner.dart';
import 'package:client_app/ui/pages/send_money.dart';
import 'package:client_app/ui/pages/transaction_receipt_page.dart';
import 'package:client_app/ui/pages/main_page.dart';
import 'package:client_app/ui/pages/mybanks_page.dart';
import 'package:client_app/ui/pages/profile.dart';
import 'package:client_app/ui/pages/reset_password.dart';
import 'package:client_app/ui/pages/search_email.dart';
import 'package:client_app/ui/pages/settings.dart';
import 'package:client_app/ui/pages/verification_code.dart';
import 'package:client_app/ui/widgets/qr_generator_widget.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:client_app/ui/widgets/custom_bottom_bar.dart';
import 'package:get/get.dart';


// ignore: must_be_immutable
class MainPageContainerScreen extends GetWidget<MainPageContainerController> {
  MainPageContainerScreen({super.key, required this.route});

  String route;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  backgroundColor: ColorConstant.midnight,
                  body: Navigator(
                      key: Get.nestedKey(1),
                      initialRoute: route,
                      onGenerateRoute: (routeSetting) {
                        return GetPageRoute(
                            page: () => getCurrentPage(context, routeSetting.name!, arguments: routeSetting.arguments),
                            transition: Transition.noTransition);
                      }),
                  bottomNavigationBar: CustomBottomBar(currentRouteName: route, onChanged: (BottomBarEnum type) {
                    Get.toNamed(getCurrentRoute(type), id: 1);
                  }),
                )));
      },
    );
  }

  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.home:
        return '/home_page';
      case BottomBarEnum.sendMoney:
        return '/lookup_email';
      case BottomBarEnum.qrCode:
        return '/qr-code';
      case BottomBarEnum.chat:
        return '/chats_page';
      case BottomBarEnum.settings:
        return '/settings';
      default:
        return '/';
    }
  }

  Map<String, dynamic> pages = {
    '/': const HomePage(),
    '/home_page': const HomePage(),
    '/my-wallet': const ToWallet(),
    '/chats_page': const ChatsPage(),
    '/settings': const Settings(),
    '/profile': const ProfilePage(),
    '/reset_password': const ResetPassword(),
    '/change_password': const ChangePassword(),
    '/verification_code': VerificationCode(),
    '/search_username_chat': const ChatUserName(),
    '/mybanks_page': const MyBanksPage(),
    '/connect-banks': const AddBankPage(),
    '/account': const Account(),
    '/qr-code-scanner': const QRCodeScanner(),
    '/qr-code': QRGeneratorWidget(
      userInfo: sharedPreferences.getString('profile_first_and_last_name') ?? '',
    ),
    '/otp_number': ApplyOTPNumber(),
    '/lookup_email': const LookupEmail(),
    '/send_money': null,
    '/otp': const OTP(),
    '/transaction_receipt_page': const TransactionReceiptPage(),
    '/account-deleted': const AccountDeletionConfirmationPage(),
  };

  dynamic getCurrentPage(BuildContext context, String currentRoute, {arguments}) {
    if (pages.containsKey(currentRoute)) {
      if(currentRoute == '/send_money'){
        var user = sharedPreferences.getString('send_money_user');
        sharedPreferences.remove('send_money_user');
        Map<String, dynamic> userObj = json.decode(user!);
        return SendMoney(recipientInfo: userObj);
      }
      return pages[currentRoute];
    } else if (currentRoute == '/logout') {
      SessionManager().endSession()
        .then((success) => {
          if (success) Navigator.pushReplacementNamed(context, '/login')
        });
      return const LoadingWidget();
    } else if (currentRoute == '/chat-room') {
      WidgetsBinding.instance.addPostFrameCallback((_) => {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoom(chat: arguments),
          ))
      });
      return const WaitingWidget();
    } else {
      showComingSoonToast();
      return const DefaultWidget();
    }
  }
  
  LoadingWidget showLoading() {
    return const LoadingWidget();
  }
}
