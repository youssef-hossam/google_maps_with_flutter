import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum PlaceCategory {
  landmark('معالم', Icons.account_balance_rounded, Color(0xFF7C3AED)),
  fun('ترفيه', Icons.attractions_rounded, Color(0xFFFF7A45)),
  education('تعليم', Icons.school_rounded, Color(0xFF2563EB)),
  services('خدمات', Icons.local_gas_station_rounded, Color(0xFF0F766E));

  const PlaceCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class PlaceModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final PlaceCategory category;
  final double rating;
  final LatLng location;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.category,
    required this.rating,
    required this.location,
  });
}
