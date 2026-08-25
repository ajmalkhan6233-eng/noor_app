// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The compass's draggable region — split out of QiblaScreen to stay
// under the 150-line limit. Fires a calm confirmation burst the
// moment the needle settles onto the qibla (QiblaState.isLocked),
// re-arming only after it drifts back out of lock.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/effects/particle_burst.dart';
import '../../../../core/presentation/widgets/draggable_floating.dart';
import '../../../../core/presentation/widgets/draggable_position_controller.dart';
import '../../../../core/sensors/compass_reading.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/qibla_cubit/qibla_state.dart';
import 'qibla_needle.dart';

class QiblaCompassArea extends StatefulWidget {
  const QiblaCompassArea({
    super.key,
    required this.state,
    required this.positionController,
  });

  final QiblaState state;
  final DraggablePositionController positionController;

  @override
  State<QiblaCompassArea> createState() => _QiblaCompassAreaState();
}

class _QiblaCompassAreaState extends State<QiblaCompassArea> {
  @override
  void didUpdateWidget(QiblaCompassArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isLocked && !oldWidget.state.isLocked) {
      // Smaller, calmer than the tasbih milestone burst — a quiet
      // confirmation, not a celebration.
      ParticleBurst.play(context, intensity: 0.35);
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
            style: const TextStyle(color: AppColors.sage),
          ),
        ),
      );
    }

    final rotation = state.needleRotationDegrees;
    if (rotation == null) {
      // A plain spinner here used to just spin forever if
      // flutter_compass never delivered a first event on a given
      // device — reported live as "the app is completely locked".
      // QiblaCubit's stall timeout (5s) turns that into an actual,
      // actionable message instead of silence.
      if (state.compassStalled) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.explore_off_outlined, color: AppColors.sage, size: 40),
                const SizedBox(height: 12),
                const Text(
                  "The compass sensor isn't responding. Try moving your "
                  'phone in a figure-8 a few times to calibrate it, or '
                  'reopen this screen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.sage),
                ),
              ],
            ),
          ),
        );
      }
      return const Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      );
    }

    final trustworthy = state.displayAccuracy == CompassAccuracy.good;
    return DraggableFloating(
      // Bumped up from 220 (2026-08-24 live-device review: "make the
      // compass a little bit big") — still pinch-resizable 0.7x-1.6x
      // from here via minScale/maxScale below.
      size: const Size(272, 272),
      widgetKey: 'qibla_compass',
      controller: widget.positionController,
      resizable: true,
      minScale: 0.7,
      maxScale: 1.6,
      child: QiblaNeedle(
        rotationDegrees: rotation,
        dimmed: !trustworthy,
      ),
    );
  }
}
