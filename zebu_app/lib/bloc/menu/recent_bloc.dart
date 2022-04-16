import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/bloc/menu/menu_event.dart';

import 'package:zebu_app/bloc/menu/recent_state.dart';
import 'package:zebu_app/repository/menu_repository.dart';

class RecentMenuBloc extends Bloc<MenuEvent, RecentMenuState> {
  final MenuRepository menuRepository;

  RecentMenuBloc({required this.menuRepository}) : super(LoadingRecentMenu());

  @override
  Stream<RecentMenuState> mapEventToState(MenuEvent event) async* {
    if (event is RecentlyViewedLoad) {
      yield LoadingRecentMenu();
      try {
        final recentlyViewed = await menuRepository.getRecentlyviewed();
        if (recentlyViewed.isEmpty) {
          yield RecentlyViewedLoadFailure();
        } else {
          yield RecentlyViewedLoadSuccess(recentlyViewed);
        }
      } catch (error) {
        print(error);
        yield RecentlyViewedLoadFailure();
      }
    }
  }
}
