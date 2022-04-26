import 'package:zebu_app/models/menu.dart';
import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();
}

class RecentlyViewedLoad extends MenuEvent {
  const RecentlyViewedLoad();

  @override
  List<Object> get props => [];
}

class AllMenuLoad extends MenuEvent {
  final String queryparam;
  const AllMenuLoad(this.queryparam);

  @override
  List<Object> get props => [];
}

class CategoryMenuLoad extends MenuEvent {
  final String id;
  const CategoryMenuLoad(this.id);

  @override
  List<Object> get props => [];
}

class SingleMenuLoad extends MenuEvent {
  final String id;
  const SingleMenuLoad(this.id);

  @override
  List<Object> get props => [];
}
