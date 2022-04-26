import 'package:zebu_app/models/service.dart';
import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();
}

class AllServiceLoad extends ServiceEvent {
  const AllServiceLoad();

  @override
  List<Object> get props => [];
}
