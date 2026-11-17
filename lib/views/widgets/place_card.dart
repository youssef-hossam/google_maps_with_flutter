import 'package:flutter/material.dart';
import 'package:google_map/core/app_colors.dart';
import 'package:google_map/models/place_model.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    super.key,
    required this.place,
    required this.selected,
    required this.onTap,
    this.distance,
    this.dark = false,
  });

  final PlaceModel place;
  final bool selected;
  final VoidCallback onTap;
  final String? distance;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppColors.ink;
    final sub = dark ? Colors.white60 : AppColors.muted;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: selected ? 0 : 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: dark ? AppColors.nightSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 74,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      place.category.color,
                      place.category.color.withOpacity(0.65),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(place.category.icon, color: Colors.white, size: 34),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(place.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: fg)),
                    const SizedBox(height: 4),
                    Text(place.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.5, color: sub)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 18, color: Color(0xFFFFB020)),
                        const SizedBox(width: 2),
                        Text('${place.rating}',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, color: fg)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: place.category.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(place.category.label,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: place.category.color)),
                        ),
                        const Spacer(),
                        if (distance != null) ...[
                          Icon(Icons.near_me_rounded, size: 15, color: sub),
                          const SizedBox(width: 3),
                          Text(distance!,
                              style: TextStyle(fontSize: 12.5, color: sub)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
