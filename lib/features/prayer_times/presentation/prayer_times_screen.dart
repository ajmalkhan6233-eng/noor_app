// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../data/prayer_settings.dart';
import '../data/prayer_times_result.dart';
import '../logic/prayer_cubit/prayer_cubit.dart';
import '../logic/prayer_cubit/prayer_state.dart';
import 'widgets/high_latitude_notice.dart';
import 'widgets/location_selector.dart';
import 'widgets/next_prayer_countdown.dart';
import 'widgets/prayer_times_list.dart';

/// Prayer-times screen: location entry, and either computed times +
/// a countdown, or an explicit high-latitude notice — never a
/// fabricated time. Calculation method/madhab live in Settings.
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
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            BlocBuilder<PrayerCubit, PrayerState>(
              builder: (context, state) => _activeSettingsLabel(state.settings),
            ),
            const SizedBox(height: 12),
            const LocationSelector(),
            const SizedBox(height: 20),
            BlocBuilder<PrayerCubit, PrayerState>(
              builder: (context, state) => _buildResult(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activeSettingsLabel(PrayerSettings settings) {
    final text = '${settings.method.label} • ${settings.madhab.label} madhab';
    return Semantics(
      label: 'Active calculation settings: $text',
      child: Text(text, style: const TextStyle(color: AppColors.textSecondary)),
    );
  }

  Widget _buildResult(PrayerState state) {
    final result = state.result;
    return switch (result) {
      null => const Text(
        'Use your location or enter coordinates to see prayer times.',
        style: TextStyle(color: AppColors.textSecondary),
      ),
      HighLatitudeUnresolved() => const HighLatitudeNotice(),
      PrayerTimesComputed() => Column(
        children: [
          NextPrayerCountdown(times: result),
          PrayerTimesList(times: result),
        ],
      ),
    };
  }
}
