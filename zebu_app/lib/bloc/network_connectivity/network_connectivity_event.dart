import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';


abstract class NetworkConnectivityEvent  extends Equatable {
  const NetworkConnectivityEvent ();

  @override
  List<Object> get props => [];
}


class InitNetworkConnectivity extends NetworkConnectivityEvent {}

class ListenNetworkConnectivity extends NetworkConnectivityEvent {}

class SetNetworkStatus extends NetworkConnectivityEvent {
  final ConnectivityResult? connectivityResult;
  const SetNetworkStatus({required this.connectivityResult});

  @override
  String toString() =>
      'connectivityResult {connectivityResult: $connectivityResult}';
}
