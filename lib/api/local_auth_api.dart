// ignore_for_file: avoid_redundant_argument_values
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final LocalAuthentication _auth = LocalAuthentication();

  // Description: This will authenticate the user with only Biometric eg. FaceID, Fingerprint
  static Future<String> authenticateWithBiometric({
    required String messageReason,
  }) async {
    if (!await deviceSupportsLocalAuth(biometricSupported: true)) {
      return 'Device is not supported with local auth, please setup password';
    }

    try {
      if (await _auth.authenticate(
        localizedReason: messageReason,
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
          biometricOnly: true,
        ),
      )) {
        return 'authenticated';
      }
      return '';
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        return auth_error.notEnrolled;
      }
      return e.toString();
    }
  }

  // Description: This will authenticate the user with anything available from the device.
  Future<bool> canValidate({
    required bool deviceSupported,
    bool? biometricSupported,
  }) async {
    return true;
  }

  static Future<String> authenticate({required String messageReason}) async {
    try {
      if (await _auth.authenticate(
        localizedReason: messageReason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      )) {
        return 'authenticated';
      }
      return '';
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        return 'Device is not supported with local auth, please setup password';
      }
      return e.toString();
    }
  }

  static Future<bool> deviceSupportsLocalAuth({
    required bool biometricSupported,
  }) async {
    final bool isAvailableBiometric = await _auth.canCheckBiometrics;
    final bool isDeviceSupported = await _auth.isDeviceSupported();

    return biometricSupported
        ? isAvailableBiometric && isDeviceSupported
        : isAvailableBiometric;
  }
}
