import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng location;

  PlaceModel({required this.id, required this.name, required this.location});
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: 'ملاهي جوكي بارك',
    location: LatLng(30.811279116647235, 30.994027572500798),
  ),
  PlaceModel(
    id: 2,
    name: 'متحف أثار طنطا',
    location: LatLng(30.79834286390387, 31.004471245006943),
  ),
  PlaceModel(
    id: 3,
    name: 'شركه مصر للبترول',
    location: LatLng(30.793516505668073, 30.96485918966277),
  ),
];
