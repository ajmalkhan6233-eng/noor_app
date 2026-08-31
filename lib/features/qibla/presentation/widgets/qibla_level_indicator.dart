// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// "Hold level" bar (2026-08-30 mockup rebuild) — reuses QiblaState's
// existing tiltX (already fed from the accelerometer for the compass's
// light-sweep effect elsewhere) rather than a new sensor stream.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../l10n/generated/app_localizations.dart';

class QiblaLevelIndicator extends StatelessWidget {
  const QiblaLevelIndicator({super.key, required this.tiltX});

  /// -1..1, same convention as QiblaState.tiltX.
  final double tiltX;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: colors.ink.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.ink.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Text(
            l10n.qiblaHoldLevelLabel.toUpperCase(),
            style: TextStyle(color: colors.sage, fontSize: 10.5, letterSpacing: 0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final trackWidth = constraints.maxWidth;
                const pillWidth = 18.0;
                final travel = (trackWidth - pillWidth) / 2;
                final offset = tiltX.clamp(-1.0, 1.0) * travel;
                return SizedBox(
                  height: 7,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: colors.ink.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(5)),
                      ),
                      Positioned(
                        left: trackWidth / 2 - pillWidth / 2 + offset,
                        child: Container(
                          width: pillWidth,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(colors: [colors.accentSecondary, colors.gold]),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          CustomPaint(size: const Size(16, 16), painter: _LevelIconPainter(colors.accentSecondary)),
        ],
      ),
    );
  }
}

class _LevelIconPainter extends CustomPainter {
  _LevelIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.scale(size.width / 24, size.height / 24);
    canvas.drawLine(const Offset(12, 3), const Offset(12, 21), paint);
    canvas.drawPath(Path()..moveTo(6, 8)..lineTo(12, 3)..lineTo(18, 8), paint);
    canvas.drawPath(Path()..moveTo(6, 16)..lineTo(12, 21)..lineTo(18, 16), paint);
  }

  @override
  bool shouldRepaint(covariant _LevelIconPainter old) => old.color != color;
}
