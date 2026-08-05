// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The two gesture-detector variants DraggableFloating switches
// between, split out to keep that file under the line limit.

import 'package:flutter/material.dart';

Widget dragOnlyGestureArea({
  required Widget child,
  required ValueChanged<Offset> onDelta,
  required VoidCallback onEnd,
}) {
  return GestureDetector(
    onPanUpdate: (details) => onDelta(details.delta),
    onPanEnd: (_) => onEnd(),
    child: child,
  );
}

Widget resizableGestureArea({
  required Widget child,
  required VoidCallback onStart,
  required void Function(Offset focalDelta, double cumulativeScale) onUpdate,
  required VoidCallback onEnd,
}) {
  return GestureDetector(
    onScaleStart: (_) => onStart(),
    onScaleUpdate: (details) =>
        onUpdate(details.focalPointDelta, details.scale),
    onScaleEnd: (_) => onEnd(),
    child: child,
  );
}
