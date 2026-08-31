// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// "Qibla" title in the serif display font with a small gold
// ornamental line-diamond-line divider beneath it, per the 2026-08-30
// mockup rebuild — replaces the plain AppBar title text.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';

class QiblaTitleOrnament extends StatelessWidget {
  const QiblaTitleOrnament({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppTypography.displayFamily,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: colors.gold,
          ),
        ),
        const SizedBox(height: 5),
        CustomPaint(size: const Size(100, 9), painter: _OrnamentPainter(colors.gold)),
      ],
    );
  }
}

class _OrnamentPainter extends CustomPainter {
  _OrnamentPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 1;
    final midY = size.height / 2;
    canvas.drawLine(Offset(0, midY), Offset(size.width * 0.42, midY), linePaint);
    canvas.drawLine(Offset(size.width * 0.58, midY), Offset(size.width, midY), linePaint);

    canvas.save();
    canvas.translate(size.width / 2, midY);
    canvas.rotate(3.14159265 / 4);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 6.5, height: 6.5),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OrnamentPainter old) => old.color != color;
}
