// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The app shell shown after the splash: persistent top bar (AppTopBar)
// plus bottom navigation across Home / Prayer Times / Al Quran / Duas
// & Dhikr / More (NoorBottomNav). Each tab's icon carries an explicit
// Semantics label independent of its visible text label.
//
// NOTE: CosmicBackground + a Stack/NotificationListener wrapper here
// were tried and reverted in the same session — wiring the persistent
// particle layer behind this shell broke Home tab rendering in CI
// (HeroCard and the build-stamp text stopped being found by 3
// different widget tests, reproducibly, across multiple attempts)
// without a working local Flutter install available to debug it
// interactively. Reverted to protect the release per CLAUDE.md's
// "Update & Release Safety" rule (tests must be green before tagging)
// rather than ship red or guess further blind. CosmicBackground itself
// (lib/core/presentation/widgets/cosmic_background.dart) is untouched
// and still valid, standalone, working code — it just isn't wired in
// here. Needs someone with local Flutter tooling to find the actual
// interaction and re-wire it properly.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/fade_tab_switcher.dart';
import '../../azkar/presentation/azkar_screen.dart';
import '../../more/presentation/more_screen.dart';
import '../../prayer_times/logic/adhan_preview_cubit.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../prayer_times/presentation/prayer_times_screen.dart';
import '../../prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import '../../quran/presentation/quran_screen.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import 'home_overview_screen.dart';
import 'widgets/bottom_nav/noor_bottom_nav.dart';
import 'widgets/top_bar/app_top_bar.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  static const _screens = [
    HomeOverviewScreen(),
    PrayerTimesScreen(),
    QuranScreen(),
    AzkarScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PrayerCubit()..loadSettings()),
        BlocProvider(create: (_) => SettingsCubit()..load()),
        BlocProvider(create: (_) => AdhanPreviewCubit()),
        // Shared by Home's DailyGoalsList and Prayer Times'
        // PrayerTrackerCard — one instance so marking a prayer done on
        // either tab shows up on the other immediately, instead of
        // each tab holding its own stale copy.
        BlocProvider(create: (_) => PrayerTrackerCubit()..load()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.paper,
        appBar: const AppTopBar(),
        body: FadeTabSwitcher(index: _selectedIndex, children: _screens),
        // expanded defaults true, so the dock always shows labels for
        // now — the scroll-driven compress/expand logic in
        // NoorBottomNav/NavTabItem is intact and ready to be driven
        // again once the background-layer interaction is diagnosed.
        bottomNavigationBar: NoorBottomNav(
          selectedIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
