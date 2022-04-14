import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final String token;

  LoggedIn({required this.token}) : super([token]);

  @override
  String toString() => 'LoggedIn { token: $token }';

  @override
  List<Object> get props => [token];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class StartInitializing extends AuthenticationEvent {
  @override
  String toString() => 'Start Intialize';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FinishInitializing extends AuthenticationEvent {
  @override
  String toString() => 'Finish Intialize';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GoInside extends AuthenticationEvent {
  @override
  String toString() => 'Going inside';

  @override
  // TODO: implement props
  List<Object> get props => [];
}
