import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thermostat/src/thermostat_gesture_detector.dart';
import 'package:thermostat/src/plane_angle_radians.dart';
import 'package:thermostat/src/ring_painter.dart';
import 'package:thermostat/src/tick_thumb_painter.dart';


const double toRadians = 2.0 * pi;

double convertRadiusToSigma(double radius) {
  return radius * 0.57735 + 0.5;
}


/// Widget to display current temperature and control temperature set point.
///
/// Current value is current temperature. Set point is value where current
/// temperature should be.
class Thermostat extends StatefulWidget {
  final SetPointMode mode;
  final Color glowColor;
  final Color tickColor;
  final Color thumbColor;
  final Color dividerColor;
  final Color turnOnColor;
  final bool turnOn;
  final Color? ringColor;

  /// Icon will be placed in 32x32 box.
  final Widget? modeIcon;

  /// Min value for set point.
  final double minValue;

  /// Max val for set point.
  final double maxValue;

  /// Current temperature value.
  final double currentValue;

  /// Initial set point value.
  ///
  /// That will second row with number. And slider will have position
  /// accordingly to that value until the user starts drag it.
  final double initialSetPoint;

  /// When set point was changed.
  ///
  /// It happens after user released slider.
  final ValueChanged<double>? onValueChanged;

  final TextStyle? textStyle;

  final double radius;

  /// Used to format [curValue].
  final String Function(double val) formatCurVal;

  /// Used to format set point value.
  final String Function(double val) formatSetPoint;


  const Thermostat({
    Key? key,
    required this.mode,
    required this.turnOn,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.initialSetPoint,
    required this.radius,
    required this.formatCurVal,
    required this.formatSetPoint,
    this.modeIcon,
    this.glowColor = const Color(0xFF3F5BFA),
    this.tickColor = const Color(0xFFD5D9F0),
    this.thumbColor = const Color(0xFFF3F4FA),
    this.dividerColor = const Color(0xFF3F5BFA),
    this.turnOnColor = const Color(0xFF66f475),
    this.onValueChanged,
    this.textStyle,
    this.ringColor,
  }) : super(key: key);

  @override
  _ThermostatState createState() => _ThermostatState();
}


class _ThermostatState extends State<Thermostat> with SingleTickerProviderStateMixin {
  static const double minRingRad = 4.538;
  static const double midRingRad = 4.7123889803847;
  static const double maxRingRad = 4.895;
  static const double deg90ToRad = 1.5708;

  late final AnimationController _glowController;

  late double _angle;

  late double _value;

  bool _drawing = false;

  @override
  void initState() {
    _value = widget.initialSetPoint;

    _angle = _calcInitialAngle(
      minValue: widget.minValue,
      value: widget.initialSetPoint,
      maxValue: widget.maxValue,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _glowController.addListener(_handleChange);

    super.initState();
  }


  @override
  void didUpdateWidget(Thermostat oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_drawing == false) {
      _value = widget.initialSetPoint;

      _angle = _calcInitialAngle(
        minValue: widget.minValue,
        value: widget.initialSetPoint,
        maxValue: widget.maxValue,
      );
    }
  }

