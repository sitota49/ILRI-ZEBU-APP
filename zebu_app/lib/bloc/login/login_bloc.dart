import 'dart:async';
import 'package:zebu_app/bloc/login/login_event.dart';
import 'package:zebu_app/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zebu_app/repository/user_repository.dart';
import 'package:zebu_app/repository/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  late StreamSubscription subscription;
  final LoginRepository loginRepository;

  String verID = "";

  // LoginBloc({required UserRepository userRepository})
  //     : assert(userRepository != null),
  //       userRepository = userRepository, super(InitialLoginState());
  LoginBloc(this.loginRepository, {required this.userRepository})
      : super(InitialLoginState());

  @override
  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    print(event);
    if (event is VerifyPhoneEvent) {
      yield LoadingState(message: 'Verifiying phone number ...');
      try {
        final verified = await loginRepository.checkPhone(event.phoneNumber);
        if (verified) {
          yield PhoneVerifiedState();
          add(SendOtpEvent(phoneNumber: event.phoneNumber));
        } else {
          yield ExceptionState(message: 'Please use a registered phone number');
        }
      } catch (error) {
        print(error);
        yield ExceptionState(message: 'Please use a registered phone number');
      }
    } else if (event is SendOtpEvent) {
      yield LoadingState(message: 'Sending verification code ...');

      subscription = sendOtp(event.phoneNumber).listen((event) {
        add(event);
      });
    } else if (event is AppStartEvent) {
      yield InitialLoginState();
    } else if (event is OtpSendEvent) {
      yield OtpSentState(event.phoneNumber);
    } else if (event is SendLinkEvent) {
      yield LoadingState(message: 'Sending email ...');

      subscription = sendOtp(event.email).listen((event) {
        add(event);
      });
    } else if (event is EmailSendEvent) {
      yield LinkSentState();
    } else if (event is LoginCompleteEvent) {
      yield LoginCompleteState(event.firebaseUser);
    } else if (event is LoginExceptionEvent) {
      yield ExceptionState(message: event.message);
    } else if (event is VerifyOtpEvent) {
      yield LoadingState(message: 'Verifying your code ...');
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
    super.onEvent(event);
    print(event);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
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
      // userRepository.getUser();
      // print("1111111");
      // userRepository.getUser().catchError((onError) {
      //   print(onError);
      // }).then((user) {
      //   print("verification complete ...");
      //   eventStream.add(LoginCompleteEvent(user));
      //   eventStream.close();
      // });
      eventStream.add(OtpSendEvent(phoneNumber: phoneNumber));
    };
    final PhoneVerificationFailed = (FirebaseAuthException authException) {
      print(authException.message);
      print("verification failed ...");
      eventStream.add(LoginExceptionEvent(onError.toString()));
      eventStream.close();
    };
    final PhoneCodeSent = (String verId, [int? forceResent]) {
      print("verId");
      print(verId);
      this.verID = verId;
      print("sent ...");
      eventStream.add(OtpSendEvent(phoneNumber: phoneNumber));
    };
    final PhoneCodeAutoRetrievalTimeout = (String verid) {
      this.verID = verid;
      print("timeout ...");
      eventStream.close();
    };

    await userRepository.sendOtp(
        phoneNumber,
        Duration(seconds: 60),
        PhoneVerificationFailed,
        PhoneVerificationCompleted,
        PhoneCodeSent,
        PhoneCodeAutoRetrievalTimeout);

    print("res");

    yield* eventStream.stream;
  }
}
