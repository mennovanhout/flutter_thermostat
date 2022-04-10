import 'package:flutter/material.dart';
import 'package:thermostat/src/thermostat.dart' as src;

class Thermostat extends StatelessWidget {

  /// Current temperature to display in a middle.
  final double curVal;

  /// Value of temperature set point.
  final double setPoint;

  /// Minimal value for the set temperature slider.
  final double minVal;

  /// Max value for the set temperature slider.
  final double maxVal;

  /// Diameter of outer circle.
  final double size;

  /// Is called when user released
  final void Function(double newValue)? onChanged;

  final ThermostatThemeType themeType;

  /// Used to format [curValue] to display it on the screen.
  ///
  /// Default implementation is [_defaultNumFormatting].
  final String Function(double)? formatCurVal;

  /// Used to format [setPoint] to display it on the screen.
  ///
  /// Default implementation is [_defaultNumFormatting].
  final String Function(double)? formatSetPoint;

  final Color? glowColor;


  const Thermostat({
    required this.curVal,
    required this.setPoint,
    required this.minVal,
    required this.maxVal,
    this.onChanged,
    this.size = 300,
    this.themeType = ThermostatThemeType.light,
    this.formatCurVal,
    this.formatSetPoint,
    this.glowColor,
    Key? key,
  })  : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    final theme = _getThemeByType(themeType);

    return Center(
      child: src.Thermostat(
        radius: size / 2,
        turnOn: false,
        maxValue: maxVal,
        minValue: minVal,
        currentValue: curVal,
        initialSetPoint: setPoint,
        onValueChanged: _onValueChangedHandler,
        // modeIcon: Icon(
        //   Icons.ac_unit,
        //   color: theme.iconColor,
        // ),
        glowColor: glowColor ?? theme.glowColor,
        tickColor: theme.tickColor,
        thumbColor: theme.thumbColor,
        dividerColor: theme.dividerColor,
        turnOnColor: theme.turnOnColor,
        formatCurVal: formatCurVal ?? _defaultNumFormatting,
        formatSetPoint: formatSetPoint ?? _defaultNumFormatting,
      ),
    );
  }

  static _ThermostatTheme _getThemeByType(ThermostatThemeType type) {
    switch (type) {
      case ThermostatThemeType.light:
        return _ThermostatTheme.light();

      case ThermostatThemeType.dark:
        return _ThermostatTheme.dark();
    }
  }

  static String _defaultNumFormatting(double val) {
    return val.toStringAsFixed(1);
  }

  void _onValueChangedHandler(double value) {
    onChanged?.call(value);
  }
}

enum ThermostatThemeType {
  light,
  dark,
}


class _ThermostatTheme {
  final Color glowColor;
  final Color tickColor;
  final Color thumbColor;
  final Color dividerColor;
  final Color turnOnColor;
  final Color iconColor;

  _ThermostatTheme.dark({
    this.glowColor = const Color(0xFF3F5BFA),
    this.tickColor = const Color(0xFFD5D9F0),
    this.thumbColor = const Color(0xFFF3F4FA),
    this.dividerColor = const Color(0xFF3F5BFA),
    this.turnOnColor = const Color(0xFF66f475),
    this.iconColor = const Color(0xFF3CAEF4),
  });

  // base was #3C5B59
  //https://imagecolorpicker.com/color-code/3c5b59
  _ThermostatTheme.light({
    this.glowColor = const Color(0xFF637c7a),
    this.tickColor = const Color(0xFF637c7a),
    this.thumbColor = const Color(0xFF74b0ac),
    this.dividerColor = const Color(0xFF8a9d9b),
    this.turnOnColor = const Color(0xFF66f475),
    this.iconColor = const Color(0xFF74b0ac),
  });
}