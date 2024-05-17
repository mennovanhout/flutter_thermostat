import 'dart:ui';

class ThermostatTheme {
  /// Color of drop shadow under slider circle.
  final Color glowColor;

  /// Ticks around slider circle.
  final Color tickColor;

  /// Slider head user drag to change value.
  final Color thumbColor;

  /// Little divider line in a top of the slider circle.
  final Color dividerColor;

  /// Color of the main ring.
  ///
  /// If null it will not be painted.
  final Color? ringColor;

  /// Little led.
  final Color turnOnColor;

  /// There is no icon so far.
  // final Color iconColor;

  ThermostatTheme.dark({
    this.glowColor = const Color(0xFF3F5BFA),
    this.tickColor = const Color(0xFFD5D9F0),
    this.thumbColor = const Color(0xFFF3F4FA),
    this.dividerColor = const Color(0xFF3F5BFA),
    this.ringColor,
    this.turnOnColor = const Color(0xFF66f475),
    // this.iconColor = const Color(0xFF3CAEF4),
  });

  // base was #3C5B59
  //https://imagecolorpicker.com/color-code/3c5b59
  ThermostatTheme.light({
    this.glowColor = const Color(0xFF637c7a),
    this.tickColor = const Color(0xFF637c7a), 
    this.thumbColor = const Color(0xFF74b0ac),
    this.dividerColor = const Color(0xFF8a9d9b),
    this.ringColor,
    this.turnOnColor = const Color(0xFF66f475),
    // this.iconColor = const Color(0xFF74b0ac),
  });

  ThermostatTheme._({
    required this.glowColor,
    required this.tickColor,
    required this.thumbColor,
    required this.dividerColor,
    this.ringColor,
    required this.turnOnColor,
    // required this.iconColor
  });


  ThermostatTheme copyWith({
    Color? glowColor,
    Color? tickColor,
    Color? thumbColor,
    Color? dividerColor,
    Color? turnOnColor,
    Color? iconColor,
    Color? ringColor,
    bool removeRingColor = false,
  }) {
    return ThermostatTheme._(
      glowColor: glowColor ?? this.glowColor,
      tickColor: tickColor ?? this.tickColor,
      thumbColor: thumbColor ?? this.thumbColor,
      dividerColor: dividerColor ?? this.dividerColor,
      ringColor: !removeRingColor ? ringColor ?? this.ringColor : null,
      turnOnColor: turnOnColor ?? this.turnOnColor,
      // iconColor: iconColor ?? this.iconColor,
    );
  }
}