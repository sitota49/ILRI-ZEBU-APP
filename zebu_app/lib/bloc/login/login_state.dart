import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState extends Equatable {}

class InitialLoginState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoadingState extends LoginState {
  String message;

  LoadingState({required this.message});
  @override
  List<Object> get props => [];
}

class LinkSentState extends LoginState {
  @override
  List<Object> get props => [];
}

class OtpSentState extends LoginState {
  String phoneNumber;

  OtpSentState(this.phoneNumber);
  String getPhone() {
    return phoneNumber;
  }

  @override
  List<Object> get props => [];
}

class OtpVerifiedState extends LoginState {
  @override
  List<Object> get props => [];
}
class PhoneVerifiedState extends LoginState {
  @override
  List<Object> get props => [];
}
class LoginCompleteState extends LoginState {
  User _firebaseUser;

  LoginCompleteState(this._firebaseUser);
  User getUser() {
    return _firebaseUser;
  }

  @override
  List<Object> get props => [_firebaseUser];
}

class ExceptionState extends LoginState {
  String message;

  ExceptionState({required this.message});

  @override

  List<Object> get props => [message];
}

class OtpExceptionState extends LoginState {
  String message;

  OtpExceptionState({required this.message});

  @override

  List<Object> get props => [message];
}
