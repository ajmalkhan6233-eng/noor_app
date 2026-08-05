// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure position math for DraggableFloating, split out to keep that
// file under the line limit.

import 'package:flutter/material.dart';

Offset draggableDefaultPosition(
  Size bounds,
  Size widgetSize,
  Alignment alignment,
) {
  return Offset(
    (bounds.width - widgetSize.width) / 2 +
        alignment.x * (bounds.width - widgetSize.width) / 2,
    (bounds.height - widgetSize.height) / 2 +
        alignment.y * (bounds.height - widgetSize.height) / 2,
  );
}

Offset draggableClamp(Offset offset, Size bounds, Size widgetSize) {
  return Offset(
    offset.dx.clamp(0, (bounds.width - widgetSize.width).clamp(0, double.infinity)),
    offset.dy.clamp(0, (bounds.height - widgetSize.height).clamp(0, double.infinity)),
  );
}
