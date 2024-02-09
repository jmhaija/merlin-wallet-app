import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/widgets/unloading_amount_form.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';

import 'package:client_app/ui/widgets/loading_amount_form.dart';

class ConnectionsListWidget {
  String connectionAccountNumber = '';

  String logoPathConverter(String path) {
    String mainPath = './assets/images/';
    return mainPath + path;
  }

  void showConnectionList(action, context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          color: ColorConstant.white,
          child: Center(
            child: myConnections.isEmpty
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                       Text(
                          dictionaryObj['connection_page']['NoConnection'],
                        ),
                        TextButton(
                          child: Text(dictionaryObj['connection_page']['ConnectToBank']),
                          onPressed: () => {
                            Navigator.of(context).pop(),
                            Navigator.pushNamed(context, '/connect-banks'),
                          },
                        )
                      ]
                    )
                  : ListView(
                    padding: const EdgeInsets.all(20), 
                    children: <Widget>[
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: myConnections.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.pop(context),
                              if (action == 'load'){
                                LoadingForm().showLoadingAmountForm(myConnections[index].connectionId, context),
                              } else {
                                if (myConnections[index].connectionAccountNumber != null) {
                                  connectionAccountNumber = myConnections[index].connectionAccountNumber,
                                  UnloadingForm().showUnloadingAmountForm(
                                    context,
                                    accountNumber: connectionAccountNumber
                                  ),
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: Text(dictionaryObj['connection_page']['connectionErrorTitle']),
                                      content: Text(dictionaryObj['connection_page']['connectionErrorContent']),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  )
                                }
                              }
                            },
                            child: Card(
                              shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Ink.image(
                                          image: AssetImage(
                                            logoPathConverter(myConnections[index].connectionBank['bank_logo'].toString())
                                          ),
                                          width: 50,
                                          height: 50,
                                        ),
                                        Text(
                                          (myConnections[index].connectionBank['bank_full_name']).toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      myConnections[index].connectionAccountNumber,
                                    )
                                  ]
                                )
                              ),
                            ),
                          );
                        },
                      ),
                    ]
                  )
                )
              );
        });
  }
}
