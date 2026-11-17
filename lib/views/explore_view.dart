import 'package:flutter/material.dart';
import 'package:google_map/core/app_colors.dart';
import 'package:google_map/data/places_data.dart';
import 'package:google_map/helpers/geo.dart';
import 'package:google_map/helpers/marker_builder.dart';
import 'package:google_map/models/place_model.dart';
import 'package:google_map/services/location_service.dart';
import 'package:google_map/views/trip_tracker_view.dart';
import 'package:google_map/views/widgets/category_chips.dart';
import 'package:google_map/views/widgets/map_round_button.dart';
import 'package:google_map/views/widgets/place_card.dart';
import 'package:google_map/views/widgets/place_details_sheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  GoogleMapController? _map;
  final _pageController = PageController(viewportFraction: 0.86);
  final _locationService = LocationService();
  final _searchController = TextEditingController();

  PlaceCategory? _category;
  String _query = '';
  int _selected = 0;
  bool _dark = false;
  LatLng? _myLocation;
  Set<Marker> _markers = {};

  String? _lightStyle;
  String? _darkStyle;

  List<PlaceModel> get _visiblePlaces => places
      .where((p) => _category == null || p.category == _category)
      .where((p) => _query.isEmpty || p.name.contains(_query))
      .toList();

  @override
  void initState() {
    super.initState();
    _loadStyles();
    _buildMarkers();
    _loadMyLocation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _locationService.stop();
    super.dispose();
  }

  Future<void> _loadStyles() async {
    final bundle = DefaultAssetBundle.of(context);
    _lightStyle = await bundle
        .loadString('assets/google_maps_styles/google_map_light_style.json');
    _darkStyle = await bundle
        .loadString('assets/google_maps_styles/google_map_dark_style.json');
    _applyStyle();
  }

  void _applyStyle() => _map?.setMapStyle(_dark ? _darkStyle : _lightStyle);

  Future<void> _loadMyLocation() async {
    if (!await _locationService.ensureReady()) return;
    final data = await _locationService.current();
    if (!mounted || data.latitude == null) return;
    setState(() => _myLocation = LatLng(data.latitude!, data.longitude!));
  }

  Future<void> _buildMarkers() async {
    final visible = _visiblePlaces;
    final markers = <Marker>{};
    for (var i = 0; i < visible.length; i++) {
      final place = visible[i];
      final selected = i == _selected;
      markers.add(Marker(
        markerId: MarkerId('${place.id}'),
        position: place.location,
        zIndex: selected ? 2 : 1,
        icon: await MarkerBuilder.forCategory(place.category,
            selected: selected),
        infoWindow: InfoWindow(title: place.name),
        onTap: () => _select(i, fromMap: true),
      ));
    }
    if (mounted) setState(() => _markers = markers);
  }

  void _select(int index, {bool fromMap = false}) {
    final visible = _visiblePlaces;
    if (index >= visible.length) return;
    setState(() => _selected = index);
    _buildMarkers();
    _map?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: visible[index].location, zoom: 15.5, tilt: 35),
    ));
    if (fromMap && _pageController.hasClients) {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    }
  }

  void _onFilterChanged() {
    _selected = 0;
    _buildMarkers();
    if (_pageController.hasClients) _pageController.jumpToPage(0);
    final visible = _visiblePlaces;
    if (visible.isEmpty) return;
    if (visible.length == 1) {
      _select(0);
      return;
    }
    _map?.animateCamera(CameraUpdate.newLatLngBounds(
        _boundsOf(visible.map((e) => e.location).toList()), 70));
  }

  LatLngBounds _boundsOf(List<LatLng> points) {
    var south = points.first.latitude, north = south;
    var west = points.first.longitude, east = west;
    for (final p in points) {
      south = p.latitude < south ? p.latitude : south;
      north = p.latitude > north ? p.latitude : north;
      west = p.longitude < west ? p.longitude : west;
      east = p.longitude > east ? p.longitude : east;
    }
    return LatLngBounds(
        southwest: LatLng(south, west), northeast: LatLng(north, east));
  }

  Future<void> _goToMe() async {
    if (_myLocation == null) await _loadMyLocation();
    if (_myLocation == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('شغّل الـ GPS واسمح للتطبيق يوصل لموقعك')));
      return;
    }
    _map?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _myLocation!, zoom: 16)));
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visiblePlaces;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                const CameraPosition(target: kTantaCenter, zoom: 13.4),
            markers: _markers,
            circles: {
              Circle(
                circleId: const CircleId('service-area'),
                center: kTantaCenter,
                radius: 2600,
                strokeWidth: 2,
                strokeColor: AppColors.primary.withOpacity(0.5),
                fillColor: AppColors.primary.withOpacity(0.06),
              ),
            },
            myLocationEnabled: _myLocation != null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            padding: const EdgeInsets.only(bottom: 190, top: 120),
            onMapCreated: (controller) {
              _map = controller;
              _applyStyle();
              // Show all places once the map is ready.
              Future.delayed(const Duration(milliseconds: 400), () {
                _map?.animateCamera(CameraUpdate.newLatLngBounds(
                    _boundsOf(places.map((e) => e.location).toList()), 70));
              });
            },
          ),

          // Search + categories
          Positioned(
            top: top + 12,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _dark ? AppColors.nightSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                              color: _dark ? Colors.white : AppColors.ink),
                          decoration: InputDecoration(
                            hintText: 'دوّر على مكان في طنطا…',
                            hintStyle: TextStyle(
                                color: _dark
                                    ? Colors.white54
                                    : AppColors.muted.withOpacity(0.8)),
                            border: InputBorder.none,
                          ),
                          onChanged: (v) {
                            _query = v.trim();
                            _onFilterChanged();
                          },
                        ),
                      ),
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _query = '';
                            _onFilterChanged();
                          },
                          child: Icon(Icons.close_rounded,
                              color: _dark ? Colors.white70 : AppColors.muted),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CategoryChips(
                  selected: _category,
                  dark: _dark,
                  onSelected: (c) {
                    setState(() => _category = c);
                    _onFilterChanged();
                  },
                ),
              ],
            ),
          ),

          // Floating actions
          Positioned(
            right: 16,
            bottom: 210,
            child: Column(
              children: [
                MapRoundButton(
                  icon: _dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  dark: _dark,
                  tooltip: 'تغيير شكل الخريطة',
                  onTap: () {
                    setState(() => _dark = !_dark);
                    _applyStyle();
                  },
                ),
                const SizedBox(height: 10),
                MapRoundButton(
                  icon: Icons.my_location_rounded,
                  dark: _dark,
                  tooltip: 'موقعي',
                  onTap: _goToMe,
                ),
                const SizedBox(height: 10),
                MapRoundButton(
                  icon: Icons.route_rounded,
                  dark: _dark,
                  filled: true,
                  tooltip: 'تتبع رحلتي',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TripTrackerView(dark: _dark)),
                  ),
                ),
              ],
            ),
          ),

          // Places carousel
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            height: 170,
            child: visible.isEmpty
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: _dark ? AppColors.nightSurface : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text('مفيش أماكن مطابقة لبحثك',
                          style: TextStyle(
                              color: _dark ? Colors.white : AppColors.ink)),
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    itemCount: visible.length,
                    onPageChanged: _select,
                    itemBuilder: (_, i) {
                      final place = visible[i];
                      return PlaceCard(
                        place: place,
                        selected: i == _selected,
                        dark: _dark,
                        distance: _myLocation == null
                            ? null
                            : formatDistance(
                                distanceBetween(_myLocation!, place.location)),
                        onTap: () => showPlaceDetails(context, place,
                            myLocation: _myLocation),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

