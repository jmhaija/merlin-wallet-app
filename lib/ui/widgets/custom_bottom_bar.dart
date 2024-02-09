import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/size_utils.dart';
import 'package:flutter/material.dart';

import 'package:client_app/utils/globals.dart';

IconData defaultIcon = Icons.settings;

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({super.key, required this.onChanged, this.currentRouteName});

  Function(BottomBarEnum)? onChanged;
  String? currentRouteName;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  double? iconSizes;
  
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(icon: Icons.home, type: BottomBarEnum.home, label: 'Home'),
    BottomMenuModel(icon: Icons.send_rounded, type: BottomBarEnum.sendMoney, label: 'Send'),
    BottomMenuModel(icon: Icons.qr_code_rounded, type: BottomBarEnum.qrCode, label: 'QR'),
    BottomMenuModel(icon: Icons.chat_bubble_outline, type: BottomBarEnum.chat, label: 'Chats'),
    BottomMenuModel(icon: Icons.settings, type: BottomBarEnum.settings, label: 'Settings')
  ];

  @override
  void initState() {
    selectedIndex = widget.currentRouteName == '/chats_page' ? 3 : 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: ColorConstant.whiteA700,
          boxShadow: [
            BoxShadow(
              color: ColorConstant.black9000f,
              spreadRadius: getHorizontalSize(
                2.00,
              ),
              blurRadius: getHorizontalSize(
                2.00,
              ),
              offset: const Offset(
                0,
                -2,
              ),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          showUnselectedLabels: false,
          elevation: 0,
          iconSize: 25,
          selectedItemColor: ColorConstant.midnight,
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: List.generate(bottomMenuList.length, (index) {
            return BottomNavigationBarItem(
              icon: Center(child: Icon(bottomMenuList[index].icon)),
              activeIcon: Center(child: Icon(bottomMenuList[index].icon)),
              label: bottomMenuList[index].label,
            );
          }),
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            if (globalSettings['environment'] == 'production'){
              if (bottomMenuList[index].type.toString() == 'BottomBarEnum.sendMoney' ||
                  bottomMenuList[index].type.toString() == 'BottomBarEnum.qrCode') {
                showComingSoonToast();
              } else {
                widget.onChanged!(bottomMenuList[index].type);
              }
            } else {
              widget.onChanged!(bottomMenuList[index].type);
            }
          },
        ),
    );
  }
}

enum BottomBarEnum { home, sendMoney, qrCode, chat, settings, loadMoney }

class BottomMenuModel {
  BottomMenuModel({required this.icon, required this.type, required this.label});

  IconData icon;
  BottomBarEnum type;
  String label;
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Signing out...',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
