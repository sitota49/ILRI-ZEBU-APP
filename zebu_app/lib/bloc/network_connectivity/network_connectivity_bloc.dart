
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_event.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_state.dart';

import 'package:zebu_app/repository/feedback_repository.dart';

class NetworkConnectivityBloc
    extends Bloc<NetworkConnectivityEvent, NetworkConnectivityState> {
  NetworkConnectivityBloc() : super(InitialNetworkConnectivityState());

  bool networkOfflineOnce = false;
  ConnectivityResult? connectivityResult;
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  Stream<NetworkConnectivityState> mapEventToState(
    NetworkConnectivityEvent event,
  ) async* {
    if (event is InitNetworkConnectivity) {
      connectivity = Connectivity();
      connectivityResult = await (connectivity!.checkConnectivity());
      add(SetNetworkStatus(connectivityResult: connectivityResult));
    }

    if (event is ListenNetworkConnectivity) {
      if (connectivity == null) {
        add(InitNetworkConnectivity());
      }

      _connectivitySubscription = connectivity!.onConnectivityChanged
          .listen((ConnectivityResult result) {
        add(SetNetworkStatus(connectivityResult: result));
      });
    }

    if (event is SetNetworkStatus) {
      if (event.connectivityResult == ConnectivityResult.mobile) {
        if (networkOfflineOnce) {
          networkOfflineOnce = false;
        }

        yield NetworkOnline();
        print("Connected => Cellular Network");
      } else if (event.connectivityResult == ConnectivityResult.wifi) {
        if (networkOfflineOnce) {
          networkOfflineOnce = false;
        }

        yield NetworkOnline();
        print("Connected => WiFi");
      } else {
        networkOfflineOnce = true;
        yield NetworkOffline();
        print("Not Connected => Offline , Please Check Internet Connection");
      }
    }
  }

  dispose() {
    _connectivitySubscription!.cancel();
  }
}
