import 'package:flutter/widgets.dart';
import 'package:thermostat/src/thermostat.dart';

///
///
///
class RingPainter extends CustomPainter {
  final Color dividerColor;
  final Color glowColor;
  final Color? ringColor;
  final double glowness;

  RingPainter({
    required this.dividerColor,
    required this.glowColor,
    required this.ringColor,
    required this.glowness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    final double center = size.width / 2.0;
    final Offset centerOffset = Offset(center, center);
    final double outerRingRadius = (size.width / 2.0) - 30.0;
    final double innerRingRadius = outerRingRadius - 32.0;

    final dividerGlowPaint = Paint()
      ..color = dividerColor
      ..maskFilter = MaskFilter.blur(
        BlurStyle.outer,
        convertRadiusToSigma(4.0),
      );

    final dividerPaint = Paint()..color = dividerColor;

    final outerGlowPaint = Paint()
      ..color = glowColor
      ..maskFilter = MaskFilter.blur(
        BlurStyle.outer,
        convertRadiusToSigma(18.0 + (5.0 * glowness)),
      );

    final gradient = RadialGradient(
      colors: <Color>[
        glowColor.withOpacity(0.0),
        glowColor.withOpacity(0.5),
      ],
      stops: [
        0.8 - (0.13 * glowness),
        1.0,
      ],
    );

    final Rect gradientRect =
    Rect.fromCircle(center: centerOffset, radius: innerRingRadius);

    final Paint paint = Paint()
      ..shader = gradient.createShader(gradientRect);

    canvas.saveLayer(rect, Paint());
    canvas.drawCircle(centerOffset, outerRingRadius, outerGlowPaint);
    canvas.drawCircle(centerOffset, innerRingRadius, paint);

    // Drawing main ring (or not drawing, it will be transparent).
    if (ringColor != null) {
      final double centerRadius = (outerRingRadius + innerRingRadius) * 0.5;
      final mainRingWidth = outerRingRadius - innerRingRadius;

      final bigRingPainter = Paint()
        ..color = ringColor!
        ..strokeWidth = mainRingWidth
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(centerOffset, centerRadius, bigRingPainter);
    }

    //
    canvas.translate(center, center);
    final dividerRect = Rect.fromLTWH(
        -2.0, -outerRingRadius, 4.0, outerRingRadius - innerRingRadius);
    canvas.drawRect(dividerRect, dividerPaint);
    canvas.drawRect(dividerRect, dividerGlowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(RingPainter oldDelegate) {
    return oldDelegate.glowColor != glowColor ||
        oldDelegate.glowness != glowness ||
        oldDelegate.dividerColor != dividerColor;
  }
}