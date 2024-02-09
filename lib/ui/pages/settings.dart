import 'package:client_app/providers/biometric_authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/ui/widgets/appbar.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:client_app/ui/pages/delete_account_page.dart';

import 'package:client_app/constants/color_constant.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

bool isSwitched = false;
bool check = false;

showVerificationBadge() {
  if (sharedPreferences.getString('user_status') == 'unverified') {
    check = false;
    return Chip(
      padding: const EdgeInsets.all(0),
      backgroundColor: ColorConstant.bluegrey,
      label: Padding(
        padding: const EdgeInsets.only(left: 0, bottom: 5, right: 0, top: 5), //apply padding to some sides only
        child:
            Text(dictionaryObj['user_status']['Unverified'], style: const TextStyle(color: Colors.white, fontSize: 11)),
      ),
    );
  } else {
    check = true;
    return;
  }
}

void onSwitchChanged(bool value) async {
  if (value) {
    if (await BiometricAuthenticationProvider().registeredUser()) {
      isSwitched = value;
      sharedPreferences.setBool('is_auth_enabled', true);
    }
  } else if (!value) {
    isSwitched = value;
    sharedPreferences.setBool('is_auth_enabled', false);
  }
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppbarWidget(
            subject: dictionaryObj['setting']['Setting'],
            actions: const [],
            routeBack: false,
          ),
          body: SettingsList(
            sections: [
              SettingsSection(
                title: Text(dictionaryObj['setting']['Account']),
                tiles: <SettingsTile>[
                  SettingsTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Profile'),
                    onPressed: (BuildContext context) => {Navigator.pushNamed(context, '/profile')},
                    trailing: showVerificationBadge(),
                    enabled: check,
                  ),
                  SettingsTile(
                    onPressed: (BuildContext context) => {
                      Navigator.pushNamed(context, '/logout')
                    },
                    leading: const Icon(Icons.logout),
                    title: Text(dictionaryObj['setting']['LogOut']),
                  ),
                ],
              ),
              SettingsSection(
                title: Text(dictionaryObj['setting']['Common']),
                tiles: <SettingsTile>[
                  SettingsTile(
                    leading: const Icon(Icons.language),
                    title: Text(dictionaryObj['setting']['Language']),
                    value: Text(dictionaryObj['setting']['English']),
                  ),
                ],
              ),
              SettingsSection(
                title: Text(dictionaryObj['setting']['Security']),
                tiles: <SettingsTile>[
                  SettingsTile(
                    onPressed: (BuildContext context) => {
                      Navigator.pushNamed(context, '/change_password'),
                    },
                    leading: const Icon(Icons.lock),
                    title: Text(dictionaryObj['forgot_password']['ChangePass']),
                  ),
                  SettingsTile(
                    onPressed: (BuildContext context) => {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DeleteAccountPage()))
                    },
                    leading: const Icon(Icons.delete_outline),
                    title: Text(dictionaryObj['setting']['DeleteAccount']),
                  ),
                  // if (bioEnabled) ...[
                  //   SettingsTile(
                  //     title: SwitchListTile.adaptive(
                  //       value: sharedPreferences.getBool('is_auth_enabled') ?? false,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           onSwitchChanged(value);
                  //         });
                  //       },
                  //       title: Text(dictionaryObj['setting']['BiometricAuthentication']),
                  //       subtitle: Text(dictionaryObj['setting']['FingerprintID']),
                  //     ),
                  //     leading: const Icon(Icons.fingerprint),
                  //   )
                  // ]
                ],
              ),   
              SettingsSection(
                title: Text(dictionaryObj['setting']['About']),
                tiles: <SettingsTile>[
                  SettingsTile(
                    leading: const Icon(Icons.info),
                    title: Text(dictionaryObj['setting']['Version']),
                    value: Text(globalSettings['version']),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
