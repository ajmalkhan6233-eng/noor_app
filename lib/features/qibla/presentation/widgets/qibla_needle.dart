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
import 'package:flutter/scheduler.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/angle_math.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'compass_face_painter.dart';

class QiblaNeedle extends StatefulWidget {
  const QiblaNeedle({
    super.key,
    required this.rotationDegrees,
    required this.dimmed,
    this.locked = false,
  });

  final double rotationDegrees;
  final bool dimmed;

  /// True when the device is currently facing the qibla within
  /// [kQiblaLockThresholdDegrees] — drives the needle's gold "aligned"
  /// color instead of the usual cyan.
  final bool locked;

  @override
  State<QiblaNeedle> createState() => _QiblaNeedleState();
}

class _QiblaNeedleState extends State<QiblaNeedle> with TickerProviderStateMixin {
  static const _trustworthyAlpha = 1.0;
  static const _dimmedAlpha = 0.35;

  // Raw compass readings arrive noisy — applying them straight to the
  // painter's rotation snapped the needle frame to frame, which reads
  // as a flicker rather than a smooth swing. Easing the *displayed*
  // angle toward the raw target each frame (shortest way around the
  // circle) removes that without adding perceptible lag.
  static const _smoothingFactor = 0.18;

  late final AnimationController _dimController;
  late final Ticker _smoothingTicker;
  late double _displayedRotation;

  @override
  void initState() {
    super.initState();
    _displayedRotation = widget.rotationDegrees;
    _dimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: widget.dimmed ? 0 : 1,
    );
    _smoothingTicker = createTicker(_onTick)..start();
  }

  void _onTick(Duration _) {
    final next = AngleMath.smooth(_displayedRotation, widget.rotationDegrees, _smoothingFactor);
    if (next == _displayedRotation) return;
    setState(() => _displayedRotation = next);
  }

  @override
  void didUpdateWidget(QiblaNeedle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dimmed != oldWidget.dimmed) {
      widget.dimmed ? _dimController.reverse() : _dimController.forward();
    }
  }

  @override
  void dispose() {
    _smoothingTicker.dispose();
    _dimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label =
        '${AppLocalizations.of(context)!.qiblaNeedleSemanticLabel}: '
        '${widget.rotationDegrees.round()} degrees from facing direction'
        '${widget.dimmed ? ', low confidence' : ''}'
        '${widget.locked ? ', aligned with qibla' : ''}';

    return Semantics(
      label: label,
      child: SizedBox(
        width: 272,
        height: 272,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.card,
                border: Border.fromBorderSide(
                  BorderSide(
                    color: widget.locked ? AppColors.gold : AppColors.hairline,
                    width: 1.5,
                  ),
                ),
                boxShadow: widget.locked
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.45),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ]
                    : const [],
              ),
            ),
            AnimatedBuilder(
              animation: _dimController,
              builder: (context, _) => CustomPaint(
                size: const Size(272, 272),
                painter: CompassFacePainter(
                  rotationDegrees: _displayedRotation,
                  needleAlpha: _dimmedAlpha +
                      (_trustworthyAlpha - _dimmedAlpha) * _dimController.value,
                  locked: widget.locked,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
