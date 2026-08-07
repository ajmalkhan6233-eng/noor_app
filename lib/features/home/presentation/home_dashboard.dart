// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The app shell shown after the splash: persistent top bar (AppTopBar)
// plus bottom navigation across Home / Prayer Times / Al Quran / Duas
// & Dhikr / More (NoorBottomNav). Each tab's icon carries an explicit
// Semantics label independent of its visible text label.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/fade_tab_switcher.dart';
import '../../azkar/presentation/azkar_screen.dart';
import '../../more/presentation/more_screen.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../prayer_times/presentation/prayer_times_screen.dart';
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
      ],
      child: Scaffold(
        backgroundColor: AppColors.paper,
        appBar: const AppTopBar(),
        body: FadeTabSwitcher(index: _selectedIndex, children: _screens),
        bottomNavigationBar: NoorBottomNav(
          selectedIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
