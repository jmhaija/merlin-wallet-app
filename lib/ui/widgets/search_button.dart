  import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';

class ShowSearchButton extends StatefulWidget {
  const ShowSearchButton({
   
    key
  }) : super(key: key);

  @override
  _ShowSearchButton createState() => _ShowSearchButton();
}
class _ShowSearchButton extends State<ShowSearchButton> {
	final TextEditingController _textController = TextEditingController();
  String _searchResult = '';
  String foundUsername = '';
  var userObj = {};
  List<Map<dynamic, dynamic>> foundUser = [];
  List<Map> searchedUsers = [];
	

@override
	Widget build(BuildContext context) {
    if (_searchResult == '' || _searchResult == dictionaryObj['search']['UsernameNotFound']) {
      return Column(children: <Widget>[
        FloatingActionButton(
            onPressed: () {
              // Add chat for the searched username
              if (_textController.text.isNotEmpty) {
                _searchResult = '';
                customerManager.searchUserName(_textController.text.toLowerCase()).then((value) => {
                  if (value.isEmpty){
                    setState(() => _searchResult = dictionaryObj['search']['NotFound'])
                  }
                  else{
                    setState(() => {
                      _searchResult = dictionaryObj['search']['NotFound'], 
                      searchedUsers = value
                    }),
                  }
                });
              } else {
                setState(() => _searchResult = dictionaryObj['search']['NotFound']);
              }
            },
            backgroundColor: ColorConstant.midnight,
            child: const Icon(Icons.search)),
      ]);
    }
    return const SizedBox();
  }
	

}