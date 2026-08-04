// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/draggable_floating.dart';
import '../../../core/sensors/compass_reading.dart';
import '../logic/qibla_cubit/qibla_cubit.dart';
import '../logic/qibla_cubit/qibla_state.dart';
import 'widgets/calibration_prompt.dart';
import 'widgets/qibla_info_panel.dart';
import 'widgets/qibla_needle.dart';

/// Qibla-compass screen: a needle toward the Kaaba (only ever shown
/// with confidence the underlying compass reading earns), plus the
/// numeric bearing and distance, which are always shown. The compass
/// itself floats free — drag it anywhere on screen, it isn't fixed.
class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QiblaCubit()..start(),
      child: const _QiblaView(),
    );
  }
}

class _QiblaView extends StatelessWidget {
  const _QiblaView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: const Text(AppStrings.qiblaScreenTitle)),
      body: BlocBuilder<QiblaCubit, QiblaState>(
        builder: (context, state) => _buildBody(state),
      ),
    );
  }

  Widget _buildBody(QiblaState state) {
    if (state.locationError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Semantics(
            liveRegion: true,
            label: state.locationError,
            child: Text(
              state.locationError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.sage),
            ),
          ),
        ),
      );
    }

    if (state.bearingDegrees == null || state.distanceKm == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.emerald),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: StaggeredFadeIn(
            children: [
              AppCard(
                padding: const EdgeInsets.all(20),
                child: QiblaInfoPanel(
                  bearingDegrees: state.bearingDegrees!,
                  distanceKm: state.distanceKm!,
                ),
              ),
              if (state.compassAccuracy != CompassAccuracy.good &&
                  state.compassAccuracy != CompassAccuracy.unavailable) ...[
                const SizedBox(height: 16),
                const CalibrationPrompt(),
              ],
            ],
          ),
        ),
        Expanded(child: _compassArea(state)),
      ],
    );
  }

  Widget _compassArea(QiblaState state) {
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
      child: QiblaNeedle(rotationDegrees: rotation, dimmed: !trustworthy),
    );
  }
}
