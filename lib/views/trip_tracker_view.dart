import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map/core/app_colors.dart';
import 'package:google_map/data/places_data.dart';
import 'package:google_map/helpers/geo.dart';
import 'package:google_map/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/// Live trip tracking: follows the user's location, draws the path and
/// shows distance, time and average speed.
class TripTrackerView extends StatefulWidget {
  const TripTrackerView({super.key, this.dark = false});
  final bool dark;

  @override
  State<TripTrackerView> createState() => _TripTrackerViewState();
}

class _TripTrackerViewState extends State<TripTrackerView> {
  final _locationService = LocationService();
  GoogleMapController? _map;
  final List<LatLng> _path = [];
  LatLng? _current;
  bool _tracking = false;
  double _distance = 0;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  String? _style;

  @override
  void initState() {
    super.initState();
    _loadStyle();
    _showMyLocation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _locationService.stop();
    super.dispose();
  }

  Future<void> _loadStyle() async {
    _style = await DefaultAssetBundle.of(context).loadString(widget.dark
        ? 'assets/google_maps_styles/google_map_dark_style.json'
        : 'assets/google_maps_styles/google_map_light_style.json');
    _map?.setMapStyle(_style);
  }

  Future<void> _showMyLocation() async {
    if (!await _locationService.ensureReady()) return;
    final data = await _locationService.current();
    if (data.latitude == null || !mounted) return;
    setState(() => _current = LatLng(data.latitude!, data.longitude!));
    _map?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _current!, zoom: 17)));
  }

  Future<void> _start() async {
    if (!await _locationService.ensureReady()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('محتاجين إذن الموقع علشان نتتبع رحلتك')));
      return;
    }
    setState(() {
      _tracking = true;
      _path.clear();
      _distance = 0;
      _elapsed = Duration.zero;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
    _locationService.listen(_onLocation, distanceFilter: 5);
  }

  void _stop() {
    _timer?.cancel();
    _locationService.stop();
    setState(() => _tracking = false);
    if (_path.length > 1) {
      _map?.animateCamera(CameraUpdate.newLatLngBounds(_bounds(), 80));
    }
  }

  void _onLocation(LocationData data) {
    if (data.latitude == null) return;
    final point = LatLng(data.latitude!, data.longitude!);
    setState(() {
      if (_path.isNotEmpty) _distance += distanceBetween(_path.last, point);
      _path.add(point);
      _current = point;
    });
    _map?.animateCamera(CameraUpdate.newLatLng(point));
  }

  LatLngBounds _bounds() {
    var s = _path.first.latitude, n = s, w = _path.first.longitude, e = w;
    for (final p in _path) {
      if (p.latitude < s) s = p.latitude;
      if (p.latitude > n) n = p.latitude;
      if (p.longitude < w) w = p.longitude;
      if (p.longitude > e) e = p.longitude;
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }

  String get _time {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(_elapsed.inMinutes)}:${two(_elapsed.inSeconds % 60)}';
  }

  String get _speed {
    if (_elapsed.inSeconds == 0) return '0';
    return (_distance / _elapsed.inSeconds * 3.6).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final dark = widget.dark;
    final card = dark ? AppColors.nightSurface : Colors.white;
    final fg = dark ? Colors.white : AppColors.ink;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _current ?? kTantaCenter, zoom: 15),
            myLocationEnabled: _current != null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            padding: const EdgeInsets.only(bottom: 230, top: 90),
            polylines: {
              if (_path.length > 1) ...{
                Polyline(
                  polylineId: const PolylineId('trail-glow'),
                  points: _path,
                  width: 12,
                  color: AppColors.primary.withOpacity(0.25),
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                ),
                Polyline(
                  polylineId: const PolylineId('trail'),
                  points: _path,
                  width: 6,
                  color: AppColors.primary,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                ),
              },
            },
            markers: {
              if (_path.isNotEmpty)
                Marker(
                  markerId: const MarkerId('start'),
                  position: _path.first,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                  infoWindow: const InfoWindow(title: 'نقطة البداية'),
                ),
            },
            onMapCreated: (c) {
              _map = c;
              if (_style != null) c.setMapStyle(_style);
            },
          ),
          Positioned(
            top: top + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Material(
                  color: card,
                  shape: const CircleBorder(),
                  elevation: 6,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: fg),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 12)
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _tracking ? Colors.redAccent : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(_tracking ? 'جاري تتبع رحلتك' : 'تتبع رحلتي',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, color: fg)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 24,
                      offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _Stat(
                          label: 'المسافة',
                          value: (_distance / 1000).toStringAsFixed(2),
                          unit: 'كم',
                          fg: fg),
                      _Stat(label: 'الوقت', value: _time, unit: 'دقيقة', fg: fg),
                      _Stat(
                          label: 'متوسط السرعة',
                          value: _speed,
                          unit: 'كم/س',
                          fg: fg),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            _tracking ? Colors.redAccent : AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _tracking ? _stop : _start,
                      icon: Icon(_tracking
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded),
                      label: Text(_tracking ? 'إنهاء الرحلة' : 'ابدأ الرحلة',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(
      {required this.label,
      required this.value,
      required this.unit,
      required this.fg});
  final String label;
  final String value;
  final String unit;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: fg)),
          Text(unit,
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
        ],
      ),
    );
  }
}
