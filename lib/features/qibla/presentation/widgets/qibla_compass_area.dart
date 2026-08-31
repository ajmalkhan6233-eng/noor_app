// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The compass area — split out of QiblaScreen to stay under the
// 150-line limit. Fires a calm confirmation burst plus a haptic pulse
// the moment the needle settles onto the qibla (QiblaState.isLocked),
// re-arming only after it drifts back out of lock. Rebuilt 2026-08-30
// per the approved mockup: QiblaCompassDial replaces the old plain
// QiblaNeedle, and a QiblaAlignedPill (not a dialog) shows/hides with
// the same lock signal.

import 'package:flutter/material.dart';

import '../../../../core/effects/particle_burst.dart';
import '../../../../core/haptics/haptic_service.dart';
import '../../../../core/sensors/compass_reading.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/qibla_cubit/qibla_state.dart';
import 'qibla_aligned_pill.dart';
import 'qibla_compass_dial.dart';
import 'qibla_heading_readout.dart';
import '../../../../core/constants/app_color_tokens.dart';

class QiblaCompassArea extends StatefulWidget {
  const QiblaCompassArea({super.key, required this.state});

  final QiblaState state;

  @override
  State<QiblaCompassArea> createState() => _QiblaCompassAreaState();
}

class _QiblaCompassAreaState extends State<QiblaCompassArea> {
  static const _haptics = HapticService();

  @override
  void didUpdateWidget(QiblaCompassArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isLocked && !oldWidget.state.isLocked) {
      // Smaller, calmer than the tasbih milestone burst — a quiet
      // confirmation, not a celebration.
      ParticleBurst.play(context, intensity: 0.35);
      _haptics.tap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    if (state.displayAccuracy == CompassAccuracy.unavailable) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            AppLocalizations.of(context)!.qiblaNoCompassMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.sage),
          ),
        ),
      );
    }

    final rotation = state.needleRotationDegrees;
    if (rotation == null) {
      if (state.compassStalled) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.explore_off_outlined, color: context.colors.sage, size: 40),
                const SizedBox(height: 12),
                Text(
                  "The compass sensor isn't responding. Try moving your "
                  'phone in a figure-8 a few times to calibrate it, or '
                  'reopen this screen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.sage),
                ),
              ],
            ),
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(color: context.colors.gold),
      );
    }

    final trustworthy = state.displayAccuracy == CompassAccuracy.good;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QiblaCompassDial(rotationDegrees: rotation, dimmed: !trustworthy, locked: state.isLocked),
        const SizedBox(height: 12),
        QiblaHeadingReadout(headingDegrees: state.headingDegrees, bearingDegrees: state.bearingDegrees!),
        QiblaAlignedPill(visible: state.isLocked),
      ],
    );
  }
}
