import 'package:zebu_app/bloc/menu/menu_bloc.dart';
import 'package:zebu_app/bloc/menu/menu_event.dart';
import 'package:zebu_app/bloc/menu/menu_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/repository/menu_repository.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc({required this.menuRepository}) : super(LoadingMenu());

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is AllMenuLoad) {
      yield LoadingMenu();
      try {
        final allMenu = await menuRepository.getAllMenu();
        if (allMenu.isEmpty) {
          yield const AllMenuEmpltyFailure(message: "No Menu Items Found");
        } else {
          yield AllMenuLoadSuccess(allMenu);
        }
      } catch (error) {
        print(error);
        yield AllMenuLoadFailure();
      }
    }
    if (event is CategoryMenuLoad) {
      yield LoadingMenu();
      try {
        final categoryMenu = await menuRepository.getCategoryMenu(event.id);

        if (categoryMenu.isEmpty) {
          yield const CategoryMenuEmpltyFailure(message: "No Menu Items Found");
        } else {
          yield CategoryMenuLoadSuccess(categoryMenu);
        }
      } catch (error) {
        print(error);
        yield CategoryMenuLoadFailure();
      }
    }
    if (event is SingleMenuLoad) {
      yield LoadingMenu();
      try {
        final menu = await menuRepository.getSingleMenu(event.id);

        if (menu != null) {
          yield SingleMenuLoadSuccess(menu);
        }
      } catch (error) {
        print(error);
        yield SingleMenuLoadFailure();
      }
    }
    
  }
}

