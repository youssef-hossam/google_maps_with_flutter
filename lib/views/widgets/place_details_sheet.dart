import 'package:flutter/material.dart';
import 'package:google_map/core/app_colors.dart';
import 'package:google_map/helpers/geo.dart';
import 'package:google_map/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showPlaceDetails(BuildContext context, PlaceModel place,
    {LatLng? myLocation}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _PlaceDetailsSheet(place: place, myLocation: myLocation),
  );
}

class _PlaceDetailsSheet extends StatelessWidget {
  const _PlaceDetailsSheet({required this.place, this.myLocation});
  final PlaceModel place;
  final LatLng? myLocation;

  Future<void> _openDirections() async {
    final lat = place.location.latitude, lng = place.location.longitude;
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final distance = myLocation == null
        ? null
        : distanceBetween(myLocation!, place.location);
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 20 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: place.category.color.withOpacity(0.12),
                child: Icon(place.category.icon,
                    color: place.category.color, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name,
                        style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 18, color: Color(0xFFFFB020)),
                        Text(' ${place.rating}  •  ${place.category.label}',
                            style: const TextStyle(color: AppColors.muted)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(place.description,
              style: const TextStyle(
                  fontSize: 14.5, height: 1.6, color: AppColors.ink)),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.location_on_outlined, text: place.address),
          if (distance != null)
            _InfoRow(
                icon: Icons.near_me_outlined,
                text: 'على بعد ${formatDistance(distance)} منك'),
          _InfoRow(
            icon: Icons.gps_fixed_rounded,
            text:
                '${place.location.latitude.toStringAsFixed(5)}, ${place.location.longitude.toStringAsFixed(5)}',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _openDirections,
              icon: const Icon(Icons.directions_rounded),
              label: const Text('الاتجاهات',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text, style: const TextStyle(color: AppColors.muted))),
        ],
      ),
    );
  }
}
