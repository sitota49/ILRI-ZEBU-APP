import 'dart:async';
import 'package:zebu_app/bloc/login/login_bloc.dart';
import 'package:zebu_app/bloc/login/login_event.dart';
import 'package:zebu_app/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zebu_app/repository/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  late StreamSubscription subscription;

  String verID = "";

  // LoginBloc({required UserRepository userRepository})
  //     : assert(userRepository != null),
  //       userRepository = userRepository, super(InitialLoginState());
  LoginBloc({required this.userRepository})
      : super(InitialLoginState());

  @override
  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SendOtpEvent) {
      yield LoadingState();

      subscription = sendOtp(event.phoneNumber).listen((event) {
        add(event);
      });
    } else if (event is OtpSendEvent) {
      yield OtpSentState();
    } else if (event is LoginCompleteEvent) {
      yield LoginCompleteState(event.firebaseUser);
    } else if (event is LoginExceptionEvent) {
      yield ExceptionState(message: event.message);
    } else if (event is VerifyOtpEvent) {
      yield LoadingState();
      try {
        UserCredential result =
            await userRepository.verifyAndLogin(verID, event.otp);
        if (result.user != null) {
          yield LoginCompleteState(result.user!);
        } else {
          yield OtpExceptionState(message: "Invalid otp!");
        }
      } catch (e) {
        yield OtpExceptionState(message: "Invalid otp!");
        print(e);
      }
    }
  }

  @override
  void onEvent(LoginEvent event) {
    // TODO: implement onEvent
    super.onEvent(event);
    print(event);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    // TODO: implement onError
    super.onError(error, stacktrace);
    print(stacktrace);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }

  Stream<LoginEvent> sendOtp(String phoneNumber) async* {
    StreamController<LoginEvent> eventStream = StreamController();
    final PhoneVerificationCompleted = (AuthCredential authCredential) {
      userRepository.getUser();
      userRepository.getUser().catchError((onError) {
        print(onError);
      }).then((user) {
        eventStream.add(LoginCompleteEvent(user));
        eventStream.close();
      });
    };
    final PhoneVerificationFailed = (FirebaseAuthException authException) {
      print(authException.message);
      eventStream.add(LoginExceptionEvent(onError.toString()));
      eventStream.close();
    };
    final PhoneCodeSent = (String verId, [int? forceResent]) {
      this.verID = verId;
      eventStream.add(OtpSendEvent());
    };
    final PhoneCodeAutoRetrievalTimeout = (String verid) {
      this.verID = verid;
      eventStream.close();
    };

    await userRepository.sendOtp(
        phoneNumber,
        Duration(seconds: 1),
        PhoneVerificationFailed,
        PhoneVerificationCompleted,
        PhoneCodeSent,
        PhoneCodeAutoRetrievalTimeout);

    yield* eventStream.stream;
  }
}
