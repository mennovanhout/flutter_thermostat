import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:thermostat/src/thermostat.dart';

///
///
///
class TickThumbPainter extends CustomPainter {
  final Color tickColor;
  final Color thumbColor;
  final double scoop;
  final double angle;

  static const int tickCount = 180;

  TickThumbPainter({
    required this.tickColor,
    required this.thumbColor,
    required this.scoop,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width / 2.0;
    final double outerRingRadius = (size.width / 2.0) - 30.0;
    final Offset centerOffset = Offset(center, center);
    final double innerRingRadius =
        outerRingRadius - 32.0 + 15.0; //15 is thumb radius

    final double dx = innerRingRadius * cos(angle) + center;
    final double dy = innerRingRadius * sin(angle) + center;

    final tickPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = tickColor.withOpacity(0.3)
      ..strokeWidth = 1.5;

    canvas.save();
    canvas.translate(center, center);

    const radians = toRadians / tickCount;
    double tRadians = 0.0;
    final curve = Curves.easeOut;
    for (int i = 0; i < tickCount; i++) {
      double lomber = 0.0;
      final diff = acos(cos(angle - tRadians));
      if (diff <= 0.3) {
        lomber =
            curve.transform((1 - (diff / 0.3))) * (15.0 * scoop); // working
      }

      canvas.drawLine(
        Offset(outerRingRadius + 0.5, 0.0),
        Offset(outerRingRadius + 15.0 + lomber, 0.0),
        tickPaint,
      );

      tRadians += radians;
      canvas.rotate(radians);
    }
    canvas.restore();

    final thumbPaint = Paint()
      ..color = thumbColor.withOpacity(0.7 + (0.3 * scoop));

    canvas.drawCircle(Offset(dx, dy), 14.0, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}