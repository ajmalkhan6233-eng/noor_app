// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'core/app_locale_controller.dart';
import 'core/app_theme_controller.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'core/constants/app_theme_emerald.dart';
import 'core/constants/app_theme_mushaf.dart';
import 'core/constants/app_color_tokens_simple.dart';
import 'core/visual_style_controller.dart';
import 'features/settings/data/app_theme_mode.dart';
import 'core/presentation/app_scroll_behavior.dart';
import 'core/presentation/location_onboarding_screen.dart';
import 'core/presentation/splash_screen.dart';
import 'features/home/presentation/home_dashboard.dart';
import 'features/settings/data/app_locale.dart';
import 'features/settings/data/settings_repository.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/utils/app_builder.dart';

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

  /// True while the half-second Bismillah + Noor screen shows; it shows
  /// on every cold start now (no 24 h gate, no extra prefs read).
  bool _showSplash = true;
  bool _onboardingPushed = false;

  @override
  void initState() {
    super.initState();
    SettingsRepository().load().then((settings) {
      // Only seed the controller if Settings hasn't already changed it
      // (e.g. a fast theme switch while this future was pending).
      if (AppThemeController.instance.themeMode.value == null) {
        AppThemeController.instance.apply(settings.themeMode);
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
            return ValueListenableBuilder<bool>(
              valueListenable: VisualStyleController.instance.rich,
              builder: (context, rich, _) => ValueListenableBuilder<AppThemeModeOption>(
              valueListenable: AppThemeController.instance.option,
              builder: (context, option, _) => MaterialApp(
              navigatorKey: _navigatorKey,
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              scrollBehavior: AppScrollBehavior(),
              // Simple look (default) follows the phone's light/dark.
              themeMode: rich ? (themeMode ?? ThemeMode.dark) : ThemeMode.system,
              themeAnimationDuration: const Duration(milliseconds: 300),
              themeAnimationCurve: Curves.easeInOut,
              darkTheme: !rich
                  ? buildAppTheme(appColorTokensSimpleDark)
                  : option == AppThemeModeOption.emeraldNight
                      ? buildEmeraldTheme()
                      : buildDarkTheme(),
              theme: !rich
                  ? buildAppTheme(appColorTokensSimpleLight)
                  : option == AppThemeModeOption.mushaf
                      ? buildMushafTheme()
                      : buildLightTheme(),
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) =>
                  noorAppBuilder(context, child, reduceMotion: !rich),
              home: _showSplash
                  ? SplashScreen(onFinished: _onSplashFinished)
                  : const HomeDashboard(),
              ),
              ),
            );
          },
        );
      },
    );
  }
}

