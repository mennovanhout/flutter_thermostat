import 'package:flutter/gestures.dart';

/// We use our own gesture detector in thermostat to handle gesture conflicts.
///
/// This way we can put widget in scrollable list and all will be working good.
class ThermostatGestureDetector extends OneSequenceGestureRecognizer {
  /// Function should returns true if panning started on slider.
  ///
  /// Otherwise we decide to pass event to another widgets.
  final bool Function(DragStartDetails details) hitTest;

  final void Function(DragStartDetails details) onPanStart;
  final void Function(DragUpdateDetails details) onPanUpdate;
  final void Function(DragEndDetails details) onPanEnd;


  ThermostatGestureDetector({
    required this.hitTest,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });


  @override
  String get debugDescription => 'ThermostatGestureDetector';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void addPointer(PointerEvent event) {
    final details = DragStartDetails(
      globalPosition: event.position,
      localPosition: event.localPosition,
    );

    final isSliderPoint = hitTest(details);

    if (isSliderPoint) {
      onPanStart(details);
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      final details = DragUpdateDetails(
        globalPosition: event.position,
      );
      onPanUpdate(details);

    } else if (event is PointerUpEvent) {
      final details = DragEndDetails();
      onPanEnd(details /*event.position*/);
      stopTrackingPointer(event.pointer);
    }
  }
}