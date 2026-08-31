// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Qibla screen, rebuilt 2026-08-30 per the approved mockup: a route/
// distance card with a plane travelling toward Makkah, the redesigned
// compass dial, an "aligned" pill (not a dialog), a compact level
// indicator, and a caption — no full-screen calibration takeover
// (FR-9's honest low-accuracy warning is still shown, just as a small
// pill via AnimatedCalibrationBanner, same as before this rebuild).

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
import 'widgets/qibla_level_indicator.dart';
import 'widgets/qibla_route_card.dart';
import 'widgets/qibla_title_ornament.dart';
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
      appBar: AppBar(
        backgroundColor: context.colors.paper,
        elevation: 0,
        centerTitle: true,
        title: QiblaTitleOrnament(title: l10n.qiblaScreenTitle),
      ),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        children: [
          QiblaRouteCard(distanceKm: state.distanceKm!, originLabel: state.originLabel),
          const SizedBox(height: 8),
          AnimatedCalibrationBanner(show: showCalibration),
          const SizedBox(height: 12),
          QiblaCompassArea(state: state),
          const SizedBox(height: 22),
          QiblaLevelIndicator(tiltX: state.tiltX),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              AppLocalizations.of(context)!.qiblaFlatSurfaceCaption,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.sage.withValues(alpha: 0.7), fontSize: 9, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
