// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Redesigned 2026-08-30 per direct request: needle only, centered, big
// and clear — removes the ring/tick/dial decoration (QiblaNeedleRing,
// CompassFacePainter, KaabaMarkerPainter) that sat around it before.
// "3D" here means a soft glow/shadow depth effect, not real 3D
// geometry — this app has no 3D rendering package. A confident-
// looking needle is only ever shown when the compass reading backing
// it is actually trustworthy — otherwise it's dimmed, never a fully-
// opaque, seemingly-reliable wrong arrow (kept from the previous
// design, still correct here).

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/utils/angle_math.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
  /// [kQiblaLockThresholdDegrees] — drives the gold "aligned" color and
  /// message instead of the usual cyan.
  final bool locked;

  @override
  State<QiblaNeedle> createState() => _QiblaNeedleState();
}

class _QiblaNeedleState extends State<QiblaNeedle> with TickerProviderStateMixin {
  static const _trustworthyAlpha = 1.0;
  static const _dimmedAlpha = 0.35;

  // Raw compass readings arrive noisy — applying them straight to the
  // needle's rotation snapped it frame to frame, which reads as a
  // flicker rather than a smooth swing. Easing the *displayed* angle
  // toward the raw target each frame (shortest way around the circle)
  // removes that without adding perceptible lag.
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
    final l10n = AppLocalizations.of(context)!;
    final label =
        '${l10n.qiblaNeedleSemanticLabel}: '
        '${widget.rotationDegrees.round()} degrees from facing direction'
        '${widget.dimmed ? ', low confidence' : ''}'
        '${widget.locked ? ', aligned with qibla' : ''}';

    return Semantics(
      label: label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _dimController,
            builder: (context, _) {
              final alpha = _dimmedAlpha + (_trustworthyAlpha - _dimmedAlpha) * _dimController.value;
              final color = widget.locked ? context.colors.gold : context.colors.accentSecondary;
              return Text(
                widget.locked ? l10n.qiblaAlignedMessage : l10n.qiblaRotateMessage,
                style: TextStyle(color: color.withValues(alpha: alpha), fontSize: 15, fontWeight: FontWeight.w600),
              );
            },
          ),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _dimController,
            builder: (context, _) {
              final alpha = _dimmedAlpha + (_trustworthyAlpha - _dimmedAlpha) * _dimController.value;
              final color = widget.locked ? context.colors.gold : context.colors.accentSecondary;
              return Transform.rotate(
                angle: _displayedRotation * (3.14159265 / 180),
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Soft glow/shadow depth — the closest "3D" this
                    // widget-based rendering can genuinely deliver
                    // without a separate 3D package.
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: alpha * 0.4),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.navigation,
                    size: 200,
                    color: color.withValues(alpha: alpha),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
