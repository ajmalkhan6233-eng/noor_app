// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/draggable_position_controller.dart';
import '../../../core/sensors/compass_reading.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../logic/qibla_cubit/qibla_cubit.dart';
import '../logic/qibla_cubit/qibla_state.dart';
import 'widgets/calibration_prompt.dart';
import 'widgets/qibla_compass_area.dart';
import 'widgets/qibla_info_panel.dart';

/// Qibla-compass screen: a needle toward the Kaaba (only ever shown
/// with confidence the underlying compass reading earns), plus the
/// numeric bearing and distance, which are always shown. The compass
/// itself floats free — drag it anywhere on screen, position
/// persisted, with a button to recentre it.
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

class _QiblaView extends StatefulWidget {
  const _QiblaView();

  @override
  State<_QiblaView> createState() => _QiblaViewState();
}

class _QiblaViewState extends State<_QiblaView> {
  final _compassPosition = DraggablePositionController();

  @override
  void dispose() {
    _compassPosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(l10n.qiblaScreenTitle),
        actions: [
          Semantics(
            label: l10n.recentreCompassLabel,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.center_focus_strong_outlined),
              tooltip: l10n.recentreCompassLabel,
              onPressed: _compassPosition.reset,
            ),
          ),
        ],
      ),
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
        Expanded(
          child: QiblaCompassArea(
            state: state,
            positionController: _compassPosition,
          ),
        ),
      ],
    );
  }
}
