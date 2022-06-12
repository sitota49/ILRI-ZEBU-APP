import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  const UserState();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class LoadingUser extends UserState {}

class UserLoadSuccess extends UserState {
  final dynamic userInfo;

  const UserLoadSuccess([this.userInfo = const []]);

  @override
  List<Object> get props => [userInfo];
}

class UserLoadFailure extends UserState {}
