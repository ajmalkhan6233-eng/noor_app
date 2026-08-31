// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The compass dial's tapered needle — a plain Canvas Path drawing, not
// a text-glyph Icon(). This matters for a concrete reason logged
// 2026-08-30: the previous Icon(Icons.navigation)-based needle
// rendered as a near-invisible malformed speck on a real test device
// (a GPU/driver compositing glitch, root cause outside this app's
// control — see the qibla_needle.dart history). Pure vector Path
// drawing sidesteps that whole class of bug rather than risking a
// repeat of it in the redesigned dial.
//
// Solid fill, not a gradient shader — simplified 2026-08-30, direct
// request ("no need 3D, just a plain compass"), after the gradient +
// blurred-glow version of this needle reproduced the same rendering
// glitch on-device, worse than the plain version ever did. A flat
// color is the most conservative, most reliably-rendering choice
// while that glitch's root cause is still unresolved — gold once
// aligned, cyan otherwise, matching the color language already used
// everywhere else in this screen (the aligned pill, the old needle).

import 'package:flutter/material.dart';

class CompassNeedlePainter extends CustomPainter {
  CompassNeedlePainter({required this.alpha, required this.locked, required this.cyan, required this.gold});

  /// 0..1 — dims the needle when the compass reading isn't trustworthy,
  /// same meaning as the previous needle widget's `dimmed` flag.
  final double alpha;
  final bool locked;
  final Color cyan;
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    final color = locked ? gold : cyan;
    final center = Offset(size.width / 2, size.height / 2);
    final tipY = -size.height / 2 + 12;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    final needlePath = Path()
      ..moveTo(0, 0)
      ..lineTo(-8, 0)
      ..lineTo(0, tipY)
      ..lineTo(8, 0)
      ..close();
    canvas.drawPath(needlePath, Paint()..color = color.withValues(alpha: alpha));

    final tailPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height / 2 - 20)
      ..lineTo(-5, 0)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFF3B3C42).withValues(alpha: 0.55 * alpha));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CompassNeedlePainter old) => old.alpha != alpha || old.locked != locked;
}
