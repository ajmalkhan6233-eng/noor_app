// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'core/app_locale_controller.dart';
import 'core/app_theme_controller.dart';
import 'core/constants/app_color_tokens.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'core/presentation/app_scroll_behavior.dart';
import 'core/presentation/location_onboarding_screen.dart';
import 'core/presentation/splash/splash_gate.dart';
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

  /// Null while [SplashGate] hasn't yet answered whether this open is
  /// recent enough to skip the splash — resolved before first frame in
  /// almost every real case, since it's one fast shared_preferences
  /// read, so there's nothing shown for that gap but a blank obsidian
  /// background (see [home] below).
  bool? _showSplash;
  bool _onboardingPushed = false;
  final _splashGate = SplashGate();

  @override
  void initState() {
    super.initState();
    _splashGate.shouldShowSplash().then((shouldShow) async {
      if (shouldShow) await _splashGate.markSplashShown();
      if (!mounted) return;
      setState(() => _showSplash = shouldShow);
      // A skipped splash never calls _onSplashFinished, so this is the
      // only place that triggers onboarding for that path.
      if (!shouldShow) _maybePushOnboarding();
    });
    SettingsRepository().load().then((settings) {
      // Only seed the controller if Settings hasn't already changed it
      // (e.g. a fast theme switch while this future was pending).
      AppThemeController.instance.themeMode.value ??=
          settings.themeMode.flutterThemeMode;
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
    if (_onboardingPushed || _showSplash != false) return;
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
        return ValueListenableBuilder<ThemeMode?>(
          valueListenable: AppThemeController.instance.themeMode,
          builder: (context, themeMode, _) {
            return MaterialApp(
              navigatorKey: _navigatorKey,
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              scrollBehavior: AppScrollBehavior(),
              themeMode: themeMode ?? ThemeMode.dark,
              darkTheme: buildDarkTheme(),
              theme: buildLightTheme(),
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              // 2026-08-26: general body/label text read as too small on
              // a real device. Most of the app sets explicit fontSizes
              // per-widget rather than through one shared scale, so a
              // single MediaQuery-level bump here reaches every screen
              // at once instead of hand-editing dozens of files —
              // composed on top of the OS accessibility text scale
              // rather than replacing it.
              builder: (context, child) {
                final mediaQuery = MediaQuery.of(context);
                final boosted = mediaQuery.textScaler.scale(1.0) * 1.15;
                return MediaQuery(
                  data: mediaQuery.copyWith(textScaler: TextScaler.linear(boosted)),
                  child: child!,
                );
              },
              home: switch (_showSplash) {
                null => const _SplashDecisionPlaceholder(),
                true => SplashScreen(onFinished: _onSplashFinished),
                false => const HomeDashboard(),
              },
            );
          },
        );
      },
    );
  }
}

/// Shown for the brief gap before [SplashGate] answers whether this
/// open should replay the intro — a blank obsidian screen rather than
/// any flash of the wrong choice (splash content, or the dashboard).
class _SplashDecisionPlaceholder extends StatelessWidget {
  const _SplashDecisionPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: context.colors.paper);
  }
}
