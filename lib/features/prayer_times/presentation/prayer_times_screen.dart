// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../data/prayer_times_result.dart';
import '../logic/prayer_cubit/prayer_cubit.dart';
import '../logic/prayer_cubit/prayer_state.dart';
import 'widgets/high_latitude_notice.dart';
import 'widgets/location_selector.dart';
import 'widgets/method_madhab_selector.dart';
import 'widgets/next_prayer_countdown.dart';
import 'widgets/prayer_times_list.dart';

/// Prayer-times screen: location entry, method/madhab selection, and
/// either computed times + a countdown, or an explicit high-latitude
/// notice — never a fabricated time.
class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrayerCubit(),
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(AppStrings.prayerTimesScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const LocationSelector(),
            const SizedBox(height: 20),
            const MethodMadhabSelector(),
            const SizedBox(height: 20),
            BlocBuilder<PrayerCubit, PrayerState>(
              builder: (context, state) => _buildResult(state),
            ),
          ],
        ),
      ),
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
