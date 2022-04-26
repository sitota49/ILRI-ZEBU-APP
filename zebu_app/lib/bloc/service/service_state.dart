import 'package:zebu_app/models/menu.dart';
import 'package:equatable/equatable.dart';

class ServiceState extends Equatable {
  const ServiceState();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class LoadingService extends ServiceState {}

class AllServiceLoadSuccess extends ServiceState {
  final List<dynamic> allServices;

  const AllServiceLoadSuccess([this.allServices = const []]);

  @override
  List<Object> get props => [allServices];
}

class AllServiceLoadFailure extends ServiceState {}

class AllServiceEmpltyFailure extends ServiceState {
  final String message;

  const AllServiceEmpltyFailure({required this.message});
}

