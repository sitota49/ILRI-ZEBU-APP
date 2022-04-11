import 'package:zebu_app/models/zebuUser.dart';
import 'package:zebu_app/data_provider/login_data.dart';
import "package:firebase_auth/firebase_auth.dart";

class LoginRepository {
  final LoginDataProvider dataProvider;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  LoginRepository({required this.dataProvider});

  Future<dynamic> checkPhone(String phoneNumber) async {
    return await dataProvider.checkPhone(phoneNumber);
  }

  Future<dynamic> checkEmail(String email) async {
    return await dataProvider.checkEmail(email);
  }

  Future<void> sendOtp(
      String phoneNumber,
      Duration timeOut,
      PhoneVerificationFailed phoneVerificationFailed,
      PhoneVerificationCompleted phoneVerificationCompleted,
      PhoneCodeSent phoneCodeSent,
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout) async {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeOut,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  Future<dynamic> verifyAndLogin(String _verificationId, String smsCode) async {
    var credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);

    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<dynamic> getUser() async {
    var user = await _firebaseAuth.currentUser!;
    return user;
  }
  
}
