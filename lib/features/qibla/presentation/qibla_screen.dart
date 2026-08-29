// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Qibla-compass screen: a needle toward the Kaaba (only ever shown
// with confidence the underlying compass reading earns), plus the
// numeric bearing and distance, which are always shown. Redesigned
// 2026-08-30 per direct request: needle only, centered, big and
// clear — no longer draggable/resizable, no ring/dial decoration.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/sensors/compass_reading.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import '../logic/qibla_cubit/qibla_cubit.dart';
import '../logic/qibla_cubit/qibla_state.dart';
import 'widgets/animated_calibration_banner.dart';
import 'widgets/qibla_compass_area.dart';
import 'widgets/qibla_district_fallback.dart';
import 'widgets/qibla_info_panel.dart';
import '../../../core/constants/app_color_tokens.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => QiblaCubit()..start()),
        BlocProvider(create: (_) => SettingsCubit()..load()),
      ],
      child: const _QiblaView(),
    );
  }
}

class _QiblaView extends StatelessWidget {
  const _QiblaView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.paper,
      appBar: AppBar(title: Text(l10n.qiblaScreenTitle)),
      body: BlocBuilder<QiblaCubit, QiblaState>(
        builder: (context, state) => _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, QiblaState state) {
    if (state.locationError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                liveRegion: true,
                label: state.locationError,
                child: Text(
                  state.locationError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.sage),
                ),
              ),
              const SizedBox(height: 16),
              const QiblaDistrictFallback(),
            ],
          ),
        ),
      );
    }

    if (state.bearingDegrees == null || state.distanceKm == null) {
      return Center(
        child: CircularProgressIndicator(color: context.colors.gold),
      );
    }

    final showCalibration = state.displayAccuracy != CompassAccuracy.good &&
        state.displayAccuracy != CompassAccuracy.unavailable;
    return Stack(
      children: [
        Column(
          children: [
            AnimatedCalibrationBanner(show: showCalibration),
            Expanded(child: QiblaCompassArea(state: state)),
          ],
        ),
        Positioned(
          top: 12,
          right: 12,
          child: SafeArea(
            child: QiblaInfoPanel(
              bearingDegrees: state.bearingDegrees!,
              distanceKm: state.distanceKm!,
            ),
          ),
        ),
      ],
    );
  }
}
