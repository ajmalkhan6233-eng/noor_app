// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Qibla compass dial (2026-08-30 mockup rebuild, consolidated
// 2026-09-01 into a single CustomPainter — see compass_dial_painter.dart
// for why). ~336dp per the approved design. Keeps its own Ticker-eased
// rotation so paint frequency stays decoupled from the raw compass
// sensor stream, same as the pre-rebuild QiblaNeedle widget did.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/utils/angle_math.dart';
import 'compass_dial_painter.dart';

class QiblaCompassDial extends StatefulWidget {
  const QiblaCompassDial({
    super.key,
    required this.rotationDegrees,
    required this.dimmed,
    required this.locked,
  });

  static const double diameter = 336;

  /// Target rotation for the needle/badge to ease toward — bearing
  /// relative to current facing. The badge can land anywhere on the
  /// ring depending on this value, which is why the FACING/QIBLA
  /// readout is drawn as a sibling row below the dial (in
  /// qibla_compass_area.dart) rather than inside it — it used to be
  /// fixed inside a corner of the dial and collided with the badge the
  /// moment a real bearing rotated through that corner (found live,
  /// 2026-08-30).
  final double rotationDegrees;
  final bool dimmed;
  final bool locked;

  @override
  State<QiblaCompassDial> createState() => _QiblaCompassDialState();
}

class _QiblaCompassDialState extends State<QiblaCompassDial> with SingleTickerProviderStateMixin {
  static const _smoothingFactor = 0.18;

  late final Ticker _ticker;
  late double _displayedRotation = widget.rotationDegrees;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration _) {
    final next = AngleMath.smooth(_displayedRotation, widget.rotationDegrees, _smoothingFactor);
    if (next == _displayedRotation) return;
    setState(() => _displayedRotation = next);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: QiblaCompassDial.diameter + 40,
      height: QiblaCompassDial.diameter + 40,
      child: CustomPaint(
        painter: CompassDialPainter(
          rotationDegrees: _displayedRotation,
          alpha: widget.dimmed ? 0.35 : 1.0,
          locked: widget.locked,
          gold: colors.gold,
          cyan: colors.accentSecondary,
          ink: colors.ink,
          sage: colors.sage,
        ),
      ),
    );
  }
}
