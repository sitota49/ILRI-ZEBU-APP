import 'package:equatable/equatable.dart';

class NetworkConnectivityState  extends Equatable {
  const NetworkConnectivityState ();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class InitialNetworkConnectivityState extends NetworkConnectivityState {}

class NetworkOnline extends NetworkConnectivityState {}

class NetworkOffline extends NetworkConnectivityState {}
