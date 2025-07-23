import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    final result = await connectionChecker.checkConnectivity();
    final hasConnection = result != ConnectivityResult.none;
    debugPrint('NetworkInfo: Connection status - $hasConnection');
    return hasConnection;
  }
}
