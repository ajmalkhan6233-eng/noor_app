// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The app shell shown after the splash: bottom navigation across
// Home / Prayer Times / Quran / Azkar / More. Each tab's icon carries
// an explicit Semantics label independent of its visible text label.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/fade_tab_switcher.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../azkar/presentation/azkar_screen.dart';
import '../../more/presentation/more_screen.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../prayer_times/presentation/prayer_times_screen.dart';
import '../../quran/presentation/quran_screen.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import 'home_overview_screen.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PrayerCubit()..loadSettings()),
        BlocProvider(create: (_) => SettingsCubit()..load()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.paper,
        appBar: const AppTopBar(),
        body: FadeTabSwitcher(index: _selectedIndex, children: _screens),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.paper,
            border: Border(top: BorderSide(color: AppColors.hairline)),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.paper,
            elevation: 0,
            selectedItemColor: AppColors.gold,
            unselectedItemColor: AppColors.sage,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: [
              _tab(Icons.home_outlined, l10n.homeTab),
              _tab(Icons.access_time, l10n.prayerTimesScreenTitle),
              _tab(Icons.menu_book, l10n.quranScreenTitle),
              _tab(Icons.self_improvement, l10n.azkarScreenTitle),
              _tab(Icons.more_horiz, l10n.moreTab),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _tab(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Semantics(label: label, child: Icon(icon)),
      label: label,
    );
  }
}
