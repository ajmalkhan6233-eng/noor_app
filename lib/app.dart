// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'core/presentation/app_scroll_behavior.dart';
import 'core/presentation/splash_screen.dart';
import 'features/home/presentation/home_dashboard.dart';
import 'features/settings/data/app_theme_mode.dart';
import 'features/settings/data/settings_repository.dart';

/// Root widget: shows the splash screen, then fades into the main
/// dashboard — bottom navigation across Prayer Times, Qibla, Quran,
/// Azkar, and Tasbih, with Settings reachable from its app bar.
class NoorApp extends StatefulWidget {
  const NoorApp({super.key});

  @override
  State<NoorApp> createState() => _NoorAppState();
}

class _NoorAppState extends State<NoorApp> {
  bool _showSplash = true;
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    SettingsRepository().load().then((settings) {
      if (mounted) {
        setState(() => _themeMode = settings.themeMode.flutterThemeMode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      themeMode: _themeMode,
      darkTheme: buildDarkTheme(),
      theme: buildLightTheme(),
      home: _showSplash
          ? SplashScreen(onFinished: () => setState(() => _showSplash = false))
          : const HomeDashboard(),
    );
  }
}
