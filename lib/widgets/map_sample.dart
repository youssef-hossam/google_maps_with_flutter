import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        target: LatLng(30.78632846612454, 30.999528414111044), zoom: 13);
    initMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          markers: markers,
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
                southwest: LatLng(30.57453740183841, 30.71606382514833),
                northeast: LatLng(30.96953570951455, 31.166773656135007)),
          ),
          onMapCreated: (controller) {
            mapController = controller;
            initMapStyle();
          },
          initialCameraPosition: initialCameraPosition,
        ),
        Positioned(
            bottom: 12,
            right: 12,
            left: 12,
            child: ElevatedButton(
                onPressed: () {
                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target:
                              LatLng(30.798860738915106, 30.957435117150393),
                          zoom: 17)));
                },
                child: const Text('change camera')))
      ]),
    );
  }

  initMapStyle() async {
    var darkMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/google_maps_styles/google_map_dark_style.json');

    mapController.setMapStyle(darkMapStyle);
  }

  void initMarkers() {
    Marker myMmarker = const Marker(
        markerId: MarkerId('1'),
        position: LatLng(30.78632846612454, 30.999528414111044));
    markers.add(myMmarker);
  }
}



//world view 0 -> 3
//country view 4 -> 6
// city view 10-> 12
//street view 13 -> 17
//building view 18 -> 20

