import 'dart:convert';

import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LookupEmail extends StatefulWidget {
  const LookupEmail({Key? key}) : super(key: key);
  @override
  _LookupEmail createState() => _LookupEmail();
}

class _LookupEmail extends State<LookupEmail> {
  final TextEditingController _textController = TextEditingController();
  String _searchResult = '';
  String foundUsername = '';
  var userObj = {};
  List<Map<dynamic, dynamic>> foundUser = [];
  List<Map> searchedUsers = [];

  Widget showFoundUsers() {
    if (_searchResult == dictionaryObj['search']['NotFound'] && searchedUsers.isEmpty) {
      searchedUsers = [];
      return SizedBox(
          child: ListTile(
        title: Center(child: Text(dictionaryObj['search']['NotFound'])),
      ));
    } else {
      return Column(children: <Widget>[
        SizedBox(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: searchedUsers.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (searchedUsers.isNotEmpty) {
                    final user = searchedUsers[index];

                    return ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                        ),
                        title: Text(user['userEmail']),
                        onTap: () async {
                          EasyLoading.showSuccess(dictionaryObj['send_money']['Processing'],
                              duration: const Duration(milliseconds: 500));
                          sharedPreferences.setString('send_money_user', json.encode(user));
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/send_money');
                        });
                  }
                  return const ListTile();
                }))
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppbarWidget(
              subject: dictionaryObj['search']['SendMoney'],
              actions: const [],
              routeBack: false,
            ),
            backgroundColor: ColorConstant.white,
            body: Padding(
                padding: const EdgeInsets.all(50),
                child: SingleChildScrollView(
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: dictionaryObj['search']['lookupEmailHint'],
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => {
                                  _textController.clear(),
                                  setState(() => {_searchResult = '', searchedUsers = []})
                                }),
                      ),
                      onChanged: (value) => {
                        if (_textController.text.length >= 4)
                          {
                            _searchResult = '',
                            customerManager.searchUserName(_textController.text.toLowerCase()).then((val) => {
                                  if (val.isEmpty)
                                    {setState(() => _searchResult = dictionaryObj['search']['NotFound'])}
                                  else
                                    {
                                      setState(() =>
                                          {_searchResult = dictionaryObj['search']['Found'], searchedUsers = val}),
                                    }
                                })
                          },
                        setState(() => _searchResult = ''),
                        searchedUsers = []
                      },
                    ),
                    const SizedBox(height: 30),
                    showFoundUsers(),
                  ]),
                ))));
  }
}
