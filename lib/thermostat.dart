import 'package:flutter/material.dart';
import 'package:thermostat/src/thermostat.dart' as src;
import 'package:thermostat/src/thermostat_theme.dart';

export 'package:thermostat/src/thermostat_theme.dart';

class Thermostat extends StatelessWidget {

  /// Stores the availability of temperature set point.
  final src.SetPointMode mode;

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

  final ThermostatTheme? theme;

  final bool turnOn;

  const Thermostat({
    required this.mode,
    required this.curVal,
    required this.setPoint,
    required this.minVal,
    required this.maxVal,
    this.onChanged,
    this.size = 300,
    this.themeType = ThermostatThemeType.light,
    this.formatCurVal,
    this.formatSetPoint,
    this.theme,
    this.turnOn = false,
    Key? key,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? _getThemeByType(themeType);

    return
      Center(
      child: src.Thermostat(
        mode: mode,
        radius: size / 2,
        turnOn: turnOn,
        maxValue: maxVal,
        minValue: minVal,
        currentValue: curVal,
        initialSetPoint: setPoint,
        onValueChanged: _onValueChangedHandler,
        glowColor: theme.glowColor,
        tickColor: theme.tickColor,
        thumbColor: theme.thumbColor,
        dividerColor: theme.dividerColor,
        ringColor: theme.ringColor,
        turnOnColor: theme.turnOnColor,
        formatCurVal: formatCurVal ?? _defaultNumFormatting,
        formatSetPoint: formatSetPoint ?? _defaultNumFormatting,
      ),
    );
  }

  static ThermostatTheme _getThemeByType(ThermostatThemeType type) {
    switch (type) {
      case ThermostatThemeType.light:
        return ThermostatTheme.light();

      case ThermostatThemeType.dark:
        return ThermostatTheme.dark();
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