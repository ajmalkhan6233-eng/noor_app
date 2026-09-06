// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The "More" bottom-nav glyph — three receding stacked panels instead
// of a flat 2x2 grid, so it reads as depth rather than a plain grid
// icon. Split out of nav_icon_painters.dart to stay under this
// project's 150-line-per-file convention.

import 'package:flutter/material.dart';

import 'noor_icon_style.dart';

class MoreIconPainter extends CustomPainter {
  MoreIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    paintNavOrbBadge(canvas, active: active);

    void panel(Rect rect, {Shader? shader, Color? fill, required Color stroke, required double strokeW}) {
      final rr = RRect.fromRectAndRadius(rect, const Radius.circular(2));
      canvas.drawRRect(rr, shader != null ? (Paint()..shader = shader) : noorIconFill(fill!));
      canvas.drawRRect(rr, noorIconStroke(stroke, width: strokeW));
    }

    panel(
      const Rect.fromLTWH(9, 9, 9, 9),
      fill: active ? const Color(0xFF173C48) : const Color(0xFF101820),
      stroke: active ? const Color(0xFF00F2FE).withValues(alpha: 0.6) : const Color(0xFF6B7C90),
      strokeW: 1,
    );
    if (active) {
      canvas.drawCircle(const Offset(16.7, 10.3), 0.35, noorIconFill(const Color(0xFF00F2FE).withValues(alpha: 0.5)));
    }

    panel(
      const Rect.fromLTWH(6.5, 6.5, 9, 9),
      fill: active ? const Color(0xFF1B4753) : const Color(0xFF101820),
      stroke: active ? const Color(0xFF00F2FE).withValues(alpha: 0.85) : const Color(0xFF6B7C90),
      strokeW: 1.1,
    );
    if (active) {
      canvas.drawCircle(const Offset(14.2, 7.8), 0.35, noorIconFill(const Color(0xFF00F2FE).withValues(alpha: 0.6)));
    }

    const frontRect = Rect.fromLTWH(4, 4, 9, 9);
    panel(
      frontRect,
      shader: active
          ? const LinearGradient(colors: [Color(0xFFFFEFC2), Color(0xFFFFDD8C), Color(0xFFC98A00)]).createShader(frontRect)
          : null,
      fill: active ? null : const Color(0xFF22201A),
      stroke: active ? const Color(0xFF8A5A00) : const Color(0xFF6B7C90),
      strokeW: 0.6,
    );
    if (active) {
      canvas.drawLine(
        const Offset(5, 5.4),
        const Offset(11.5, 5.4),
        noorIconStroke(const Color(0xFFFFF3D6).withValues(alpha: 0.55), width: 0.9),
      );
      canvas.drawCircle(const Offset(11.7, 11.3), 0.3, noorIconFill(const Color(0xFF7A5000)));
    }
  }

  @override
  bool shouldRepaint(covariant MoreIconPainter old) => old.active != active;
}
