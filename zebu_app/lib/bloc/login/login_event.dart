import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class VerifyPhoneEvent extends LoginEvent {
  String phoneNumber;

  VerifyPhoneEvent({required this.phoneNumber});
}

class SendOtpEvent extends LoginEvent {
  String phoneNumber;

  SendOtpEvent({required this.phoneNumber});
}
class SendLinkEvent extends LoginEvent {
  String email;

  SendLinkEvent({required this.email});
}
class AppStartEvent extends LoginEvent {}

class VerifyOtpEvent extends LoginEvent {
  String otp;

  VerifyOtpEvent({required this.otp});
}

class LogoutEvent extends LoginEvent {}

class OtpSendEvent extends LoginEvent {
  String phoneNumber;

  OtpSendEvent({required this.phoneNumber});
}

class EmailSendEvent extends LoginEvent {}

class LoginCompleteEvent extends LoginEvent {
  final User firebaseUser;
  LoginCompleteEvent(this.firebaseUser);
}

class LoginExceptionEvent extends LoginEvent {
  String message;

  LoginExceptionEvent(this.message);
}
