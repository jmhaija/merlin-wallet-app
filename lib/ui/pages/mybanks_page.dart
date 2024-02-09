import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:flutter/material.dart';
import 'package:client_app/utils/globals.dart';

class MyBanksPage extends StatefulWidget {
  const MyBanksPage({super.key});
  @override
  State<MyBanksPage> createState() => _MyBanksStatePage();
}

class _MyBanksStatePage extends State<MyBanksPage> {
  Future<dynamic> refreshConnections() async {
    return await getMyConnections();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppbarWidget(
          subject: dictionaryObj['my_banks']['Header'],
          actions: const [],
          routeBack: false,
        ),
        backgroundColor: ColorConstant.white,
        body: FutureBuilder<dynamic>(
          future: refreshConnections(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(dictionaryObj['my_banks']['Error'])
                  );
                } else {
                  myConnections = snapshot.data;
                  if(myConnections.isNotEmpty ){
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: myConnections.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.all(20.0),
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
                                                './assets/images/${myConnections[index].connectionBank['bank_logo'].toString()}'
                                              ),
                                              width: 40,
                                              height: 40,
                                            ),
                                            Text(
                                              myConnections[index].connectionBank['bank_full_name'].toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          myConnections[index].connectionAccountNumber
                                        )
                                      ]
                                    )
                                  ),
                                )
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: RoundRectButtonWidget(
                              subject: dictionaryObj['my_banks']['ButtonText'],
                              onPressed: () => Navigator.pushNamed(context, '/connect-banks')
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: RoundRectButtonWidget(
                        subject: dictionaryObj['my_banks']['ButtonText'],
                        onPressed: () {
                          Navigator.pushNamed(context, '/connect-banks');
                        }
                      ),  
                    )
                  );
                }
            }
          }
        )
      )
    );
  }
}
