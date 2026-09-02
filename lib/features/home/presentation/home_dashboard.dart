// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The app shell shown after the splash: bottom navigation across
// Home / Prayer Times / Al Quran / Duas & Dhikr / More (NoorBottomNav),
// with the persistent cosmic particle background behind all 5 tabs.
// Each tab's icon carries an explicit Semantics label independent of
// its visible text label.
//
// No top bar here any more (2026-08-24 live-device review): the old
// AppTopBar carried only a settings gear, which duplicated the
// Settings row already on the More tab and cost every screen a
// stacked-on-top-of-its-own-AppBar row of vertical space for a
// control that already existed one tap away. Settings is reached from
// More only now.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/motion/fade_tab_switcher.dart';
import '../../../core/presentation/widgets/cosmic_background.dart';
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
import '../../../core/constants/app_color_tokens.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  // Only index 0 (Home) is ever visited at launch — the other 4 tabs'
  // screens (and the cubits/DB reads each one's own build() triggers:
  // QuranCubit.init(), AzkarCubit(), etc.) are deferred until the user
  // actually taps that tab, instead of all 5 firing at once on first
  // frame while only Home is visible (2026-09-02 startup profiling
  // pass). Once visited, a tab's real widget is always rebuilt at its
  // Stack position from then on — same widget, same key each time —
  // so FadeTabSwitcher's element reconciliation keeps its State (and
  // therefore its scroll position, search text, loaded data) exactly
  // as before; nothing about the "tabs never reset" guarantee changes
  // for a tab once it's actually been opened.
  final Set<int> _visitedIndices = {0};

  static const _screenBuilders = <Widget Function()>[
    _buildHome,
    _buildPrayerTimes,
    _buildQuran,
    _buildAzkar,
    _buildMore,
  ];

  static Widget _buildHome() => const HomeOverviewScreen();
  static Widget _buildPrayerTimes() => const PrayerTimesScreen();
  static Widget _buildQuran() => const QuranScreen();
  static Widget _buildAzkar() => const AzkarScreen();
  static Widget _buildMore() => const MoreScreen();

  void _onTabTap(int index) {
    setState(() {
      _selectedIndex = index;
      _visitedIndices.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      for (var i = 0; i < _screenBuilders.length; i++)
        _visitedIndices.contains(i) ? _screenBuilders[i]() : const SizedBox.shrink(),
    ];
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
        backgroundColor: context.colors.paper,
        body: Stack(
          children: [
            const Positioned.fill(child: CosmicBackground()),
            FadeTabSwitcher(index: _selectedIndex, children: screens),
          ],
        ),
        // expanded defaults true, so the dock always shows labels for
        // now — the scroll-driven compress/expand logic in
        // NoorBottomNav/NavTabItem is intact and ready to be driven
        // again once the background-layer interaction is diagnosed.
        bottomNavigationBar: NoorBottomNav(
          selectedIndex: _selectedIndex,
          onTap: _onTabTap,
        ),
      ),
    );
  }
}
