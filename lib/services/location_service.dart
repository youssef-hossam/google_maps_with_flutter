import 'dart:async';

import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  StreamSubscription<LocationData>? _subscription;

  /// Makes sure GPS is on and the app has permission. Returns false if not.
  Future<bool> ensureReady() async {
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }
    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.deniedForever) return false;
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }
    return permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited;
  }

  Future<LocationData> current() => _location.getLocation();

  /// Streams the user's location; [distanceFilter] is in metres.
  void listen(void Function(LocationData) onData, {double distanceFilter = 5}) {
    _location.changeSettings(distanceFilter: distanceFilter);
    _subscription?.cancel();
    _subscription = _location.onLocationChanged.listen(onData);
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}
