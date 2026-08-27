// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shared stroke style for the whole noor_icon_painters_* set, so every
// glyph in the set reads as one family (same weight, same rounded
// caps/joins) rather than each painter picking its own line weight.

import 'package:flutter/material.dart';

Paint noorIconStroke(Color color, {double width = 1.7}) {
  return Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
}

Paint noorIconFill(Color color) {
  return Paint()
    ..color = color
    ..style = PaintingStyle.fill;
}

/// Every painter draws in a fixed 24x24 coordinate box; this scales
/// that box to the actual requested size so path data never needs to
/// know its final render size.
void scaleToBox(Canvas canvas, Size size) {
  canvas.scale(size.width / 24, size.height / 24);
}
