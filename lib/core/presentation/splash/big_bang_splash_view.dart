// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The "Big Bang" splash: a gold/cyan particle burst expands from the
// screen's centre and settles, and the Allah calligraphy + greeting
// fade in over the burst's back half — Cosmic Expansion's entry
// point. Falls back to the calm, still PlainSplashView under reduced
// motion (a burst has no meaningful "settled" instant to jump to).

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/splash_config.dart';
import '../../effects/particle_burst_painter.dart';
import '../motion/motion.dart';
import '../widgets/allah_calligraphy.dart';
import 'plain_splash_view.dart';

class BigBangSplashView extends StatefulWidget {
  const BigBangSplashView({super.key});

  @override
  State<BigBangSplashView> createState() => _BigBangSplashViewState();
}

class _BigBangSplashViewState extends State<BigBangSplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  List<BurstParticle>? _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SplashConfig.burstDuration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
        final maxDistance = constraints.shortestSide * 0.42;
        _particles ??= BurstParticle.generate(1.0, maxDistance: maxDistance);
        return Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: ParticleBurstPainter(
                  center: center,
                  progress: _controller.value,
                  particles: _particles!,
                  color: AppColors.gold,
                  softColor: AppColors.accentSecondary,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Settles in over the burst's back half, so the
                // greeting arrives as the particles dissolve rather
                // than competing with them.
                final opacity = ((_controller.value - 0.5) / 0.5).clamp(
                  0.0,
                  1.0,
                );
                return Opacity(opacity: opacity, child: child);
              },
              child: Semantics(
                label: AppStrings.splashGreeting,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AllahCalligraphy(fontSize: 56),
                      SizedBox(height: 24),
                      Text(
                        AppStrings.splashGreeting,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
