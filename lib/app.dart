// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'core/app_locale_controller.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'core/presentation/app_scroll_behavior.dart';
import 'core/presentation/location_onboarding_screen.dart';
import 'core/presentation/splash_screen.dart';
import 'features/home/presentation/home_dashboard.dart';
import 'features/settings/data/app_locale.dart';
import 'features/settings/data/app_theme_mode.dart';
import 'features/settings/data/settings_repository.dart';
import 'l10n/generated/app_localizations.dart';

/// Root widget: shows the splash screen, then fades into the main
/// dashboard — bottom navigation across Prayer Times, Qibla, Quran,
/// Azkar, and Tasbih, with Settings reachable from its app bar.
class NoorApp extends StatefulWidget {
  const NoorApp({super.key});

  @override
  State<NoorApp> createState() => _NoorAppState();
}

class _NoorAppState extends State<NoorApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  bool _showSplash = true;
  bool _onboardingPushed = false;
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    SettingsRepository().load().then((settings) {
      if (mounted) {
        setState(() => _themeMode = settings.themeMode.flutterThemeMode);
      }
      // Only seed the controller if Settings hasn't already changed it
      // (e.g. a fast language switch while this future was pending).
      AppLocaleController.instance.locale.value ??= settings.locale.locale;
      if (!settings.hasSeenLocationOnboarding) _maybePushOnboarding();
    });
  }

  /// HomeDashboard mounts immediately once the splash finishes — never
  /// gated on this settings read, same as every other DB-backed widget
  /// in this app (which render right away and fill in once their own
  /// async load completes, rather than blocking). The one-time
  /// location screen is pushed as an overlay route on top instead,
  /// once both the splash is done and settings confirm it's actually
  /// needed — whichever finishes second. Pushed at most once per
  /// app session.
  void _maybePushOnboarding() {
    if (_onboardingPushed || _showSplash) return;
    _onboardingPushed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState?.push(
        MaterialPageRoute<void>(
          builder: (_) => LocationOnboardingScreen(
            onFinished: () => Navigator.of(_navigatorKey.currentContext!).pop(),
          ),
          fullscreenDialog: true,
        ),
      );
    });
  }

  void _onSplashFinished() {
    setState(() => _showSplash = false);
    // In case settings already resolved while splash was still up.
    SettingsRepository().load().then((settings) {
      if (mounted && !settings.hasSeenLocationOnboarding) _maybePushOnboarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: AppLocaleController.instance.locale,
      builder: (context, locale, _) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          themeMode: _themeMode,
          darkTheme: buildDarkTheme(),
          theme: buildLightTheme(),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: _showSplash
              ? SplashScreen(onFinished: _onSplashFinished)
              : const HomeDashboard(),
        );
      },
    );
  }
}
