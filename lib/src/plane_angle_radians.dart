import 'dart:math' as math;

class PlaneAngle {
  /// Zero.
  static const PlaneAngle zero = PlaneAngle._(0.0);

  /// Half-turn (aka &pi; radians).
  static const PlaneAngle pi = PlaneAngle._(0.5);

  /// Conversion factor.
  static const double halfTurn = 0.5;

  /// Conversion factor.
  static const double toRadians = 2.0 * math.pi;

  /// Conversion factor.
  static const double fromRadians = 1.0 / toRadians;

  /// Conversion factor.
  static const double toDegrees = 360.0;

  /// Conversion factor.
  static const double fromDegress = 1.0 / toDegrees;

  /// Value (in turns).
  final double _value;

  const PlaneAngle._(double value) : _value = value;

  const PlaneAngle.ofTurns(double angle) : _value = angle;

  const PlaneAngle.ofRadians(double angle) : _value = angle * fromRadians;

  const PlaneAngle.ofDegrees(double angle) : _value = angle * fromDegress;

  double get turns => _value;

  double get radians => _value * toRadians;

  double get degrees => _value * toDegrees;

  PlaneAngle normalize(PlaneAngle center) {
    return PlaneAngle._(
        _value - (_value + halfTurn - center._value).floor());
  }
}

double normalize(double angle, double center) {
  final PlaneAngle a = PlaneAngle.ofRadians(angle);
  final PlaneAngle c = PlaneAngle.ofRadians(center);
  return a.normalize(c).radians;
}

double normalizeBetweenMinusPiAndPi(double angle) {
  return PlaneAngle.ofRadians(angle).normalize(PlaneAngle.zero).radians;
}

double normalizeBetweenZeroAndTwoPi(double angle) {
  return PlaneAngle.ofRadians(angle).normalize(PlaneAngle.pi).radians;
}