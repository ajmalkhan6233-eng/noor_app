// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Qibla screen, rebuilt 2026-08-30 per the approved mockup: a route/
// distance card with a plane travelling toward Makkah, the redesigned
// compass dial, an "aligned" pill (not a dialog), a compact level
// indicator, and a caption — no full-screen calibration takeover
// (FR-9's honest low-accuracy warning is still shown, just as a small
// pill via AnimatedCalibrationBanner, same as before this rebuild).
//
// 2026-09-02: real flicker root cause found. qibla_sensor_binder.dart
// emits on every raw compass/tilt reading, uncapped — the Aug 30 fix
// only isolated the needle/badge's own repaint
// (compass_needle_and_badge.dart), but this screen's outer BlocBuilder
// had no buildWhen at all, so the WHOLE screen (route card, banner,
// caption, level indicator) still rebuilt at raw sensor speed. Fixed
// by scoping: the outer BlocBuilder below now ignores
// headingDegrees/tiltX/tiltY entirely (ships those to the two widgets
// that actually need per-tick updates — QiblaCompassArea and
// QiblaLevelIndicator — each wired to the cubit directly with its own
// narrow buildWhen/BlocSelector, decoupled from this outer rebuild).

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
        // Explicitly ignores the raw-sensor-churn fields — heading and
        // both tilt axes — so this rebuild only fires a handful of
        // times per screen visit, not on every compass/accelerometer
        // tick. QiblaCompassArea and QiblaLevelIndicator each read
        // those fields live from their own narrow builder below.
        buildWhen: (previous, current) =>
            previous.locationError != current.locationError ||
            previous.bearingDegrees != current.bearingDegrees ||
            previous.distanceKm != current.distanceKm ||
            previous.isResolvingLocation != current.isResolvingLocation ||
            previous.displayAccuracy != current.displayAccuracy ||
            previous.originLabel != current.originLabel,
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
          const QiblaCompassArea(),
          const SizedBox(height: 22),
          BlocSelector<QiblaCubit, QiblaState, double>(
            selector: (state) => state.tiltX,
            builder: (context, tiltX) => QiblaLevelIndicator(tiltX: tiltX),
          ),
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
