import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {}

class UninitializedAuth extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class Loading extends AuthenticationState {}

class Initializing extends AuthenticationState {}

class Initialized extends AuthenticationState {}

