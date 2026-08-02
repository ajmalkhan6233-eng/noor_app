// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/presentation/splash_screen.dart';
import 'features/tasbih/presentation/tasbih_screen.dart';

/// Root widget: shows the splash screen, then fades into the main
/// dashboard (currently the Tasbih screen; prayer_times/quran/azkar
/// screens plug in the same way once built out).
class NoorApp extends StatefulWidget {
  const NoorApp({super.key});

  @override
  State<NoorApp> createState() => _NoorAppState();
}

class _NoorAppState extends State<NoorApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
        ),
      ),
      home: _showSplash
          ? SplashScreen(onFinished: () => setState(() => _showSplash = false))
          : const TasbihScreen(),
    );
  }
}
