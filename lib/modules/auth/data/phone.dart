import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

import '../../../imports.dart';

mixin PhoneRepository {
  static final _auth = FirebaseAuth.instance;

  static void verifyPhone(
    String phoneNumber, {
    @required void Function(String) onCodeSent,
    @required void Function(AppAuthException) onFailed,
    void Function(String) onVerification,
    void Function() timout,
  }) {
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeAutoRetrievalTimeout: (id) => timout?.call(),
      codeSent: (id, [_]) => onCodeSent?.call(id),
      timeout: const Duration(seconds: 100),
      verificationCompleted: (cred) => onVerification(cred.verificationId),
      verificationFailed: (e) => onFailed(
        AppAuthException.handleError(e),
      ),
    );
  }

  static Future<String> login(String verID, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verID,
      smsCode: smsCode,
    );
    return (await _auth.signInWithCredential(credential)).user.uid;
  }

  static String _initCountryCode;
  static Future<Country> getInitCountry() async {
    _initCountryCode ??= await asyncGuard(
      () => FlutterSimCountryCode.simCountryCode,
      'US',
    );
    return CountryPickerUtils.getCountryByIsoCode(_initCountryCode);
  }
}
