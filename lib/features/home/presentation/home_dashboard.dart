// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The app shell shown after the splash: bottom navigation across
// Home / Prayer Times / Quran / Azkar / More. Each tab's icon carries
// an explicit Semantics label independent of its visible text label.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/presentation/motion/fade_tab_switcher.dart';
import '../../azkar/presentation/azkar_screen.dart';
import '../../more/presentation/more_screen.dart';
import '../../prayer_times/presentation/prayer_times_screen.dart';
import '../../quran/presentation/quran_screen.dart';
import 'home_overview_screen.dart';

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
    return Scaffold(
      backgroundColor: AppColors.paper,
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
          selectedItemColor: AppColors.emerald,
          unselectedItemColor: AppColors.sage,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: [
            _tab(Icons.home_outlined, 'Home'),
            _tab(Icons.access_time, AppStrings.prayerTimesScreenTitle),
            _tab(Icons.menu_book, AppStrings.quranScreenTitle),
            _tab(Icons.self_improvement, AppStrings.azkarScreenTitle),
            _tab(Icons.more_horiz, 'More'),
          ],
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
