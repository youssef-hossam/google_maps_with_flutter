import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_map/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Draws a pin with the category icon, so we don't need image assets.
class MarkerBuilder {
  static final Map<String, BitmapDescriptor> _cache = {};

  static Future<BitmapDescriptor> forCategory(PlaceCategory category,
      {bool selected = false}) async {
    final key = '${category.name}-$selected';
    if (_cache.containsKey(key)) return _cache[key]!;

    final size = selected ? 150.0 : 112.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2.6);
    final radius = size / 2.9;

    // Shadow + pin tail
    final tail = Path()
      ..moveTo(center.dx - radius * 0.55, center.dy + radius * 0.7)
      ..lineTo(center.dx, size * 0.95)
      ..lineTo(center.dx + radius * 0.55, center.dy + radius * 0.7)
      ..close();
    canvas.drawShadow(tail, Colors.black, 6, false);
    canvas.drawPath(tail, Paint()..color = category.color);
    canvas.drawCircle(center.translate(0, 3), radius,
        Paint()..color = Colors.black.withOpacity(0.18));
    canvas.drawCircle(center, radius, Paint()..color = category.color);
    canvas.drawCircle(center, radius * 0.78, Paint()..color = Colors.white);

    final icon = category.icon;
    final painter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: radius * 1.05,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: category.color,
        ),
      )
      ..layout();
    painter.paint(canvas,
        center - Offset(painter.width / 2, painter.height / 2));

    final image =
        await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final descriptor = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
    _cache[key] = descriptor;
    return descriptor;
  }
}
