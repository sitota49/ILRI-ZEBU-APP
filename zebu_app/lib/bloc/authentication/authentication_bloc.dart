import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/authentication/authentication_event.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/repository/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(InitialAuthenticationState());

  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.getUser() != null;

      if (hasToken) {
        yield Initialized();
        add(GoInside());
      } else {
        yield Unauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield Loading();
      await userRepository.getUser();
      // yield Authenticated();
      add(StartRegistering());
    }

    if (event is StartRegistering) {
      yield Registering();
    }

    if (event is FinishRegistering) {
      yield Registered();
      add(StartInitializing());
    }

    if (event is LoggedOut) {
      yield Loading();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await userRepository.logOut();

      Directory tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }

      Directory appDocDir = await getApplicationDocumentsDirectory();

      if (appDocDir.existsSync()) {
        appDocDir.deleteSync(recursive: true);
      }
      yield Unauthenticated();
      add(AppStarted());
    }

    if (event is StartInitializing) {
      yield Initializing();
    }
    if (event is FinishInitializing) {
      yield Initialized();
      add(GoInside());
    }
    if (event is GoInside) {
      yield Inside();
    }
  }
}
