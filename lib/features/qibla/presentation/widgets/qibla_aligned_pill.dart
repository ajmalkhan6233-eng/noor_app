// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// "Qibla Aligned" pill (2026-08-30 mockup rebuild) — a small,
// dismissible-by-drifting-out-of-alignment badge near the compass, not
// a screen-covering dialog. Shown only while QiblaState.isLocked is
// true; the haptic pulse that fires alongside it lives in
// qibla_compass_area.dart, where the lock transition is already
// detected (it fires a particle burst there too — this pill is the
// second half of the same "you found it" moment, not a new signal).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../l10n/generated/app_localizations.dart';

class QiblaAlignedPill extends StatelessWidget {
  const QiblaAlignedPill({super.key, required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: !visible
          ? const SizedBox(key: ValueKey('aligned-hidden'), height: 0)
          : Semantics(
              key: const ValueKey('aligned-shown'),
              liveRegion: true,
              label: l10n.qiblaAlignedPillLabel,
              child: ExcludeSemantics(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.gold, width: 1.5),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colors.gold.withValues(alpha: 0.2), colors.gold.withValues(alpha: 0.08)],
                    ),
                    boxShadow: [BoxShadow(color: colors.gold.withValues(alpha: 0.28), blurRadius: 22)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0A0D14),
                          border: Border.all(color: colors.gold, width: 1.5),
                        ),
                        child: CustomPaint(size: const Size(14, 14), painter: _CheckPainter(colors.gold)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.qiblaAlignedPillLabel.toUpperCase(),
                        style: TextStyle(color: colors.ink, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.15, size.height * 0.55)
        ..lineTo(size.width * 0.42, size.height * 0.8)
        ..lineTo(size.width * 0.85, size.height * 0.25),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) => old.color != color;
}
