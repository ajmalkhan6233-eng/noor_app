// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Launch screen: BigBangSplashView's particle burst plays, holds,
// then this fades out and calls [onFinished] so the caller can swap
// in the dashboard.

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/splash_config.dart';
import 'splash/big_bang_splash_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});

  /// Called once the splash sequence completes; the caller should
  /// swap in the main dashboard at that point.
  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: SplashConfig.fadeDuration,
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
    Future<void>.delayed(SplashConfig.holdDuration, _fadeOut);
  }

  Future<void> _fadeOut() async {
    if (!mounted) return;
    await _fadeController.reverse();
    if (mounted) widget.onFinished();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Semantics(
        label: AppStrings.splashGreeting,
        child: FadeTransition(
          opacity: _fade,
          child: const BigBangSplashView(),
        ),
      ),
    );
  }
}
