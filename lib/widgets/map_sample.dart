import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        target: LatLng(30.795802111307264, 30.95593279850624), zoom: 13);
    initMarkers();
    initPolyLines();
    initPolygens();
    initCircle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          circles: circles,
          polygons: polygons,
          polylines: polylines,
          zoomControlsEnabled: false,
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
                      const CameraPosition(
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

  void initMarkers() async {
    var markerIcon =
        await getImageFromRowData('assets/images/marker_map_icon.png', 100);
    Set<Marker> placesMarkers = places
        .map(
          (place) => Marker(
            icon: BitmapDescriptor.fromBytes(markerIcon),
            markerId: MarkerId(place.id.toString()),
            position: place.location,
            infoWindow: InfoWindow(
              title: place.name,
            ),
          ),
        )
        .toSet();
    markers.addAll(placesMarkers);
    setState(() {});
  }

  Future<Uint8List> getImageFromRowData(String image, double width) async {
    var imageData = await rootBundle.load(image);
    ui.Codec codec = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
        targetWidth: width.toInt());
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void initPolyLines() {
    Polyline polyline = const Polyline(
        polylineId: PolylineId('1'),
        color: Colors.red,
        zIndex: 2,
        width: 3,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: [
          LatLng(30.79620760689345, 30.956163925002713),
          LatLng(30.814681126114415, 30.95703002120541),
          LatLng(30.798563488185742, 30.93537760692896),
          LatLng(30.819132859692424, 30.992654811536887)
        ]);
    polylines.add(polyline);
    Polyline polyline2 = const Polyline(
        polylineId: PolylineId('1'),
        zIndex: 1,
        color: Colors.black,
        width: 3,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: [
          LatLng(30.804390479716215, 30.97509064055643),
          LatLng(30.812936873980878, 30.919773696583793),
        ]);
    polylines.add(polyline2);
  }

  void initPolygens() {
    Polygon polygon = Polygon(
        holes: const [
          [
            LatLng(30.80888340088103, 30.956101502049975),
            LatLng(30.803227486182394, 30.954220066826256),
            LatLng(30.80943072979718, 30.94593568269599),
            // hole inside of the polygon

            // LatLng(30.874579088526673, 30.932835292941157),
            // LatLng(30.848678329132632, 30.933241377876772),
            // LatLng(30.86497612419305, 30.891188348219586)
            // hole outside of the polygon
          ]
        ],
        polygonId: PolygonId('1'),
        fillColor: Colors.black.withOpacity(0.5),
        strokeWidth: 2,
        points: const [
          LatLng(30.806763571631034, 30.984521860426444),
          LatLng(30.795991225115504, 30.95605939176251),
          LatLng(30.812936873980878, 30.926683066622864)
        ]);
    polygons.add(polygon);
  }

  void initCircle() {
    Circle circle = Circle(
        circleId: CircleId("1"),
        center: LatLng(30.795802111307264, 30.95593279850624),
        radius: 1000,
        strokeWidth: 3,
        fillColor: Colors.black.withOpacity(00.5));
    circles.add(circle);
  }
//world view 0 -> 3
//country view 4 -> 6
// city view 10-> 12
//street view 13 -> 17
//building view 18 -> 20
}
