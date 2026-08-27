// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// More-screen glyphs, part 2: Settings, About, Feedback. See
// noor_icon_type.dart for why these exist instead of Material icons.

import 'package:flutter/material.dart';

import 'noor_icon_style.dart';

/// Adjustment sliders instead of a gear — reads more clearly at small
/// sizes and matches the app's own Settings screen (sliders/toggles),
/// not a mechanical-parts metaphor.
class SettingsIconPainter extends CustomPainter {
  SettingsIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    final fill = noorIconFill(color);
    const rows = [(7.0, 15.0), (12.0, 8.0), (17.0, 17.0)];
    for (final (y, knobX) in rows) {
      canvas.drawLine(Offset(4, y), Offset(20, y), stroke);
      canvas.drawCircle(Offset(knobX, y), 2.2, fill);
    }
  }

  @override
  bool shouldRepaint(covariant SettingsIconPainter old) => old.color != color;
}

class AboutIconPainter extends CustomPainter {
  AboutIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    canvas.drawCircle(const Offset(12, 12), 8, noorIconStroke(color));
    canvas.drawLine(const Offset(12, 11), const Offset(12, 16), noorIconStroke(color));
    canvas.drawCircle(const Offset(12, 8), 1.1, noorIconFill(color));
  }

  @override
  bool shouldRepaint(covariant AboutIconPainter old) => old.color != color;
}

class FeedbackIconPainter extends CustomPainter {
  FeedbackIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTRB(4, 5.5, 20, 16), const Radius.circular(3)),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(8, 16)
        ..lineTo(7, 19.5)
        ..lineTo(11.5, 16),
      stroke,
    );
    canvas.drawCircle(const Offset(12, 10.5), 0.9, noorIconFill(color));
    canvas.drawLine(const Offset(8, 13), const Offset(16, 13), stroke);
  }

  @override
  bool shouldRepaint(covariant FeedbackIconPainter old) => old.color != color;
}
