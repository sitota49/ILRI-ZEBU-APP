import 'dart:async';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
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
      var res = await userRepository.getUser();
      print(res);
      // yield Authenticated();
      add(StartInitializing());
    }

    if (event is LoggedOut) {
      yield Loading();
      await userRepository.logOut();
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
