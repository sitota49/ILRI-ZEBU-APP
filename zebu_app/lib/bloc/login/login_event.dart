import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendOtpEvent extends LoginEvent {
  String phoneNumber;

  SendOtpEvent({required this.phoneNumber});
}

class AppStartEvent extends LoginEvent {}

class VerifyOtpEvent extends LoginEvent {
  String otp;

  VerifyOtpEvent({required this.otp});
}

class LogoutEvent extends LoginEvent {}

class OtpSendEvent extends LoginEvent {}

class LoginCompleteEvent extends LoginEvent {
  final User firebaseUser;
  LoginCompleteEvent(this.firebaseUser);
}

class LoginExceptionEvent extends LoginEvent {
  String message;

  LoginExceptionEvent(this.message);
}
