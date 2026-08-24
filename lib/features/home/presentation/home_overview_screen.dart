// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Home tab (Section 3 of the UI Structure Pass): hero card, streak
// capsule, next-prayer countdown capsule, Suhoor/Iftar row, Ayah of
// the Day card, daily spiritual goals list, quick actions, today's
// prayer list with notification toggles, and the build stamp.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/parallax_layer.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_state.dart';
import '../../prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import '../../prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_state.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../settings/logic/settings_cubit/settings_state.dart';
import '../../../l10n/generated/app_localizations.dart' show AppLocalizations;
import 'widgets/ayah_of_day_card.dart';
import 'widgets/daily_goals_list.dart';
import 'widgets/edit_location_dialog.dart';
import 'widgets/hero_card.dart';
import 'widgets/home_build_stamp.dart';
import 'widgets/location_label.dart';
import 'widgets/prayer_summary_section.dart';
import 'widgets/streak_capsule.dart';
import 'widgets/sunnah_fasting_card.dart';

/// PrayerCubit and SettingsCubit are provided once by HomeDashboard
/// (the tab shell) and shared across every tab, so location/settings
/// changes made anywhere (e.g. the top bar's location pill) are
/// immediately visible here too. PrayerTrackerCubit is Home-tab-local
/// (StreakCapsule and DailyGoalsList both read the one instance
/// provided below, so they never drift out of sync with each other).
class HomeOverviewScreen extends StatefulWidget {
  const HomeOverviewScreen({super.key});

  @override
  State<HomeOverviewScreen> createState() => _HomeOverviewScreenState();
}

class _HomeOverviewScreenState extends State<HomeOverviewScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _editLocation(BuildContext context, String? current) async {
    final result = await showEditLocationDialog(context, current: current);
    if (result != null && context.mounted) {
      await context.read<SettingsCubit>().setLocationLabel(
        result.trim().isEmpty ? null : result.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrayerTrackerCubit()..load(),
      child: Scaffold(
        backgroundColor: AppColors.paper,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settingsState) => BlocBuilder<PrayerCubit, PrayerState>(
                builder: (context, prayerState) => BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
                  builder: (context, trackerState) => ListView(
                    controller: _scrollController,
                    children: [
                      StaggeredFadeIn(
                        children: [
                          ParallaxLayer(
                            controller: _scrollController,
                            child: HeroCard(
                              locationLabel: resolveLocationLabel(
                                settingsState,
                                prayerState,
                                AppLocalizations.of(context)!,
                              ),
                              hijriOffsetDays: settingsState.settings.hijriOffsetDays,
                              onEditLocation: () => _editLocation(
                                context,
                                settingsState.settings.locationLabel,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          StreakCapsule(
                            streakDays: trackerState.prayerStreak,
                            completedCount: trackerState.completedPrayers.length,
                          ),
                          const SizedBox(height: 16),
                          SunnahFastingCard(
                            hijriOffsetDays: settingsState.settings.hijriOffsetDays,
                          ),
                          const SizedBox(height: 16),
                          PrayerSummarySection(state: prayerState, settingsState: settingsState),
                          const SizedBox(height: 20),
                          AyahOfDayCard(),
                          const SizedBox(height: 20),
                          const DailyGoalsList(),
                          const SizedBox(height: 16),
                          const HomeBuildStamp(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
