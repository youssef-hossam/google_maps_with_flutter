import 'package:flutter/material.dart';
import 'package:google_map/core/app_colors.dart';

class MapRoundButton extends StatelessWidget {
  const MapRoundButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.dark = false,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool dark;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final bg = filled
        ? AppColors.primary
        : (dark ? AppColors.nightSurface : Colors.white);
    final fg = filled ? Colors.white : (dark ? Colors.white : AppColors.ink);
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        elevation: 6,
        shadowColor: Colors.black38,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(icon, color: fg),
          ),
        ),
      ),
    );
  }
}
