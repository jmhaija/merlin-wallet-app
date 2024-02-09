
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/managers/session_manager.dart';
import 'package:client_app/ui/pages/account_deletion_confirmation.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:client_app/ui/widgets/round_rect_button.dart';
import 'package:client_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

enum ReasonOptions { 
	hardToUse, 
	privacyConcern, 
	willBeBack, 
	accountHacked, 
	notUseful, 
	anotherAccount, 
	other 
}
class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _reasonController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
	ReasonOptions? _option;
	bool isOtherSelected = false;
	dynamic reason;
	bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
				actions: const [],
				subject: 'Delete Account',
				routeBack: true,
			),
			backgroundColor: ColorConstant.white,
      body: SingleChildScrollView(
				physics: const BouncingScrollPhysics(),
				padding: const EdgeInsets.only(
					left:16.0,
					right: 16.0,
					top: 16.0,
					bottom: 10.0,
				),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text(
							dictionaryObj['delete_account']['RequestDeletionReason'],
							style: const TextStyle(fontSize: 16.0)
						),
						const SizedBox(height: 15.0),
						showRadioList(),
						showTextField(),
						RoundRectButtonWidget(
							onPressed: () {
								if(_option != null){
									if(_option!.name != 'other'){
										reason = {'reason': _option!.name};
									} else {
										reason = {'reason': _option!.name, 'details': _reasonController.text};
									}
									
									showDialog<String>(
										context: context,
										builder: (BuildContext context) => SimpleDialog(
											shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
											title: Text(dictionaryObj['delete_account']['TypePassword'], style: const TextStyle(fontSize: 20)),
											contentPadding: const EdgeInsets.all(20.0),
											children: [
												TextFormField(
													controller: _passwordController,
													obscureText: true,
													decoration: const InputDecoration(
														border: OutlineInputBorder(
															borderRadius: BorderRadius.all(Radius.circular(10.0)),
														),
													),
												),
												const SizedBox(height: 20,),
												RoundRectButtonWidget(
													onPressed: () async {
														if(isDeleting){
															return null;
														}
														if(await customerManager.authenticateUser(_passwordController.text)){
															EasyLoading.show(status: 'It can take a few seconds...');
															isDeleting = true;
															await _deleteAccount(reason);
															EasyLoading.dismiss();
															_passwordController.clear();
															Navigator.of(context, rootNavigator: false).pop();
														} else {
															_passwordController.clear();
															EasyLoading.showError('Password does not match');
														}
													},
													subject: dictionaryObj['delete_account']['ConfirmDeletion'],
												),
											]
										),
									);
								
								} else {
									EasyLoading.showInfo('Please select a reason for leaving', dismissOnTap: true);
								}
							
							},
							subject: dictionaryObj['Continue'],
						),
						TextButton(
							style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontFamily: 'WorkSans'),
                                    foregroundColor: ColorConstant.midnight),
							onPressed: () {
								Navigator.pop(context);
							},
							child: Text(dictionaryObj['Cancel']),
						),
					],
				),
			)
    );
  }

  Future<void> _deleteAccount(dynamic reason) async {
    try {
      // WILL send the reason to the server, then delete the account
      // Ensure to include error handling and loading indicators
			if(await customerManager.deleteCustomer(reason)){
				SessionManager().endSession().then((success) => {
					if (success) {
						Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AccountDeletionConfirmationPage()))
					}
				});
			}
    } catch (error) {
      print(error);
    }
  }


	Widget showRadioList(){
		return Column(
			children: <Widget>[
				RadioListTile<ReasonOptions>(
					title: Text(dictionaryObj['delete_account']['DeletionReason1']),
					value: ReasonOptions.hardToUse,
					groupValue: _option,
					onChanged: (ReasonOptions? value) {
						setState(() {
							_option = value;
							isOtherSelected = false;
						});
					},
				),
				RadioListTile<ReasonOptions>(
					title: Text(dictionaryObj['delete_account']['DeletionReason2']),
					value: ReasonOptions.privacyConcern,
					groupValue: _option,
					onChanged: (ReasonOptions? value) {
						setState(() {
							_option = value;
							isOtherSelected = false;
						});
					},
				),
				RadioListTile<ReasonOptions>(
					title: Text(dictionaryObj['delete_account']['DeletionReason3']),
					value: ReasonOptions.willBeBack,
					groupValue: _option,
					onChanged: (ReasonOptions? value) {
						setState(() {
							_option = value;
							isOtherSelected = false;
						});
					},
				),
				RadioListTile<ReasonOptions>(
					title: Text(dictionaryObj['delete_account']['DeletionReason4']),
					value: ReasonOptions.accountHacked,
					groupValue: _option,
					onChanged: (ReasonOptions? value) {
						setState(() {
							_option = value;
							isOtherSelected = false;
						});
					},
				),
				RadioListTile<ReasonOptions>(
					title: Text(dictionaryObj['delete_account']['DeletionReason5']),
					value: ReasonOptions.notUseful,
					groupValue: _option,
					onChanged: (ReasonOptions? value) {
						setState(() {
							_option = value;
							isOtherSelected = false;
						});
					},
				),
				RadioListTile<ReasonOptions>(
					title: Text(dictionaryObj['delete_account']['DeletionReason6']),
					value: ReasonOptions.anotherAccount,
					groupValue: _option,
					onChanged: (ReasonOptions? value) {
						setState(() {
							_option = value;
							isOtherSelected = false;
						});
					},
				),
				RadioListTile<ReasonOptions>(
					title: Text(dictionaryObj['delete_account']['DeletionReason7']),
					value: ReasonOptions.other,
					groupValue: _option,
					onChanged: (ReasonOptions? value) {
						setState(() {
							_option = value;
							isOtherSelected = true;
						});
					},
				),
			],
		);
	}
	
	showTextField() {
		return Padding(
			padding: const EdgeInsets.all(20),
			child: TextField(
				enabled: isOtherSelected,
				textAlignVertical: TextAlignVertical.top,
				maxLines: null,
				maxLength: 250,
				expands: false,
				keyboardType: TextInputType.multiline,
				controller: _reasonController,
				decoration: InputDecoration(
					labelText: dictionaryObj['delete_account']['DeletionReason'],
					hintText: dictionaryObj['delete_account']['Optional'],
					hintStyle: const TextStyle(
						color: Colors.grey,
					),
					isCollapsed: true,
					contentPadding: const EdgeInsets.all(20.0),
					border: const OutlineInputBorder(
						borderRadius: BorderRadius.all(Radius.circular(20.0)),
					),
				),
			)
		);
	}
}

