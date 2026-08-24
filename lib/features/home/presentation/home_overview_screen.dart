// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Home tab: hero card, Sunnah fasting card (when it applies),
// next-prayer countdown capsule, Suhoor/Iftar row, today's prayer
// list, Ayah of the Day card, and the build stamp. The streak
// tracker (StreakCapsule, daily-goal checkboxes) is cut from v1 — see
// CLAUDE.md's Deferred section (2026-08-23) — and stays off Home;
// PrayerTrackerCubit is still shared with Prayer Times' own tracker
// card via HomeDashboard's provider, this screen just doesn't read it.

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
import 'widgets/hero_card.dart';
import 'widgets/home_build_stamp.dart';
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
                      const SizedBox(height: 16),
                      SunnahFastingCard(
                        hijriOffsetDays: settingsState.settings.hijriOffsetDays,
                      ),
                      const SizedBox(height: 16),
                      PrayerSummarySection(state: prayerState, settingsState: settingsState),
                      const SizedBox(height: 20),
                      AyahOfDayCard(),
                      const SizedBox(height: 20),
                      const HomeBuildStamp(),
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