  @override
  void dispose() {
    _glowController.removeListener(_handleChange);
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.radius * 2.0;
    final double halfWidth = widget.radius;
    final size = Size(width, width);

    return SizedBox(
      width: width,
      height: width,
      child: RawGestureDetector(
        gestures: {
          ThermostatGestureDetector: GestureRecognizerFactoryWithHandlers<ThermostatGestureDetector>(
            () => ThermostatGestureDetector(
              hitTest: _sliderHitTest,
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
            ),
            (_) {}, // initializer
          ),
        },
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            if (widget.modeIcon != null) Positioned(
              top: halfWidth - 16.0,
              left: halfWidth - 62.0,
              width: 32.0,
              height: 32.0,
              child: widget.modeIcon!,
            ),

            if (widget.turnOn) Positioned(
              top: halfWidth - 4.0,
              right: halfWidth - 60.0,
              child: _buildLed(),
            ),

            Center(
              child: _buildTextWidgets(context),
            ),

            _buildRing(size),

            if (widget.mode != SetPointMode.unwritable) _buildTickThumb(size),
          ],
        ),
      ),
    );
  }

  CustomPaint _buildTickThumb(Size size) {
    return CustomPaint(
      size: size,
      painter: TickThumbPainter(
        tickColor: widget.tickColor,
        thumbColor: widget.thumbColor,
        scoop: _glowController.value,
        angle: _angle,
      ),
    );
  }

  CustomPaint _buildRing(Size size) {
    return CustomPaint(
      size: size,
      painter: RingPainter(
        dividerColor: widget.dividerColor,
        glowColor: widget.glowColor,
        glowness: _glowController.value,
        ringColor: widget.ringColor,
      ),
    );
  }

  /// Led is little green (by default) light that reflects is thermostat
  /// working right now.
  Container _buildLed() {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: widget.turnOnColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.turnOnColor,
            blurRadius: 4.0,
            offset: const Offset(0.0, 3.0),
          )
        ],
      ),
    );
  }

  Widget _buildTextWidgets(BuildContext context) {
    final curValStyle = widget.textStyle ?? Theme.of(context).textTheme.headline4;

    final spStyle = curValStyle!.copyWith(
      fontSize: curValStyle.fontSize! * 0.65,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.formatCurVal(widget.currentValue),
          style: curValStyle,
        ),
        const SizedBox(height: 3,),
        if (widget.mode != SetPointMode.error)
        Text(
          widget.formatSetPoint(_value),
          style: spStyle,
        ),
      ],
    );
  }

  ///
  void _handleChange() {
    setState(() {
        // The listenable's state is our build state, and it changed already.
    });
  }

  /// Is circle slider is touched by user?
  ///
  /// We choose gesture strategy depends on that.
  bool _sliderHitTest(DragStartDetails details) {
    final polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);

    return polarCoord.radius >= (widget.radius - 62 - 15) && polarCoord.radius <= (widget.radius - 15);
  }

  void _onPanStart(DragStartDetails details) {
    // final polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
    _drawing = true;
    _glowRing();
  }

  ///
  void _onPanUpdate(DragUpdateDetails details) {
    final polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
    final angle = normalizeBetweenZeroAndTwoPi(polarCoord.angle);
    final double clampedAngle = _clampAngleValue(angle);

    if (clampedAngle != _angle) {
      setState(() {
        _angle = clampedAngle;
        final normalizedValue =
        (normalizeBetweenZeroAndTwoPi(clampedAngle + deg90ToRad) /
            toRadians);
        final value = ((widget.maxValue - widget.minValue) * normalizedValue) +
            widget.minValue;

        // final val = value.round();
        if (value != _value) {
          _value = value;
        }
      });
    }
  }

  ///
  void _onPanEnd(DragEndDetails details) {
    _dimRing();
    _drawing = false;
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(_value);
    }
  }

  ///
  void _glowRing() { //todo?
    _glowController.forward();
  }

  ///
  void _dimRing() {
    _glowController.reverse();
  }

  ///
  static double _clampAngleValue(double angle) {
    double clampedAngle = angle;
    if (angle > minRingRad && angle < midRingRad) {
      clampedAngle = minRingRad;
    } else if (angle >= midRingRad && angle < maxRingRad) {
      clampedAngle = maxRingRad;
    }
    return clampedAngle;
  }

  /// Calculates angle for slider's drawer.
  static double _calcInitialAngle({
    required double minValue,
    required double maxValue,
    required double value,
  }) {
    if (value == minValue) {
      return maxRingRad;

    } else if (value == maxValue) {
      return minRingRad;

    } else {
      final normalizedInitialValue = (value - minValue) /
          (maxValue - minValue);
      final initialAngle = toRadians * normalizedInitialValue - deg90ToRad;
      final normalizedAngle = normalizeBetweenZeroAndTwoPi(initialAngle);

      return _clampAngleValue(normalizedAngle);
    }
  }

  ///
  PolarCoord _polarCoordFromGlobalOffset(globalOffset) {
    // Convert the user's global touch offset to an offset that is local to
    // this Widget.
    final localTouchOffset =
    (context.findRenderObject() as RenderBox).globalToLocal(globalOffset);

    // Convert the local offset to a Point so that we can do math with it.
    final localTouchPoint = Point(localTouchOffset.dx, localTouchOffset.dy);

    // Create a Point at the center of this Widget to act as the origin.
    final originPoint = Point(context.size!.width / 2, context.size!.height / 2);

    return PolarCoord.fromPoints(originPoint, localTouchPoint);
  }
}

///
///
///
class PolarCoord {
  final double angle;
  final double radius;

  factory PolarCoord.fromPoints(Point<double> origin, Point<double> point) {
    // Subtract the origin from the point to get the vector from the origin
    // to the point.
    final vectorPoint = point - origin;
    final vector = Offset(vectorPoint.x, vectorPoint.y);

    // The polar coordinate is the angle the vector forms with the x-axis, and
    // the distance of the vector.
    return PolarCoord(
      vector.direction,
      vector.distance,
    );
  }

  PolarCoord(this.angle, this.radius);

  @override
  String toString() {
    return 'Polar Coord: ${radius.toStringAsFixed(2)}'
        ' at ${(angle / toRadians * 360).toStringAsFixed(2)}°';
  }
}

/// Mode of the availability of temperature set point.
enum SetPointMode {
  allGood,
  unwritable,
  error,
}