import 'package:flutter/material.dart';
import 'package:google_map/core/app_colors.dart';
import 'package:google_map/models/place_model.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.selected,
    required this.onSelected,
    this.dark = false,
  });

  final PlaceCategory? selected;
  final ValueChanged<PlaceCategory?> onSelected;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final items = <(PlaceCategory?, String, IconData, Color)>[
      (null, 'الكل', Icons.apps_rounded, AppColors.primary),
      for (final c in PlaceCategory.values) (c, c.label, c.icon, c.color),
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (category, label, icon, color) = items[i];
          final isSelected = category == selected;
          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? color
                    : (dark ? AppColors.nightSurface : Colors.white),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon,
                      size: 18, color: isSelected ? Colors.white : color),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : (dark ? Colors.white : AppColors.ink),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
