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

/// The glossy "orb" badge every bottom-nav glyph sits inside: a
/// radial-gradient sphere, a soft cast shadow, a specular highlight,
/// and (when active) a gold rim-glow — drawn once here so all five
/// nav icons share one dimensional treatment instead of each painter
/// re-deriving its own. Call after [scaleToBox], before the glyph.
void paintNavOrbBadge(Canvas canvas, {required bool active}) {
  const center = Offset(12, 12);
  const radius = 11.0;
  final bounds = Rect.fromCircle(center: center, radius: radius);

  canvas.drawCircle(
    center.translate(0, 1.3),
    radius,
    Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.6),
  );

  final base = RadialGradient(
    center: const Alignment(-0.35, -0.45),
    radius: 0.95,
    colors: active
        ? const [Color(0xFF2E4658), Color(0xFF0C1620)]
        : const [Color(0xFF1B2732), Color(0xFF0A1219)],
  );
  canvas.drawCircle(center, radius, Paint()..shader = base.createShader(bounds));

  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = active
          ? const Color(0xFFFFB703).withValues(alpha: 0.6)
          : const Color(0xFF00F2FE).withValues(alpha: 0.22),
  );

  if (active) {
    canvas.drawCircle(
      center,
      radius + 0.6,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = const Color(0xFFFFB703).withValues(alpha: 0.32)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.4),
    );
  }

  const highlightRect = Rect.fromLTWH(8.5, 6.2, 6.5, 3.6);
  canvas.save();
  canvas.translate(highlightRect.left, highlightRect.top);
  canvas.rotate(-0.4);
  final highlightLocal = Rect.fromLTWH(0, 0, highlightRect.width, highlightRect.height);
  canvas.drawOval(
    highlightLocal,
    Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: active ? 0.4 : 0.2),
          Colors.white.withValues(alpha: 0),
        ],
      ).createShader(highlightLocal),
  );
  canvas.restore();
}
