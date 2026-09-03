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
// 2026-09-03: the jeweled-star version of this needle (multiple gold/
// bronze facets, a stroked cyan edge, three concentric jewel circles —
// ~12 draw calls per frame) reproduced the SAME blank/near-invisible
// rendering glitch live, confirmed via a pixel-diffed screenshot burst
// (4 of 8 frames collapsed to a tiny speck, phone stationary). The
// earlier 2026-08-30 fix (flat colors, no gradient/blur) wasn't
// enough on its own this time — the glitch tracks with how many draw
// calls this needle makes per frame, not just shader use. Simplified
// back down hard: one solid-fill long point, one plain single-color
// cross accent (two lines, not filled facets), one solid-fill jewel
// dot — 4 draw calls total, close to the original two-triangle
// needle's footprint, the configuration already proven stable. Still
// flat colors only, still no Shader/Gradient/MaskFilter.blur anywhere.

import 'package:flutter/material.dart';

class CompassNeedlePainter extends CustomPainter {
  CompassNeedlePainter({required this.alpha, required this.locked, required this.cyan, required this.gold});

  /// 0..1 — dims the needle when the compass reading isn't trustworthy,
  /// same meaning as the previous needle widget's `dimmed` flag.
  final double alpha;

  /// Brightens the needle slightly when aligned — reuses
  /// `QiblaState.isLocked` (already "within a few degrees of true
  /// qibla"); there's no finer-grained closeness value on `QiblaState`
  /// today, so this stays binary.
  final bool locked;
  final Color cyan;
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    final color = locked ? gold : cyan;
    final center = Offset(size.width / 2, size.height / 2);
    final tipY = -size.height / 2 + 12;
    final crossReach = size.height * 0.14;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Long point, toward the bearing.
    final needlePath = Path()
      ..moveTo(0, 0)
      ..lineTo(-7, 0)
      ..lineTo(0, tipY)
      ..lineTo(7, 0)
      ..close();
    canvas.drawPath(needlePath, Paint()..color = color.withValues(alpha: alpha));

    // Tail.
    final tailPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height / 2 - 20)
      ..lineTo(-5, 0)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFF3B3C42).withValues(alpha: 0.55 * alpha));

    // Short cross-points — plain strokes, not filled facets, to keep
    // the star silhouette without extra fill draw calls.
    final crossStroke = Paint()
      ..color = gold.withValues(alpha: alpha * 0.8)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-crossReach, 0), Offset(crossReach, 0), crossStroke);

    // Jewel pivot — a single solid dot, no concentric glow layers.
    canvas.drawCircle(Offset.zero, 3, Paint()..color = gold.withValues(alpha: alpha));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CompassNeedlePainter old) => old.alpha != alpha || old.locked != locked;
}
