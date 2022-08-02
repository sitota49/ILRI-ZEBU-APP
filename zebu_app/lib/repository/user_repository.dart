import 'dart:convert';

import "package:firebase_auth/firebase_auth.dart";
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> sendOtp(
      String phoneNumber,
      Duration timeOut,
      PhoneVerificationFailed phoneVerificationFailed,
      PhoneVerificationCompleted phoneVerificationCompleted,
      PhoneCodeSent phoneCodeSent,
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout) async {
    print("before call");
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeOut,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
    print("after call");
  }

  Future<UserCredential> verifyAndLogin(
      String verificationId, String smsCode) async {
    AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    return _firebaseAuth.signInWithCredential(authCredential);
  }

  Future<User> getUser() async {
    var user = await _firebaseAuth.currentUser!;
    return user;
  }

  Future<bool> hasUser() async {
    var user = await _firebaseAuth.currentUser != null;
    return user;
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Future<dynamic> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fetchedUser = json.decode(prefs.getString('user')!);
    return fetchedUser;
  }
}
