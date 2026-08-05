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
    if (state.compassAccuracy == CompassAccuracy.unavailable) {
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
      return const Center(
        child: CircularProgressIndicator(color: AppColors.emerald),
      );
    }

    final trustworthy = state.compassAccuracy == CompassAccuracy.good;
    return DraggableFloating(
      size: const Size(220, 220),
      widgetKey: 'qibla_compass',
      controller: widget.positionController,
      child: QiblaNeedle(
        rotationDegrees: rotation,
        dimmed: !trustworthy,
        tiltX: state.tiltX,
        tiltY: state.tiltY,
      ),
    );
  }
}
