// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The "Big Bang" splash: a gold/cyan particle burst expands from the
// screen's centre; the Arabic Bismillah forms over its back half,
// scaling in from depth (as if arriving from behind the screen, not
// a flat fade); then it dissolves into the "NOOR" wordmark, which is
// the last thing on screen before the dashboard. No English text
// appears before the Arabic anywhere in this sequence — live-device
// review (2026-08-24) explicitly asked for that ordering. Falls back
// to the calm, still PlainSplashView under reduced motion (a burst —
// or a dissolve — has no meaningful "settled" instant to jump to).

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_typography.dart';
import '../../constants/splash_config.dart';
import '../../effects/particle_burst_painter.dart';
import '../motion/motion.dart';
import '../widgets/noor_splash_wordmark.dart';
import 'plain_splash_view.dart';

class BigBangSplashView extends StatefulWidget {
  const BigBangSplashView({super.key});

  @override
  State<BigBangSplashView> createState() => _BigBangSplashViewState();
}

class _BigBangSplashViewState extends State<BigBangSplashView>
    with TickerProviderStateMixin {
  late final AnimationController _burstController;
  late final AnimationController _dissolveController;
  List<BurstParticle>? _particles;

  @override
  void initState() {
    super.initState();
    _burstController = AnimationController(
      vsync: this,
      duration: SplashConfig.burstDuration,
    )..forward();
    _dissolveController = AnimationController(
      vsync: this,
      duration: SplashConfig.dissolveDuration,
    );
    Future<void>.delayed(
      SplashConfig.burstDuration + SplashConfig.bismillahHoldDuration,
      () {
        if (mounted) _dissolveController.forward();
      },
    );
  }

  @override
  void dispose() {
    _burstController.dispose();
    _dissolveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduced(context)) return const PlainSplashView();

    return LayoutBuilder(
      builder: (context, constraints) {
        final center = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );
        // Screen-derived so the burst reads as a genuine expansion on
        // every device size, not a fixed-size sparkle lost on a large
        // screen. Cached (not regenerated every build) so the particle
        // set stays stable across the animation.
        final maxDistance = math.min(constraints.maxWidth, constraints.maxHeight) * 0.42;
        _particles ??= BurstParticle.generate(1.0, maxDistance: maxDistance);
        return Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _burstController,
              builder: (context, _) => CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: ParticleBurstPainter(
                  center: center,
                  progress: _burstController.value,
                  particles: _particles!,
                  color: AppColors.gold,
                  softColor: AppColors.accentSecondary,
                  growing: true,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: Listenable.merge([_burstController, _dissolveController]),
              builder: (context, child) {
                // Bismillah settles in over the burst's back half —
                // scaling down from depth rather than a flat fade —
                // then fades out as the dissolve begins.
                final burstIn = ((_burstController.value - 0.5) / 0.5).clamp(0.0, 1.0);
                final dissolveOut = 1.0 - _dissolveController.value;
                final opacity = burstIn * dissolveOut;
                final scale = 1.0 + (1.0 - burstIn) * 0.35;
                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: Semantics(
                label: AppStrings.splashGreetingSemanticLabel,
                child: const ExcludeSemantics(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      AppStrings.splashGreeting,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTypography.arabicFamily,
                        color: AppColors.gold,
                        fontSize: 30,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _dissolveController,
              builder: (context, child) {
                // NOOR arrives from the same "coming from behind"
                // depth treatment, timed to the dissolve rather than
                // a flat fade-in.
                final opacity = _dissolveController.value;
                final scale = 0.85 + (opacity * 0.15);
                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: const NoorSplashWordmark(),
            ),
          ],
        );
      },
    );
  }
}
