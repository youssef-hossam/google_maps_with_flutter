import 'package:flutter/material.dart';
import 'package:google_map/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationTracker extends StatefulWidget {
  const LocationTracker({super.key});

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  late LocationService locationService;
  bool isFirstCall = true;
  @override
  void initState() {
    locationService = LocationService();
    updateMyLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
        zoomControlsEnabled: false,
        initialCameraPosition: const CameraPosition(
            target: LatLng(30.79587928134086, 30.955621671573123), zoom: 13),
      ),
    );
  }

  void updateMyLocation() async {
    await locationService.checkAndRequestLocationService();
    bool isPermssionGranted = await locationService.checkAndRequestPermssion();
    if (isPermssionGranted) {
      locationService.getRealTimeLocation((locationData) {
        locationService.changeDistancesetting(10);
        setMyMarkers(locationData);
        setMyCameraPostion(locationData);
      });
    }
  }

  void setMyCameraPostion(LocationData locationData) {
    if (isFirstCall) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(locationData.latitude!, locationData.longitude!),
              zoom: 17)));
      isFirstCall = false;
    } else {
      mapController?.animateCamera(CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!)));
    }
  }

  void setMyMarkers(LocationData locationData) {
    Marker myLocationMarker = Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
    );
    markers.add(myLocationMarker);
    setState(() {});
  }
}
