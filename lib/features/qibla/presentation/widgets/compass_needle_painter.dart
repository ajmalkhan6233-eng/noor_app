// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The compass dial's needle — a plain Canvas Path drawing, not a
// text-glyph Icon(). This matters for a concrete reason logged
// 2026-08-30: the previous Icon(Icons.navigation)-based needle
// rendered as a near-invisible malformed speck on a real test device
// (a GPU/driver compositing glitch, root cause outside this app's
// control — see the qibla_needle.dart history). Pure vector Path
// drawing sidesteps that whole class of bug rather than risking a
// repeat of it in the redesigned dial.
//
// No real Shader/Gradient/MaskFilter.blur anywhere in this file —
// 2026-08-30's gradient+blurred-glow version of this exact needle
// reproduced the same rendering glitch on-device, worse than the flat
// version ever did. The 2026-09-03 jeweled-star restyle still fakes a
// gold-to-bronze shade and a glowing jewel centre, but only via
// layered flat-color facets/concentric circles — visually close to a
// gradient/glow without the technique that's already confirmed to
// break rendering here.

import 'package:flutter/material.dart';

class CompassNeedlePainter extends CustomPainter {
  CompassNeedlePainter({required this.alpha, required this.locked, required this.cyan, required this.gold});

  /// 0..1 — dims the needle when the compass reading isn't trustworthy,
  /// same meaning as the previous needle widget's `dimmed` flag.
  final double alpha;

  /// Reuses `QiblaState.isLocked` (already "within a few degrees of
  /// true qibla") as the alignment-brighten signal — there's no finer-
  /// grained closeness value on `QiblaState` today, so this stays
  /// binary rather than inventing a new continuous field for it.
  final bool locked;
  final Color cyan;
  final Color gold;

  static const _bronze = Color(0xFF7A4A12);

  @override
  void paint(Canvas canvas, Size size) {
    final glowBoost = locked ? 1.0 : 0.0;
    final center = Offset(size.width / 2, size.height / 2);
    final longTip = -size.height / 2 + 10;
    final crossReach = size.height * 0.16;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Long point (toward the bearing) — outer gold facet, inner bronze
    // facet drawn smaller so the flat colors read as a gold-to-bronze
    // shade toward the centre.
    _drawKitePoint(canvas, Offset(0, longTip), 9, gold.withValues(alpha: alpha));
    _drawKitePoint(canvas, Offset(0, longTip * 0.55), 5, _bronze.withValues(alpha: alpha * 0.9));

    // Short cross-points, star-style: perpendicular pair + a shorter
    // tail, all sharing the same gold/bronze facet treatment at a
    // smaller scale.
    for (final dir in const [Offset(1, 0), Offset(-1, 0), Offset(0, 1)]) {
      final tip = dir * crossReach;
      _drawKitePoint(canvas, tip, 5, gold.withValues(alpha: alpha * 0.85));
      _drawKitePoint(canvas, tip * 0.5, 3, _bronze.withValues(alpha: alpha * 0.8));
    }

    // Cyan inner-glow edge along the long point — a thin flat-color
    // stroke, not a blurred shader, tracing just inside the gold facet.
    final edgeGlow = Path()
      ..moveTo(0, longTip * 0.85)
      ..lineTo(-4, 0)
      ..moveTo(0, longTip * 0.85)
      ..lineTo(4, 0);
    canvas.drawPath(
      edgeGlow,
      Paint()
        ..color = cyan.withValues(alpha: alpha * (0.35 + 0.25 * glowBoost))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // Glowing jewel pivot — concentric flat-color circles standing in
    // for a radial-gradient glow, brightest at the core.
    final jewelAlpha = alpha * (0.85 + 0.15 * glowBoost);
    canvas.drawCircle(Offset.zero, 8 + 2 * glowBoost, Paint()..color = gold.withValues(alpha: jewelAlpha * 0.25));
    canvas.drawCircle(Offset.zero, 5, Paint()..color = _bronze.withValues(alpha: jewelAlpha * 0.7));
    canvas.drawCircle(Offset.zero, 2.4, Paint()..color = cyan.withValues(alpha: jewelAlpha));

    canvas.restore();
  }

  /// A small elongated kite/diamond — the repeated facet shape used for
  /// every point of the star (long bearing point and the shorter
  /// cross-points alike), just at different scales.
  void _drawKitePoint(Canvas canvas, Offset tip, double halfWidth, Color color) {
    final perp = Offset(-tip.dy, tip.dx);
    final perpLen = perp.distance;
    if (perpLen == 0) return;
    final side = perp / perpLen * halfWidth;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(side.dx, side.dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(-side.dx, -side.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CompassNeedlePainter old) => old.alpha != alpha || old.locked != locked;
}
