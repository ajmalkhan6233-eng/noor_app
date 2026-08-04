// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/sensors/compass_reading.dart';
import '../logic/qibla_cubit/qibla_cubit.dart';
import '../logic/qibla_cubit/qibla_state.dart';
import 'widgets/calibration_prompt.dart';
import 'widgets/qibla_info_panel.dart';
import 'widgets/qibla_needle.dart';

/// Qibla-compass screen: a needle toward the Kaaba (only ever shown
/// with confidence the underlying compass reading earns), plus the
/// numeric bearing and distance, which are always shown.
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
      backgroundColor: AppColors.ink,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: BlocBuilder<QiblaCubit, QiblaState>(
            builder: (context, state) => AppCard(
              padding: const EdgeInsets.all(24),
              child: _buildBody(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(QiblaState state) {
    if (state.locationError != null) {
      return Semantics(
        liveRegion: true,
        label: state.locationError,
        child: Text(
          state.locationError!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.sage),
        ),
      );
    }

    if (state.bearingDegrees == null || state.distanceKm == null) {
      return const CircularProgressIndicator(color: AppColors.gold);
    }

    return StaggeredFadeIn(
      children: [
        QiblaInfoPanel(
          bearingDegrees: state.bearingDegrees!,
          distanceKm: state.distanceKm!,
        ),
        const SizedBox(height: 24),
        ..._buildCompassSection(state),
      ],
    );
  }

  List<Widget> _buildCompassSection(QiblaState state) {
    if (state.compassAccuracy == CompassAccuracy.unavailable) {
      return const [
        Text(
          AppStrings.qiblaNoCompassMessage,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.sage),
        ),
      ];
    }

    final rotation = state.needleRotationDegrees;
    if (rotation == null) {
      return const [CircularProgressIndicator(color: AppColors.gold)];
    }

    final trustworthy = state.compassAccuracy == CompassAccuracy.good;
    return [
      QiblaNeedle(rotationDegrees: rotation, dimmed: !trustworthy),
      if (!trustworthy) const CalibrationPrompt(),
    ];
  }
}
