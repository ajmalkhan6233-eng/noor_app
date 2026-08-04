// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/collapsing_scaffold.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import '../data/prayer_settings.dart';
import '../data/prayer_times_result.dart';
import '../logic/prayer_cubit/prayer_cubit.dart';
import '../logic/prayer_cubit/prayer_state.dart';
import 'monthly_timetable_screen.dart';
import 'widgets/district_selector.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PrayerCubit()..loadSettings()),
        BlocProvider(create: (_) => SettingsCubit()..load()),
      ],
      child: const _PrayerTimesView(),
    );
  }
}

class _PrayerTimesView extends StatelessWidget {
  const _PrayerTimesView();

  void _openMonthlyTimetable(BuildContext context, PrayerState state) {
    if (!state.hasCoordinates) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MonthlyTimetableScreen(
          latitude: state.latitude!,
          longitude: state.longitude!,
          settings: state.settings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) => CollapsingScaffold(
        title: AppStrings.prayerTimesScreenTitle,
        actions: [
          Semantics(
            button: true,
            label: AppStrings.openMonthlyTimetableSemanticLabel,
            child: IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: state.hasCoordinates
                  ? () => _openMonthlyTimetable(context, state)
                  : null,
            ),
          ),
        ],
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: StaggeredFadeIn(
                children: [
                  _buildResult(state),
                  const SizedBox(height: 16),
                  const LocationSelector(),
                  const SizedBox(height: 16),
                  const DistrictSelector(),
                  const SizedBox(height: 16),
                  _activeSettingsCaption(state.settings),
                ],
              ),
            ),
          ),
        ],
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
          PrayerTimesList(times: result, iqamathOffsets: state.iqamathOffsets),
        ],
      ),
    };
  }
}
