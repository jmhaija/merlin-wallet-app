import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';

class RoundRectButtonWidget extends StatelessWidget {

  RoundRectButtonWidget({
    Key? key,
    required this.subject,
    required this.onPressed,
  }) : super(key: key);
  final String subject;
  var onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(colors: [
                  ColorConstant.darkblue,
                  ColorConstant.lightblue,
                ])),
          ),
        ),
        SizedBox(
            width: double.infinity,
            child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: ColorConstant.bluegrey,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20, fontFamily: 'WorkSans'),
                ),
                onPressed: onPressed,
                child: Text(subject))),
      ],
    ),
  );
  }
}
