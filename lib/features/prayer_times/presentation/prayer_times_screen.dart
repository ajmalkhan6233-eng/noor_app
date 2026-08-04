// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../data/prayer_settings.dart';
import '../data/prayer_times_result.dart';
import '../logic/prayer_cubit/prayer_cubit.dart';
import '../logic/prayer_cubit/prayer_state.dart';
import 'widgets/high_latitude_notice.dart';
import 'widgets/location_selector.dart';
import 'widgets/prayer_hero.dart';
import 'widgets/prayer_times_list.dart';

/// Prayer-times screen — the app's hero screen: the astrolabe ring
/// and next-prayer countdown lead, then the day's five prayers plus
/// sunrise, then location entry, then the active method/madhab as a
/// quiet closing caption.
class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrayerCubit()..loadSettings(),
      child: const _PrayerTimesView(),
    );
  }
}

class _PrayerTimesView extends StatelessWidget {
  const _PrayerTimesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<PrayerCubit, PrayerState>(
            builder: (context, state) => ListView(
              children: [
                StaggeredFadeIn(
                  children: [
                    _buildResult(state),
                    const SizedBox(height: 16),
                    const LocationSelector(),
                    const SizedBox(height: 16),
                    _activeSettingsCaption(state.settings),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _activeSettingsCaption(PrayerSettings settings) {
    final text = '${settings.method.label} · ${settings.madhab.label} madhab';
    return Center(
      child: Semantics(
        label: 'Active calculation settings: $text',
        child: Text(text, style: AppTypography.caption),
      ),
    );
  }

  Widget _buildResult(PrayerState state) {
    final result = state.result;
    return switch (result) {
      null => const Center(
        child: Text(
          'Enter your location to see prayer times.',
          style: AppTypography.caption,
        ),
      ),
      HighLatitudeUnresolved() => const HighLatitudeNotice(),
      PrayerTimesComputed() => Column(
        children: [
          PrayerHero(times: result),
          const SizedBox(height: 20),
          PrayerTimesList(times: result),
        ],
      ),
    };
  }
}
