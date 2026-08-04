// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The compass's draggable region — split out of QiblaScreen to stay
// under the 150-line limit.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/presentation/widgets/draggable_floating.dart';
import '../../../../core/presentation/widgets/draggable_position_controller.dart';
import '../../../../core/sensors/compass_reading.dart';
import '../../logic/qibla_cubit/qibla_state.dart';
import 'qibla_needle.dart';

class QiblaCompassArea extends StatelessWidget {
  const QiblaCompassArea({
    super.key,
    required this.state,
    required this.positionController,
  });

  final QiblaState state;
  final DraggablePositionController positionController;

  @override
  Widget build(BuildContext context) {
    if (state.compassAccuracy == CompassAccuracy.unavailable) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            AppStrings.qiblaNoCompassMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.sage),
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
      controller: positionController,
      child: QiblaNeedle(
        rotationDegrees: rotation,
        dimmed: !trustworthy,
        tiltX: state.tiltX,
        tiltY: state.tiltY,
      ),
    );
  }
}
