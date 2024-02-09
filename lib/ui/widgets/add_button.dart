import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/widgets/connections_list_widget.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: 
      SizedBox(
        width: 300,
        height: 52,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add,
            size: 24.0,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstant.balance,
            foregroundColor: ColorConstant.white,
            textStyle: const TextStyle(fontSize: 20),
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
          ),
          onPressed: () {
            ConnectionsListWidget().showConnectionList('load', context);
          },
          label: Text(dictionaryObj['loading']['AddButton']),
        ),
      ),
    );
  }
}
