import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Distance between two points in metres (haversine formula).
double distanceBetween(LatLng a, LatLng b) {
  const r = 6371000.0;
  final dLat = _rad(b.latitude - a.latitude);
  final dLng = _rad(b.longitude - a.longitude);
  final h = sin(dLat / 2) * sin(dLat / 2) +
      cos(_rad(a.latitude)) * cos(_rad(b.latitude)) * sin(dLng / 2) * sin(dLng / 2);
  return 2 * r * asin(sqrt(h));
}

double _rad(double deg) => deg * pi / 180;

String formatDistance(double metres) => metres < 1000
    ? '${metres.round()} م'
    : '${(metres / 1000).toStringAsFixed(1)} كم';
