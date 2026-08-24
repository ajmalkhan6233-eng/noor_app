// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/collapsing_scaffold.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../prayer_tracker/presentation/widgets/prayer_tracker_card.dart';
import '../data/prayer_settings.dart';
import '../data/prayer_times_result.dart';
import '../logic/prayer_cubit/prayer_cubit.dart';
import '../logic/prayer_cubit/prayer_state.dart';
import 'monthly_timetable_screen.dart';
import 'widgets/high_latitude_notice.dart';
import 'widgets/location_selector.dart';
import 'widgets/prayer_hero.dart';
import 'widgets/prayer_loading_skeleton.dart';
import 'widgets/prayer_times_list.dart';

/// Prayer-times screen — the app's hero screen: the astrolabe ring
/// and next-prayer countdown lead, then the day's five prayers plus
/// sunrise, then location entry, then the active method/madhab as a
/// quiet closing caption.
/// PrayerCubit and SettingsCubit are provided once by HomeDashboard
/// (the tab shell) and shared across every tab.
class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

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
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) => CollapsingScaffold(
        title: l10n.prayerTimesScreenTitle,
        actions: [
          Semantics(
            button: true,
            label: l10n.openMonthlyTimetableSemanticLabel,
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
                  _buildResult(context, state),
                  const SizedBox(height: 16),
                  const PrayerTrackerCard(),
                  const SizedBox(height: 16),
                  const LocationSelector(),
                  const SizedBox(height: 16),
                  _activeSettingsCaption(context, state.settings),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeSettingsCaption(BuildContext context, PrayerSettings settings) {
    final text = '${settings.method.label} · ${settings.madhab.label} madhab';
    return Center(
      child: Semantics(
        label: AppLocalizations.of(
          context,
        )!.activeCalculationSettingsLabel(text),
        child: Text(text, style: AppTypography.caption),
      ),
    );
  }

  Widget _buildResult(BuildContext context, PrayerState state) {
    final result = state.result;
    return switch (result) {
      null when state.isResolvingLocation => const PrayerLoadingSkeleton(),
      null => Center(
        child: Text(
          AppLocalizations.of(context)!.enterLocationPrompt,
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
