import 'package:client_app/domain/models/chat_room_model.dart';
import 'package:client_app/providers/chat_provider.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChatUserName extends StatefulWidget {
  const ChatUserName({Key? key}) : super(key: key);
  @override
  _ChatUsernameState createState() => _ChatUsernameState();
}

class _ChatUsernameState extends State<ChatUserName> {
  final TextEditingController _textController = TextEditingController();
  String _searchResult = '';
  String foundUsername = '';
  var userObj = {};
  List<Map<dynamic, dynamic>> foundUser = [];
  List<Map> searchedUsers = [];

  Widget showSearchButton() {
    if (_searchResult == '' || _searchResult == dictionaryObj['search']['UsernameNotFound']) {
      return Column(children: <Widget>[
        FloatingActionButton(
            onPressed: () {
              // Add chat for the searched username
              if (_textController.text.isNotEmpty) {
                _searchResult = '';
                customerManager.searchUserName(_textController.text.toLowerCase()).then((value) => {
                      if (value.isEmpty)
                        {setState(() => _searchResult = dictionaryObj['search']['NotFound'])}
                      else
                        {
                          setState(() => {_searchResult = dictionaryObj['search']['NotFound'], searchedUsers = value}),
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
                      onTap: () {
                        dynamic existingChatRoom;
                        ChatRoomModel newChatRoomInstance;
                        ChatProvider.getExistingChatRoomIfExists(user['userEmail']).then((result) {
                          existingChatRoom = result;
                          if (existingChatRoom == null) {
                            EasyLoading.show(status: dictionaryObj['chat']['CreatingChat']);
                            ChatProvider.addChatRoom(user)
                                .then((newChatRoom) async => {
                                      EasyLoading.showSuccess('', duration: const Duration(milliseconds: 500)),
                                      newChatRoomInstance = newChatRoom,
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (context) => ChatRoom(chat: newChatRoomInstance)))
                                      Navigator.pushNamed(context, '/chat-room', arguments: newChatRoomInstance)
                                    })
                                .catchError((onError) => {
                                      debugPrint(onError),
                                      EasyLoading.showError(dictionaryObj['chat']['CreatingChatRoomFailed']),
                                    });
                          } else {
                            // Navigator.push(
                            //     context, MaterialPageRoute(builder: (context) => ChatRoom(chat: existingChatRoom)));
                            Navigator.pushNamed(context, '/chat-room', arguments: existingChatRoom);
                          }
                        });
                      },
                    );
                  }
                  return const ListTile();
                }))
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(
          subject: dictionaryObj['search']['Search'],
          actions: const [],
          routeBack: true,
        ),
        backgroundColor: ColorConstant.white,
        body: Padding(
            padding: const EdgeInsets.all(50),
            child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: dictionaryObj['search']['SearchHint'],
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
                                  setState(
                                      () => {_searchResult = dictionaryObj['search']['Found'], searchedUsers = val}),
                                }
                            })
                      },
                    setState(() => _searchResult = ''),
                    searchedUsers = []
                  },
                ),
                const SizedBox(height: 30),
                showFoundUsers(),
                showSearchButton(),
              ]),
            )));
  }
}
