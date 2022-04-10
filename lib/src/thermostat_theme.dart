import 'dart:ui';

class ThermostatTheme {
  final Color glowColor;
  final Color tickColor;
  final Color thumbColor;
  final Color dividerColor;
  final Color turnOnColor;
  final Color iconColor;

  ThermostatTheme.dark({
    this.glowColor = const Color(0xFF3F5BFA),
    this.tickColor = const Color(0xFFD5D9F0),
    this.thumbColor = const Color(0xFFF3F4FA),
    this.dividerColor = const Color(0xFF3F5BFA),
    this.turnOnColor = const Color(0xFF66f475),
    this.iconColor = const Color(0xFF3CAEF4),
  });

  // base was #3C5B59
  //https://imagecolorpicker.com/color-code/3c5b59
  ThermostatTheme.light({
    this.glowColor = const Color(0xFF637c7a),
    this.tickColor = const Color(0xFF637c7a),
    this.thumbColor = const Color(0xFF74b0ac),
    this.dividerColor = const Color(0xFF8a9d9b),
    this.turnOnColor = const Color(0xFF66f475),
    this.iconColor = const Color(0xFF74b0ac),
  });

  ThermostatTheme._({
    required this.glowColor,
    required this.tickColor,
    required this.thumbColor,
    required this.dividerColor,
    required this.turnOnColor,
    required this.iconColor
  });


  ThermostatTheme copyWith({
    Color? glowColor,
    Color? tickColor,
    Color? thumbColor,
    Color? dividerColor,
    Color? turnOnColor,
    Color? iconColor,
  }) {
    return ThermostatTheme._(
      glowColor: glowColor ?? this.glowColor,
      tickColor: tickColor ?? this.tickColor,
      thumbColor: thumbColor ?? this.thumbColor,
      dividerColor: dividerColor ?? this.dividerColor,
      turnOnColor: turnOnColor ?? this.turnOnColor,
      iconColor: iconColor ?? this.iconColor,
    );
  }
}