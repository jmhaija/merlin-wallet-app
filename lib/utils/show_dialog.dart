import 'package:flutter/material.dart';

class ShowDialog{
  show(context, title, content, buttons){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(content),
          actions: buttons
        );
      },
    );
  }
}