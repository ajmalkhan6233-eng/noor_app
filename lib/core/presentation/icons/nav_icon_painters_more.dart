// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The "More" bottom-nav glyph — three receding stacked panels instead
// of a flat 2x2 grid, so it reads as depth rather than a plain grid
// icon. Split out of nav_icon_painters.dart to stay under this
// project's 150-line-per-file convention.
//
// Clean, minimal gold-line aesthetic (2026-09-11) — same treatment as
// [HomeIconPainter]: no orb badge, no fills/gradients, just [color]
// strokes at matching weights, so the bottom-nav set reads as one
// consistent family. Keeps the receding-panels motif, re-drawn as
// outlines only.

import 'package:flutter/material.dart';

import 'noor_icon_style.dart';

class MoreIconPainter extends CustomPainter {
  MoreIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);

    final stroke = noorIconStroke(color, width: active ? 1.7 : 1.4);
    final thinStroke = noorIconStroke(color, width: active ? 1.3 : 1.1);

    void panel(Rect rect, Paint paint) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(1.6)), paint);
    }

    panel(const Rect.fromLTWH(9, 9, 9, 9), thinStroke);
    panel(const Rect.fromLTWH(6.5, 6.5, 9, 9), thinStroke);
    panel(const Rect.fromLTWH(4, 4, 9, 9), stroke);
  }

  @override
  bool shouldRepaint(covariant MoreIconPainter old) => old.active != active || old.color != color;
}
