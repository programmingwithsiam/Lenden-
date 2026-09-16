import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Tracks whether the device currently has network connectivity.
///
/// Note: connectivity_plus only tells us if a network interface is
/// connected (WiFi/mobile data), not whether it can actually reach the
/// internet. Combined with Firebase's own `.info/connected` reference in
/// SyncService, this gives a reliable online/offline signal.
class ConnectivityService extends ChangeNotifier {
  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool get isOnline => _isOnline;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
    final result = await Connectivity().checkConnectivity();
    _isOnline = !result.contains(ConnectivityResult.none);
    notifyListeners();

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final online = !results.contains(ConnectivityResult.none);
      if (online != _isOnline) {
        _isOnline = online;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
