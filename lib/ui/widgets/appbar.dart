import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppbarWidget({
    key,
    required this.subject,
    required this.actions,
    required this.routeBack,
  }) : super(key: key);
  final String subject;
  List<TextButton> actions;
  final bool routeBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(subject),
      automaticallyImplyLeading: routeBack,
      backgroundColor: ColorConstant.midnight,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
