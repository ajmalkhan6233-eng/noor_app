// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Home tab, reordered per the 2026-08-24 live-device review:
// greeting once, live clock, the astrolabe countdown ring (moved here
// from Prayer Times), the smart iqamah line, the full prayer-times
// row, today's prayer checklist, Sunnah fasting (moved down from
// where it used to lead), then Ayah of the Day last. The debug build
// stamp moved to the About screen — see BuildStampFooter.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/parallax_layer.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_state.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../settings/logic/settings_cubit/settings_state.dart';
import 'widgets/ayah_of_day_card.dart';
import 'widgets/daily_goals_list.dart';
import 'widgets/hero_card.dart';
import 'widgets/home_quick_toggles.dart';
import 'widgets/live_clock.dart';
import 'widgets/prayer_summary_section.dart';
import 'widgets/sunnah_fasting_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) => BlocBuilder<PrayerCubit, PrayerState>(
              builder: (context, prayerState) => ListView(
                controller: _scrollController,
                children: [
                  StaggeredFadeIn(
                    children: [
                      ParallaxLayer(
                        controller: _scrollController,
                        child: HeroCard(
                          hijriOffsetDays: settingsState.settings.hijriOffsetDays,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const LiveClock(),
                      const SizedBox(height: 12),
                      const HomeQuickToggles(),
                      const SizedBox(height: 12),
                      PrayerSummarySection(state: prayerState, settingsState: settingsState),
                      const SizedBox(height: 20),
                      const DailyGoalsList(),
                      const SizedBox(height: 16),
                      SunnahFastingCard(
                        hijriOffsetDays: settingsState.settings.hijriOffsetDays,
                      ),
                      const SizedBox(height: 20),
                      AyahOfDayCard(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
