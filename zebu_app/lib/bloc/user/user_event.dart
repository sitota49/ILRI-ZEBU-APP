import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserInfoLoad extends UserEvent {
  const UserInfoLoad();

  @override
  List<Object> get props => [];
}
