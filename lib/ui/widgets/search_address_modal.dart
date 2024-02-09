
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/providers/place_service.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/utils/size_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SearchAddressModal extends StatefulWidget {
  const SearchAddressModal({super.key});
	
	@override
  _SearchAddressModalState createState() => _SearchAddressModalState();
}

class _SearchAddressModalState extends State<SearchAddressModal> {
  final TextEditingController _searchAddressTextEditingController = TextEditingController();
	dynamic suggestions; 
	final String sessionToken = sharedPreferences.getString('session_token')!;

  @override
  void dispose() {
    _searchAddressTextEditingController.dispose();
    super.dispose();
  }

	Future<List<dynamic>> showSuggestions() async {
		return await PlaceApiProvider(sessionToken).fetchSuggestions(_searchAddressTextEditingController.text, 'en');		 
	} 

	@override
  Widget build(BuildContext context) {
		return FutureBuilder(
			future: showSuggestions(),
				builder: (context, snapshot) {
					return Column(
						children : <Widget>[
							TextField(
								controller: _searchAddressTextEditingController,
								onChanged: (query) async {
									suggestions = await showSuggestions();
									setState((){
										suggestions;
									});
								},
								decoration: InputDecoration(
									icon: Container(
										margin: const EdgeInsets.only(left: 20),
										width: 10,
										height: 10,
										child: const Icon(
											Icons.home,
											color: Colors.black,
										),
									),
									hintText: 'Search your address here',
									border: InputBorder.none,
									contentPadding: const EdgeInsets.only(left: 8.0, top: 16.0),
								),
							),
							if (_searchAddressTextEditingController.text == '') ... [
								Container(
									alignment: Alignment.topLeft,
									padding: const EdgeInsets.all(30.0),
									child: const Text(
										'Enter your address'
									),
								)
							] else ...[
								if(snapshot.connectionState == ConnectionState.waiting)... [
									Container(
										padding: const EdgeInsets.all(30.0),
										child: const CircularProgressIndicator(
											color: ColorConstant.grey,
										)
									)
								] else ...[
									Expanded(
										child: ListView.builder(
											scrollDirection: Axis.vertical,
											physics: const BouncingScrollPhysics(),
											shrinkWrap: true,
											itemCount: suggestions.length,       
											itemBuilder: ((context, index){
												var currentSuggestion = suggestions[index];
												if(currentSuggestion.runtimeType.toString() == 'Suggestion') {
													return ListTile(
														title: Text(currentSuggestion.description),
														onTap: () => Navigator.of(context).pop(suggestions[index])
													);
												} else {
													return ListTile(
														title: Text.rich(
															TextSpan(
																text: '${currentSuggestion.substring(0, currentSuggestion.indexOf('.') + 1)} ',
																style: TextStyle(fontSize: getFontSize(13), color: Colors.black),
																children: <TextSpan>[
																	TextSpan(
																		text: currentSuggestion.substring(currentSuggestion.indexOf('.') + 2),
																		style: TextStyle(
																			fontSize: getFontSize(13),
																			color: Colors.blue,
																			decoration: TextDecoration.underline,
																		),
																		recognizer: TapGestureRecognizer()
																			..onTap = () async {
																				Navigator.of(context).pop(currentSuggestion);
																			}
																	),
																]
															)
														)
													);
												}
											}
										)
									)
									)
								]
							]
						]
					);
				}
		);
	}
}
