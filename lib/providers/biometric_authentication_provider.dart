import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
		
class BiometricAuthenticationProvider {
	final LocalAuthentication localAuthentication = LocalAuthentication();
	bool isBiometricEnabled = false;

	Future<bool> registeredUser() async {
		isBiometricEnabled = await localAuthentication.isDeviceSupported();

		return isBiometricEnabled;
	}

	Future<bool> authenticateUser() async {

		bool isAuthenticated = false;

		List<BiometricType> biometricType = await localAuthentication.getAvailableBiometrics();

		if(await registeredUser()) {
			 try {
        isAuthenticated = await localAuthentication.authenticate(
            localizedReason: 'To continue, you must complete the biometrics',
            options: const AuthenticationOptions(
							biometricOnly: true,
							useErrorDialogs: true,
							stickyAuth: true));
      } on PlatformException catch (e) {
        print(e);
      }
		}

		return isAuthenticated;
	}
}