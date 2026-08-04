// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The main dashboard shown after the splash: a single app bar (title
// follows the active tab, plus a Settings action) over bottom
// navigation across all five feature screens. Each tab's icon carries
// an explicit Semantics label independent of its visible text label.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/presentation/motion/fade_tab_switcher.dart';
import '../../azkar/presentation/azkar_screen.dart';
import '../../prayer_times/presentation/prayer_times_screen.dart';
import '../../qibla/presentation/qibla_screen.dart';
import '../../quran/presentation/quran_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../tasbih/presentation/tasbih_screen.dart';

/// Home dashboard: bottom-navigable Prayer Times / Qibla / Quran /
/// Azkar / Tasbih, with Settings reachable from every tab's app bar.
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  static const _titles = [
    AppStrings.prayerTimesScreenTitle,
    AppStrings.qiblaScreenTitle,
    AppStrings.quranScreenTitle,
    AppStrings.azkarScreenTitle,
    AppStrings.tasbihScreenTitle,
  ];

  static const _screens = [
    PrayerTimesScreen(),
    QiblaScreen(),
    QuranScreen(),
    AzkarScreen(),
    TasbihScreen(),
  ];

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(_titles[_selectedIndex]),
        actions: [
          Semantics(
            label: AppStrings.settingsSemanticLabel,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: AppStrings.settingsSemanticLabel,
              onPressed: _openSettings,
            ),
          ),
        ],
      ),
      body: FadeTabSwitcher(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.ink,
          border: Border(top: BorderSide(color: AppColors.hairline)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.ink,
          elevation: 0,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.sage,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: [
            _tab(Icons.access_time, AppStrings.prayerTimesScreenTitle),
            _tab(Icons.explore, AppStrings.qiblaScreenTitle),
            _tab(Icons.menu_book, AppStrings.quranScreenTitle),
            _tab(Icons.self_improvement, AppStrings.azkarScreenTitle),
            _tab(Icons.fingerprint, AppStrings.tasbihScreenTitle),
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
