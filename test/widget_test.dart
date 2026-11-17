import 'package:flutter_test/flutter_test.dart';
import 'package:google_map/helpers/geo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  test('distanceBetween returns ~1.11 km for 0.01° of latitude', () {
    final d = distanceBetween(const LatLng(30.0, 31.0), const LatLng(30.01, 31.0));
    expect(d, closeTo(1112, 5));
  });

  test('formatDistance switches from metres to km', () {
    expect(formatDistance(850), '850 م');
    expect(formatDistance(1530), '1.5 كم');
  });
}
