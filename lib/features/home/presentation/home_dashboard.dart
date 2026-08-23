// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The app shell shown after the splash: persistent top bar (AppTopBar)
// plus bottom navigation across Home / Prayer Times / Al Quran / Duas
// & Dhikr / More (NoorBottomNav). Each tab's icon carries an explicit
// Semantics label independent of its visible text label.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/motion/fade_tab_switcher.dart';
import '../../../core/presentation/widgets/cosmic_background.dart';
import '../../azkar/presentation/azkar_screen.dart';
import '../../more/presentation/more_screen.dart';
import '../../prayer_times/logic/adhan_preview_cubit.dart';
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

  // The nav dock compresses while the active tab's content scrolls
  // down (more to read, chrome should get out of the way) and
  // expands again on scroll-up or a tap — a single listener here
  // catches scroll notifications bubbling up from whichever tab's
  // scrollable is currently active, rather than wiring each of the
  // 5 tabs' own ScrollControllers individually.
  var _navExpanded = true;

  bool _onScrollNotification(UserScrollNotification notification) {
    final direction = notification.direction;
    if (direction == ScrollDirection.reverse && _navExpanded) {
      setState(() => _navExpanded = false);
    } else if (direction == ScrollDirection.forward && !_navExpanded) {
      setState(() => _navExpanded = true);
    }
    return false;
  }

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
      ],
      child: Stack(
        children: [
          // The persistent particle layer every tab sits on top of —
          // painted once here, not per-screen, so switching tabs never
          // restarts its drift.
          const Positioned.fill(child: CosmicBackground()),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const AppTopBar(),
            body: NotificationListener<UserScrollNotification>(
              onNotification: _onScrollNotification,
              child: FadeTabSwitcher(index: _selectedIndex, children: _screens),
            ),
            bottomNavigationBar: NoorBottomNav(
              selectedIndex: _selectedIndex,
              expanded: _navExpanded,
              onTap: (index) => setState(() {
                _selectedIndex = index;
                _navExpanded = true;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
