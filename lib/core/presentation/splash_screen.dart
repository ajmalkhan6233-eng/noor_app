// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Launch screen. Shows the cosmic sequence (or, when disabled via
// `SplashConfig.cosmicEnabled`, a plain still greeting) then calls
// [onFinished] so the caller can swap in the main dashboard.

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/splash_config.dart';
import 'splash/cosmic_splash_view.dart';
import 'splash/plain_splash_view.dart';

/// Entry-point splash widget; picks cosmic vs. plain per [SplashConfig].
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
  AnimationController? _plainFadeController;
  Animation<double>? _plainFade;

  @override
  void initState() {
    super.initState();
    if (SplashConfig.cosmicEnabled) {
      Future<void>.delayed(SplashConfig.totalDuration, _finish);
    } else {
      final controller = AnimationController(
        vsync: this,
        duration: SplashConfig.plainFadeDuration,
      );
      _plainFadeController = controller;
      _plainFade = CurvedAnimation(parent: controller, curve: Curves.easeIn);
      controller.forward();
      Future<void>.delayed(SplashConfig.plainHoldDuration, _fadeOutPlain);
    }
  }

  Future<void> _fadeOutPlain() async {
    if (!mounted) return;
    await _plainFadeController!.reverse();
    _finish();
  }

  void _finish() {
    if (mounted) widget.onFinished();
  }

  @override
  void dispose() {
    _plainFadeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Semantics(
        label: AppStrings.splashGreeting,
        child: SplashConfig.cosmicEnabled
            ? const CosmicSplashView()
            : FadeTransition(
                opacity: _plainFade!,
                child: const PlainSplashView(),
              ),
      ),
    );
  }
}
