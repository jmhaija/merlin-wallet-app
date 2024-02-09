import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/utils/size_utils.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 10),
            child: Text(
              dictionaryObj['transaction']['Recent'], 
              style: TextStyle(
                color: ColorConstant.midnight,
                fontSize: getFontSize(15),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              )
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              double amount = 0;
              double val = double.parse((amount).toStringAsFixed(2));
              bool receiving = true;
              return Padding(
                 padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                child: ListTile(
                  leading:  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('TBD'),
                        //Text('19'),
                      ],
                    ),
                  ),
                  title: const Center(
                    child: Text(
                      'Coming soon',
                      style: TextStyle(
                        color: ColorConstant.darkblue,
                      ),
                    ),
                  ),
                  trailing: Text(
                    //'\$ ${val.toStringAsFixed(2)}',
                    '\$ soon',
                    style: TextStyle(
                      color: receiving ? ColorConstant.darkblue : ColorConstant.red,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
