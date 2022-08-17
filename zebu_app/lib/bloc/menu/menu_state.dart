import 'package:equatable/equatable.dart';

class MenuState extends Equatable {
  const MenuState();
  final String failureMessage = "Please check your internet connection and try again.";
  @override
  List<Object> get props => [];
}



class LoadingMenu extends MenuState {}

class AllMenuLoadSuccess extends MenuState {
  final List<dynamic> allMenus;

  const AllMenuLoadSuccess([this.allMenus = const []]);

  @override
  List<Object> get props => [allMenus];
}

class AllMenuLoadFailure extends MenuState {}

class AllMenuEmpltyFailure extends MenuState {
  final String message;

  const AllMenuEmpltyFailure({required this.message});
}

class CategoryMenuLoadSuccess extends MenuState {
  final List<dynamic> categoryMenus;

  const CategoryMenuLoadSuccess([this.categoryMenus = const []]);

  @override
  List<Object> get props => [categoryMenus];
}

class CategoryMenuLoadFailure extends MenuState {}

class CategoryMenuEmpltyFailure extends MenuState {
  final String message;

  const CategoryMenuEmpltyFailure({required this.message});
}

class SingleMenuLoadSuccess extends MenuState {
  final dynamic singleMenu;

  const SingleMenuLoadSuccess([this.singleMenu = const []]);

  @override
  List<Object> get props => [singleMenu];
}

class SingleMenuLoadFailure extends MenuState {}

