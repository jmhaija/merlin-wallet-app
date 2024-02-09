import 'dart:io';

import 'package:client_app/providers/place_service.dart';
import 'package:client_app/providers/storage_service_provider.dart';
import 'package:client_app/ui/widgets/search_address_modal.dart';
import 'package:flutter/material.dart';
import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/utils/globals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Size size = WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio;
  Map<String, dynamic> customerData = {};
  PhoneNumber number = PhoneNumber(isoCode: countryConfigs['isoCode']);
  String _firstname = '';
  String _lastname = '';
  String _displayname = '';
  String _email = '';
  String dialCode = '';
  String _phone = '';
  String _finalPhoneFormat = '';
  int _dob = 0;
  String _address = '';
  String _profile_image_path = '';
  dynamic _profile_image_file;
  dynamic addressObj;
  String _formattedDob = '';
  final DateTime _initialDob = DateTime(1999, 01, 01);
  final dateFormat = DateFormat.yMMMd();
  dynamic selectedFile;
  String imagePath = '';
  final ImagePicker picker = ImagePicker();
	GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  final TextEditingController _firstNameTextEditingController = TextEditingController();
  final TextEditingController _lastNameTextEditingController = TextEditingController();
  final TextEditingController _phoneTextEditingController = TextEditingController();
  final TextEditingController _searchAddressTextEditingController = TextEditingController();

  bool _isFirstNameEditing = false;
  bool _isLastNameEditing = false;
  bool _isPhoneEditing = false;
  bool _isDobEditing = false;
  bool routeBack = false;

  RegExp nameRegExp = RegExp(r'^[0-9A-Za-z\s\-]+$');
  bool checkPhone = true;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  void dispose() {
    _searchAddressTextEditingController.dispose();
    _firstNameTextEditingController.dispose();
    _lastNameTextEditingController.dispose();
    _phoneTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: WillPopScope(
        onWillPop: () async => !Navigator.of(context).userGestureInProgress,
        child: Scaffold(
        appBar: AppBar(
          title: Text(
            dictionaryObj['side_nav']['Profile'],
            style: const TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
          automaticallyImplyLeading: routeBack,
          backgroundColor: ColorConstant.midnight,
          actions: <Widget>[
            if (sharedPreferences.getString('prev_route') == '/deep-linking') ...[
              IconButton(
                icon: const Text('Skip', style: TextStyle(fontSize: 18, color: Colors.white)),
                iconSize: 50.0,
                tooltip: 'Skip',
                onPressed: () async => {
                  await sharedPreferences.setString('prev_route', ''),
                  Navigator.of(context, rootNavigator: true).pushReplacementNamed('/home_page')
                },
              ),
            ] else ...[
              IconButton(
                icon: const Text('Done', style: TextStyle(fontSize: 18, color: Colors.white)),
                iconSize: 50.0,
                tooltip: 'Done',
                onPressed: () async => {
                  await sharedPreferences.setString('user_full_name', _displayname),
                  customerManager.updateProfile({
                    'newProfile': {
                      'profile_firstname': _firstname,
                      'profile_lastname': _lastname,
                      'profile_phone': _finalPhoneFormat,
                      'profile_dob': _dob,
                      'profile_address': addressObj
                    }
                  }, sharedPreferences.getString('user_id')!),
                  getProfileData(),
                  Navigator.pushReplacementNamed(context, '/home_page')
                },
              ),
            ]
          ],
        ),
        backgroundColor: ColorConstant.midnight,
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (selectedFile != null)
                              ? getProfileImage(FileImage(selectedFile))
                              : (_profile_image_file != null)
                                  ? getProfileImage(FileImage(_profile_image_file))
                                  : getProfileImage(const AssetImage('assets/images/images.png')),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: Text(
                              _displayname,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: ColorConstant.white,
                                fontSize: (20),
                                fontFamily: 'Caros',
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 40),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          width: size.width,
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          decoration: const BoxDecoration(
                            color: ColorConstant.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.00),
                              topRight: Radius.circular(40.00),
                            ),
                          ),
                          child: ListView(children: [
                            const SizedBox(height: 50),
                            // first name
                            ValueListenableBuilder(
                                valueListenable: _firstNameTextEditingController,
                                builder: (context, TextEditingValue value, __) {
                                  return ListTile(
                                    title: Text(dictionaryObj['profile']['FirstName']),
                                    subtitle: _isFirstNameEditing
                                        ? TextField(
                                            autocorrect: false,
                                            textCapitalization: TextCapitalization.sentences,
                                            controller: _firstNameTextEditingController,
                                            decoration: InputDecoration(
                                                hintText: dictionaryObj['profile']['EnterFirstName'],
                                                errorText: _errorTextFirst,
                                                errorMaxLines: 2),
                                            autofocus: true,
                                            onChanged: (_) => {
                                              if (mounted) setState(() => {_firstname = _})
                                            },
                                            onSubmitted: (value) async => {
                                              if (_errorTextFirst == null) updateFirstNametoDB(),
                                            },
                                          )
                                        : (_firstname != ''
                                            ? Text(_firstname)
                                            : Text(dictionaryObj['profile']['EnterFirstName'])),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: _firstNameTextEditingController.value.text.isEmpty
                                          ? () async => updateFirstNametoDB()
                                          : () async => {
                                                if (_errorTextFirst == null) updateFirstNametoDB(),
                                              },
                                    ),
                                  );
                                }),
                            // last name
                            ValueListenableBuilder(
                                valueListenable: _lastNameTextEditingController,
                                builder: (context, TextEditingValue value, __) {
                                  return ListTile(
                                    title: Text(dictionaryObj['profile']['LastName']),
                                    subtitle: _isLastNameEditing
                                        ? TextField(
                                            autocorrect: false,
                                            textCapitalization: TextCapitalization.sentences,
                                            controller: _lastNameTextEditingController,
                                            decoration: InputDecoration(
                                                hintText: dictionaryObj['profile']['EnterLastName'],
                                                errorText: _errorTextLast,
                                                errorMaxLines: 2),
                                            autofocus: true,
                                            onChanged: (_) => {
                                              if (mounted) setState(() => {_lastname = _})
                                            },
                                            onSubmitted: (value) async => {
                                              if (_errorTextLast == null) updateLastNametoDB(),
                                            },
                                          )
                                        : (_lastname != ''
                                            ? Text(_lastname)
                                            : Text(dictionaryObj['profile']['EnterLastName'])),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: _lastNameTextEditingController.value.text.isEmpty
                                          ? () async => updateLastNametoDB()
                                          : () async => {
                                                if (_errorTextLast == null) updateLastNametoDB(),
                                              },
                                    ),
                                  );
                                }),
                            //email
                            ListTile(
                              title: Text(dictionaryObj['profile']['Email']),
                              subtitle: Text(_email),
                            ),
                            // phone
                            ListTile(
                              title: Text(dictionaryObj['profile']['Phone']),
                              subtitle: _isPhoneEditing
                                  ? InternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber number) {
                                        dialCode = number.dialCode as String;
                                        _phone = _phoneTextEditingController.text;
                                        _finalPhoneFormat = '$dialCode $_phone';
                                      },
                                      onFieldSubmitted: (String value) =>
                                          {if (checkPhone) updatePhoneNumbertoDB()},
                                      onInputValidated: (bool value) {
                                        checkPhone = value;
                                        if (value) _phone = _phoneTextEditingController.text;
                                      },
                                      selectorConfig: const SelectorConfig(
                                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                      ),
                                      ignoreBlank: false,
                                      autoValidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: number,
                                      textFieldController: _phoneTextEditingController,
                                      formatInput: false,
                                      keyboardType: const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                      onSaved: (PhoneNumber number) {},
                                    )
                                  : (_phone != ''
                                      ? Text('$dialCode $_phone')
                                      : Text(dictionaryObj['phone_number']['PhoneValidation'])),
                              trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async => {if (checkPhone) updatePhoneNumbertoDB()}),
                            ),
                            //dob
                            ListTile(
                              title: Text(dictionaryObj['profile']['dob']),
                              subtitle: _dob == 0
                                  ? Text(dictionaryObj['profile']['EnterDOB'])
                                  : Text(_formattedDob),
                              trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    var selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: _initialDob,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (selectedDate != null) {
                                      if (mounted) {
                                        setState(() {
                                          _dob = selectedDate.millisecondsSinceEpoch;
                                          _formattedDob = dateFormat
                                              .format(DateTime.fromMillisecondsSinceEpoch(_dob));
                                          updateDobToDB();
                                        });
                                      }
                                    }
                                  }),
                            ), // end of dob list tile
                            // address
                            ListTile(
                              title: Text(dictionaryObj['profile']['address']),
                              subtitle: (_address != ''
                                  ? Text(_address)
                                  : Text(dictionaryObj['profile']['EnterAddress'])),
                              trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    updateAddressToDB();
                                  }),
                            ), // end of address list tile
                          ]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          )
        )
      )
    );
  }

  void _toggleFirstNameEditMode() {
    if (mounted && !_isLastNameEditing && !_isPhoneEditing) {
      setState(() => _isFirstNameEditing = !_isFirstNameEditing);
    } else if (_isLastNameEditing) {
      _toggleLastNameEditMode();
      _isFirstNameEditing = !_isFirstNameEditing;
    } else if (_isPhoneEditing) {
      _togglePhoneEditMode();
      _isFirstNameEditing = !_isFirstNameEditing;
    }
  }

  void _toggleLastNameEditMode() {
    if (mounted && !_isFirstNameEditing && !_isPhoneEditing) {
      setState(() => _isLastNameEditing = !_isLastNameEditing);
    } else if (_isFirstNameEditing) {
      _toggleFirstNameEditMode();
      _isLastNameEditing = !_isLastNameEditing;
    } else if (_isPhoneEditing) {
      _togglePhoneEditMode();
      _isLastNameEditing = !_isLastNameEditing;
    }
  }

  void _togglePhoneEditMode() {
    if (mounted && !_isFirstNameEditing && !_isLastNameEditing && !_isDobEditing) {
      setState(() => _isPhoneEditing = !_isPhoneEditing);
    } else if (_isFirstNameEditing) {
      _toggleFirstNameEditMode();
      _isPhoneEditing = !_isPhoneEditing;
    } else if (_isLastNameEditing) {
      _toggleLastNameEditMode();
      _isPhoneEditing = !_isPhoneEditing;
    }
  }

  void _toggleDobEditMode() {
    if (mounted && !_isPhoneEditing && !_isLastNameEditing && !_isFirstNameEditing) {
      setState(() => _isDobEditing = !_isDobEditing);
    } else if (_isFirstNameEditing) {
      _toggleFirstNameEditMode();
    } else if (_isLastNameEditing) {
      _toggleLastNameEditMode();
    } else if (_isPhoneEditing) {
      _togglePhoneEditMode();
    }
  }

  String? get _errorTextFirst {
    final text = _firstNameTextEditingController.value.text;
    if ((text.length > 20)) {
      return dictionaryObj['profile']['NameValidationLength'];
    }
    if (!nameRegExp.hasMatch(text)) {
      return dictionaryObj['profile']['NameValidation'];
    }
    return null;
  }

  String? get _errorTextLast {
    final text = _lastNameTextEditingController.value.text;
    if ((text.length > 20)) {
      return dictionaryObj['profile']['NameValidationLength'];
    }
    if (!nameRegExp.hasMatch(text)) {
      return dictionaryObj['profile']['NameValidation'];
    }
    return null;
  }

  void updateFirstNametoDB() async {
    await sharedPreferences.setString('prev_route', '');
    //  !_isLastNameEditing ?
    _toggleFirstNameEditMode();
    //  : _isLastNameEditing = !_isLastNameEditing;
  }

  void updateLastNametoDB() async {
    await sharedPreferences.setString('prev_route', '');
    //  !_isFirstNameEditing ?
    _toggleLastNameEditMode();
    //  : _isFirstNameEditing = !_isFirstNameEditing;
  }

  void updatePhoneNumbertoDB() async {
    await sharedPreferences.setString('prev_route', '');
    _togglePhoneEditMode();
    _finalPhoneFormat = '$dialCode $_phone';
  }

  void updateDobToDB() async {
    await sharedPreferences.setString('prev_route', '');
    _toggleDobEditMode();
  }

  void updateAddressToDB() async {
    await sharedPreferences.setString('prev_route', '');
    // ignore: use_build_context_synchronously
    var selectedSuggestion = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => const SearchAddressModal()
    );

    if (selectedSuggestion.runtimeType.toString() == 'Suggestion') {
      PlaceApiProvider(sharedPreferences.getString('session_id'))
      .getPlaceDetailFromId(selectedSuggestion.placeId)
      .then((place) async {
        addressObj = {
          'address_street': '${place.streetNumber} ${place.street}',
          'address_city': place.city,
          'address_state': place.state,
          'address_zip': place.zipCode,
          'address_country': place.country
        };
        if (mounted) {
          setState(() {
          _address = '${addressObj['address_street']}, ${addressObj['address_city']}, ${addressObj['address_state']}, ${addressObj['address_zip']}, ${addressObj['address_country']}';
         });
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      var manualAddressEntry = await showDialog(
        context: context, 
        builder: (context) => getAddressForm()
      );
      if(manualAddressEntry != null){
        addressObj = manualAddressEntry;
        if(mounted) {
          setState(() {
            _address = '${addressObj['address_street']}, ${addressObj['address_city']}, ${addressObj['address_state']}, ${addressObj['address_zip']}, ${addressObj['address_country']}';
          });
        }
      }
    }
  }

  Future<void> getProfileData() async {
    if (mounted) {
      setState(() {
        customerData = customerEntity.getResource();
        _email = customerData['user_email'] != '' ? customerData['user_email'] : '';
        if (customerData['profile'] != null && customerData['profile'].isNotEmpty) {
          _firstname =
              customerData['profile']['profile_firstname'] != '' ? customerData['profile']['profile_firstname'] : '';
          _lastname =
              customerData['profile']['profile_lastname'] != '' ? customerData['profile']['profile_lastname'] : '';
          _displayname = ('$_firstname $_lastname').trim() != '' ? ('$_firstname $_lastname').trim() : '';
          if (customerData['profile']['profile_phone'] != '') {
            var splitted = customerData['profile']['profile_phone'].split(' ');
            _phone = splitted[1] != '' ? splitted[1] : '';
            dialCode = splitted[0] != '' ? splitted[0] : '';
            _finalPhoneFormat = '$dialCode $_phone';
          } else {
            _phone = '';
          }
          _dob = customerData['profile']['profile_dob'] != 0 ? customerData['profile']['profile_dob'] : 0;
          _formattedDob = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_dob));
          if (customerData['profile']['profile_address'] != null) {
            if (customerData['profile']['profile_address']['address_street'] != '') {
              addressObj = customerData['profile']['profile_address'];
              _address =
                  '${addressObj['address_street']}, ${addressObj['address_city']}, ${addressObj['address_state']}, ${addressObj['address_zip']}, ${addressObj['address_country']}';
            }
          }

          selectedFile = sharedPreferences.getString('image_path') != null
              ? File(sharedPreferences.getString('image_path')!)
              : null;

          if (customerData['profile']['profile_image_path'] != null &&
              customerData['profile']['profile_image_path'] != '') {
            _profile_image_path = customerData['profile']['profile_image_path'];
            StorageServiceProvier().retrieveFile(_profile_image_path).then((value) => {
                  if (mounted)
                    setState(() {
                      _profile_image_file = value;
                    })
                });
          } else {
            _profile_image_file = null;
            _profile_image_path = '';
          }
        }
      });
    }
    _firstNameTextEditingController.text = _firstname;
    _lastNameTextEditingController.text = _lastname;
    _phoneTextEditingController.text = _phone;
    routeBack = (sharedPreferences.getString(('prev_route')) == '/deep-linking') ? false : true;
  }

  Future<dynamic> getImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, requestFullMetadata: false);
    if (image != null) {
      await sharedPreferences.remove('image_path');
      if (mounted) {
        setState(() {
          selectedFile = File(image.path);
        });
      }
      await sharedPreferences.setString('image_path', image.path);
    }
    return selectedFile;
  }

  Future<dynamic> takePicture() async {
    XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (photo != null) {
      await sharedPreferences.remove('image_path');
      if (mounted) {
        setState(() {
          selectedFile = File(photo.path);
        });
      }
      await sharedPreferences.setString('image_path', photo.path);
    }

    return selectedFile;
  }

  CircleAvatar getProfileImage(selectedImage) {
    return CircleAvatar(
        radius: 58,
        backgroundImage: selectedImage,
        child: Stack(children: [
          Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      _showPopup(context);
                    },
                  )))
        ]));
  }

  PopupMenuEntry getPopupMenuItem(MapEntry<dynamic, dynamic> entry) {
    return PopupMenuItem(
      height: 50,
      value: entry.key,
      onTap: entry.value['action'],
      child: SizedBox(
        child: Row(
          children: [
            Icon(entry.value['icon'], color: ColorConstant.darkblue),
            const SizedBox(width: 10.0),
            Text(entry.key)
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) async {
    Map<String, Map<String, dynamic>> options = {
      dictionaryObj['profile']['ProfilePicture']: {
        'icon': Icons.photo,
        'action': () async => {
              await getImage(),
              if (selectedFile != null)
                {
                  imagePath = await StorageServiceProvier().uploadFile(selectedFile, 'images'),
                  await customerManager.updateProfile({
                    'newProfile': {'profile_image_path': imagePath}
                  }, sharedPreferences.getString('user_id')!),
                  _profile_image_path = imagePath,
                  _profile_image_file = await StorageServiceProvier().retrieveFile(imagePath),
                  if (mounted)
                    setState(() => {
                          if (sharedPreferences.getString('image_path') != null)
                            {selectedFile = File(sharedPreferences.getString('image_path')!)},
                          getProfileData()
                        })
                },
            }
      },
      dictionaryObj['profile']['TakePhoto']: {
        'icon': Icons.camera_alt,
        'action': () async => {
              await takePicture(),
              if (selectedFile != null)
                {
                  imagePath = await StorageServiceProvier().uploadFile(selectedFile, 'images'),
                  await customerManager.updateProfile({
                    'newProfile': {'profile_image_path': imagePath}
                  }, sharedPreferences.getString('user_id')!),
                  _profile_image_file = await StorageServiceProvier().retrieveFile(imagePath),
                  if (mounted)
                    setState(() => {
                          _profile_image_path = imagePath,
                          selectedFile = File(sharedPreferences.getString('image_path')!)
                        }),
                  getProfileData()
                }
            }
      },
      dictionaryObj['profile']['RemovePhoto']: {
        'icon': Icons.delete,
        'action': () async => {
              if (_profile_image_path != '')
                {
                  await StorageServiceProvier().removeFile(_profile_image_path),
                  await customerManager.updateProfile({
                    'newProfile': {'profile_image_path': ''}
                  }, sharedPreferences.getString('user_id')!),
                  await sharedPreferences.remove('image_path'),
                  if (mounted)
                    setState(() => {
                          selectedFile = null,
                          _profile_image_path = '',
                          _profile_image_file = null,
                        })
                }
            }
      },
      dictionaryObj['Cancel']: {'icon': Icons.cancel, 'action': () => {}},
    };

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final top = offset.dy + renderBox.size.height / 3;
    final right = offset.dx;
    final left = right + renderBox.size.width;

    await showMenu<dynamic>(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        context: context,
        position: RelativeRect.fromLTRB(left, top, right, 0.0),
        items: options.entries.map<PopupMenuEntry<dynamic>>((entry) {
          return getPopupMenuItem(entry);
        }).toList());
  }

  AlertDialog getAddressForm() {
    String street = '';
    String city = '';
    String state = '';
    String zipCode = '';

		return AlertDialog(
			title: const Text('Enter Address'),
			content: SingleChildScrollView(
        child: Form(
          key: addressFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Street'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter street';
                  }
                  return null;
                },
                onSaved: (value) => street = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
                onSaved: (value) => city = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter state';
                  }
                  return null;
                },
                onSaved: (value) => state = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Zip Code'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter zip code';
                  }
                  return null;
                },
                onSaved: (value) => zipCode = value ?? '',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.midnight
                  ),
                  child: const Text('Save'),
                  onPressed: () {
                    if (addressFormKey.currentState!.validate()) {
                      addressFormKey.currentState!.save();
                      var manualAddressObj = {
                        'address_street': street,
                        'address_city': city,
                        'address_state': state,
                        'address_zip': zipCode,
                        'address_country': countryConfigs['country']
                      };
                      Navigator.of(context, rootNavigator: true).pop(manualAddressObj);
                    }
                  },
                ),
              ),
            ],
          ),
        )
      )
    );
	 }
}
