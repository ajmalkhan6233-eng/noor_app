// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A confident-looking needle is only ever shown when the compass
// reading backing it is actually trustworthy — otherwise it's dimmed,
// never a fully-opaque, seemingly-reliable wrong arrow.
//
// Kept deliberately flat/2D (2026-08-25 live-device review: the
// gradient-and-shadow "3D" bezel from the same day's earlier pass was
// still glitching on-device — "no need 3D makeup, 2D very nice
// compass design... keep a space, the 3D one [for later, with
// explicit approval]"). Plain circle, hairline border, no gradients,
// no BoxShadow layers — the simplest, most robust version, matching
// compass_face_painter.dart's own plain-primitives-only approach.
// [dimmed]'s target alpha is still eased in over ~350ms rather than
// applied instantly, to avoid the flicker a raw bool caused when the
// underlying accuracy classification jittered near its threshold.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'compass_face_painter.dart';

class QiblaNeedle extends StatefulWidget {
  const QiblaNeedle({
    super.key,
    required this.rotationDegrees,
    required this.dimmed,
  });

  final double rotationDegrees;
  final bool dimmed;

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

    return Semantics(
      label: label,
      child: SizedBox(
        width: 272,
        height: 272,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.card,
                border: Border.fromBorderSide(
                  BorderSide(color: AppColors.hairline, width: 1.5),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                size: const Size(272, 272),
                painter: CompassFacePainter(
                  rotationDegrees: widget.rotationDegrees,
                  needleAlpha: _dimmedAlpha +
                      (_trustworthyAlpha - _dimmedAlpha) * _controller.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
