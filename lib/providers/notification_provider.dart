import 'package:client_app/utils/globals.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:client_app/constants/color_constant.dart';

class NotificationProvider {
  final bool _isForeground = true;
  String? _token;
  String? get token => _token;
  Map<String, dynamic> data = {};
  FirebaseMessaging firebaseMessagingInstance = FirebaseMessaging.instance;

  Future registerNotification() async {
    NotificationSettings settings = await firebaseMessagingInstance.requestPermission(
        alert: true,
        badge: false,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      await _getToken();
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String oldMessage = message.data.values.join();
      String updatedMessage = oldMessage.replaceAll(RegExp(r'[\(\)]'), '');

      if (sharedPreferences.getString('get_notifications') == updatedMessage) {
        print('You will only get notification from user you not chatting with atm.');
      } else {
        showSimpleNotification(
          Text(message.notification!.title!),
          leading: const CircleAvatar(radius: 25),
          subtitle: Text(message.notification!.body!),
          background: ColorConstant.midnight,
          duration: const Duration(seconds: 1),
          elevation: 20,
          autoDismiss: true,
          slideDismissDirection: DismissDirection.up,
          position: NotificationPosition.top,
        );
      }

      print('Just received a notification when app is in foreground');

      data = message.data;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Just received a notification when app is opened 1');
    });
  }

  Future _getToken() async {
    String tempToken = '';
    _token = await firebaseMessagingInstance.getToken();

    firebaseMessagingInstance.onTokenRefresh.listen((token) {
      _token = token;
    });
    tempToken = token!;
    sharedPreferences.setString('device_token', tempToken);
  }

  Map<String, dynamic> notificationDataHandler() {
    return data;
  }

  // void _handleAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.inactive) {
  //     _isForeground = true;
  //   }
  //   if (state == AppLifecycleState.paused) {
  //     _isForeground = false;
  //   }
  // }
}
