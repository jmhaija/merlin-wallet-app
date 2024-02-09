

import 'dart:io';

import 'package:client_app/providers/storage_service_provider.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/managers/session_manager.dart';


class SideNavBar extends StatelessWidget {
  const SideNavBar({Key? key, required this.myEmail}) : super(key: key);
  final String? myEmail;
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(dictionaryObj['start']['Home']), 
      backgroundColor: Colors.blue.shade700
    ),
    drawer: NavigationDrawer(
      myEmail: myEmail,
    ),
  );
}

class NavigationDrawer extends StatefulWidget {

  NavigationDrawer({Key? key, required this.myEmail}) : super(key: key);
  var myEmail;
  
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();

}

class _NavigationDrawerState extends State<NavigationDrawer> {
  bool check = false;
  File? profileImage;
  var defaultImage = const AssetImage('assets/images/images.png');
  var customerData = {};
  final String _localProfileImagePath = sharedPreferences.getString('image_path') ?? '';
  String _profileImagePath = '';

  @override
  void initState() {
    super.initState();
    if(_localProfileImagePath != ''){
      profileImage = File(_localProfileImagePath);
    } else {
      profileImage = null;
      customerData = customerEntity.getResource();
      if(customerData['profile'] != null && customerData['profile']['profile_image_path'] != null && customerData['profile']['profile_image_path'] != ''){
        _profileImagePath = customerData['profile']['profile_image_path'];
        StorageServiceProvier().retrieveFile(_profileImagePath)
        .then((value) => {
          setState(() {
            profileImage = value;
          })
        });
      } else {
        profileImage = null;
        _profileImagePath = '';
      }
    }
  }
  
  showComingSoonBadge() {
    return Chip(
      padding: const EdgeInsets.all(0),
      backgroundColor: ColorConstant.bluegrey,
      label: Text(dictionaryObj['pages']['coming_soon'], style: const TextStyle(color: Colors.white)),
    );
  }

  showVerificationBadge() {
    if(sharedPreferences.getString('user_status') == 'unverified'){
      return Chip(
        padding: const EdgeInsets.all(0),
        backgroundColor: ColorConstant.bluegrey,
        label: Text(dictionaryObj['user_status']['Unverified'], style: const TextStyle(color: Colors.white)),
      );
    } else {
      check = true;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            profileImage != null ? buildHeader(context, FileImage(profileImage!)) : buildHeader(context, defaultImage),
            buildMenuItems(context),
            const Padding(padding: EdgeInsets.only(top: 288.0)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text('Version: $appVersion', style: const TextStyle(fontStyle: FontStyle.italic)),
          )
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, imageFile) => Container(
    color: ColorConstant.midnight,
    padding: const EdgeInsets.only(top: 85, bottom: 20),
    child: Column(
      children: <Widget>[
        CircleAvatar(
          radius: 55.0,
          backgroundImage: imageFile,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 15),
          child: Text(
            widget.myEmail!,
            style: const TextStyle(
                color: ColorConstant.white, 
                fontSize: 15.0, 
                fontWeight: FontWeight.bold, 
                fontFamily: 'Work Sans'),
          ),
        ),
      ],
    ),
  );

  Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.only(top: 28, bottom: 28, left: 5, right: 5),
      child: Wrap(
        children: [
           ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(dictionaryObj['side_nav']['Chats']),
            onTap: () {
              Navigator.pushNamed(context, '/chats_page');
            },
          ),
           ListTile(
            leading: const Icon(Icons.settings),
            title: Text(dictionaryObj['side_nav']['Setting']),
            onTap: () => {Navigator.pushNamed(context, '/settings')},
            trailing: showVerificationBadge(),
            enabled: check
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(dictionaryObj['side_nav']['MyBanks']),
            onTap: () {
              Navigator.pushNamed(context, '/mybanks_page');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(dictionaryObj['side_nav']['LogOut']),
            onTap: () async {
              await EasyLoading.show(status: dictionaryObj['side_nav']['Loading']);
              SessionManager sessionManager = SessionManager();
              sessionManager.endSession().then((success) => {
                  if (success) {
                    Navigator.pushNamed(context, '/login'),
                    EasyLoading.showSuccess(dictionaryObj['side_nav']['SuccessLogout'],
                        duration: const Duration(milliseconds: 50))
                  }
                }
              );
            },
          ),
        ],
      )
    );
}
