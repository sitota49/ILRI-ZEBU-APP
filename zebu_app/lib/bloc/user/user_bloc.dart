import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/bloc/user/user_event.dart';
import 'package:zebu_app/bloc/user/user_state.dart';
import 'package:zebu_app/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userInfoRepository;

  UserBloc({required this.userInfoRepository}) : super(LoadingUser());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserInfoLoad) {
      yield LoadingUser();
      try {
        final userInfo = await userInfoRepository.getUserInfo();
        if (userInfo.isEmpty) {
          yield UserLoadFailure();
        } else {
          yield UserLoadSuccess(userInfo);
        }
      } catch (error) {
        print(error);
        yield UserLoadFailure();
      }
    }
  }
}
