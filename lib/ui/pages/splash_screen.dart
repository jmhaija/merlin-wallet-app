import 'dart:async';
import 'package:client_app/managers/customer_manager.dart';
import 'package:client_app/ui/pages/login.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:client_app/managers/session_manager.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  SessionManager sessionManager = SessionManager();
  CustomerManager customerManager = CustomerManager();
  Map<String, dynamic> userData = {};


  @override
  void initState() {
    super.initState();
    startTime();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/merlinc-logo-white.png',
              width: 800,
              height: 600,
            ),
          ],
        ),
      )
    );
  }

  route() async {
    //if session id exists, retrieve user info by session id
    try{
      if (sharedPreferences.getString('session_id') != null) {
        sessionManager.sessionEntity.populateEntity({
          'session_id': sharedPreferences.getString('session_id'),
          'session_token': sharedPreferences.getString('session_token'),
          'session_expires': sharedPreferences.getInt('session_expires')!,
        });
        sessionManager
          .getSession(sharedPreferences.getString('session_id')!)
          .then((session) => {
            if(session['resources']['user'] == null){
              Navigator.pushReplacementNamed(context, '/login')
            } else {
              userData = session['resources']['user'],
              if(session['resources']['profile'] != null) userData.addAll({'profile': session['resources']['profile']}),
              customerManager.populatorFunc(userData),
              sessionManager.sessionEntity.populateEntity({
                '_sessionID': sharedPreferences.getString('session_id'),
                '_sessionToken': sharedPreferences.getString('session_token'),
                '_sessionExpiry': sharedPreferences.getInt('session_expires')!
              })
            }
          });     
      }
      if(sharedPreferences.getString('wallet_id') != null){
        await getMyConnections();
      }
    }catch(e){
      sharedPreferences.getKeys().forEach((key) {
        if(key != 'is_auth_enabled') {
          sharedPreferences.remove(key);
        }       
      });
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
    

    if (sharedPreferences.getString('user_status') != null) {
      Navigator.pushNamed(context, '/home_page');
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, route);
  }
}
