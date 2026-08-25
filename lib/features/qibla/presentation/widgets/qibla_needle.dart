// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A confident-looking needle is only ever shown when the compass
// reading backing it is actually trustworthy — otherwise it's dimmed,
// never a fully-opaque, seemingly-reliable wrong arrow.
//
// Rebuilt fresh (2026-08-25 live-device review — see
// compass_face_painter.dart's header for the full story): the bezel
// and recessed face are now plain Container/BoxDecoration gradients
// and shadows, not raw canvas shader/blur ops, after those proved to
// render as near-nothing on the live device while looking correct in
// source. [dimmed]'s target alpha is still eased in over ~350ms
// rather than applied instantly, to avoid the flicker a raw bool
// caused when the underlying accuracy classification jittered near
// its threshold.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'compass_face_painter.dart';

class QiblaNeedle extends StatefulWidget {
  const QiblaNeedle({
    super.key,
    required this.rotationDegrees,
    required this.dimmed,
    this.tiltX = 0,
    this.tiltY = 0,
  });

  final double rotationDegrees;
  final bool dimmed;
  final double tiltX;
  final double tiltY;

  @override
  State<QiblaNeedle> createState() => _QiblaNeedleState();
}

class _QiblaNeedleState extends State<QiblaNeedle> with SingleTickerProviderStateMixin {
  static const _trustworthyAlpha = 1.0;
  static const _dimmedAlpha = 0.35;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: widget.dimmed ? 0 : 1,
    );
  }

  @override
  void didUpdateWidget(QiblaNeedle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dimmed == oldWidget.dimmed) return;
    widget.dimmed ? _controller.reverse() : _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label =
        '${AppLocalizations.of(context)!.qiblaNeedleSemanticLabel}: '
        '${widget.rotationDegrees.round()} degrees from facing direction'
        '${widget.dimmed ? ', low confidence' : ''}';

    // Light drifts opposite the tilt, as if fixed overhead and the
    // bezel were tipping under it — a cheap, robust stand-in for the
    // previous per-facet lighting the raw-canvas bezel computed.
    final lightAlign = Alignment(
      (-widget.tiltX).clamp(-1.0, 1.0),
      (-widget.tiltY).clamp(-1.0, 1.0),
    );

    return Semantics(
      label: label,
      child: SizedBox(
        width: 272,
        height: 272,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Raised titanium/obsidian bezel with a gold rim catching
            // the light.
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: lightAlign,
                  end: -lightAlign,
                  colors: [AppColors.gold.withValues(alpha: 0.5), AppColors.card],
                ),
                border: Border.all(color: AppColors.hairline, width: 1),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 6)),
                ],
              ),
            ),
            // Recessed face, inset from the bezel.
            Padding(
              padding: const EdgeInsets.all(22),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColors.paper, AppColors.card],
                    stops: const [0.7, 1.0],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      spreadRadius: -6,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => CustomPaint(
                  size: const Size(228, 228),
                  painter: CompassFacePainter(
                    rotationDegrees: widget.rotationDegrees,
                    needleAlpha: _dimmedAlpha +
                        (_trustworthyAlpha - _dimmedAlpha) * _controller.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
