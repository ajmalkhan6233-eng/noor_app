// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The "Big Bang" splash: a gold/cyan particle burst expands from the
// screen's centre, holds briefly, then dissolves into the "NOOR"
// wordmark, which is the last thing on screen before the dashboard.
// The Arabic Bismillah used to form over the burst's back half here —
// moved out entirely (2026-09-05, direct request) and now leads the
// "Assalamu Alaikum" greeting on Home instead (see hero_card.dart).
// Falls back to the calm, still PlainSplashView under reduced motion
// (a burst — or a dissolve — has no meaningful "settled" instant to
// jump to).

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/app_color_tokens.dart';
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
                  color: AppColorTokens.cosmic.gold,
                  softColor: AppColorTokens.cosmic.accentSecondary,
                  growing: true,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _dissolveController,
              builder: (context, child) {
                // NOOR arrives from the same "coming from behind"
                // depth treatment, timed to the dissolve rather than
                // a flat fade-in. Eased (2026-08-28: at the raw linear
                // rate this read as the wordmark snapping into place
                // rather than settling) — easeOutCubic front-loads the
                // motion and lets it coast to a stop instead of
                // arriving at a constant rate and just halting.
                //
                // Only the SECOND half of the dissolve belongs to
                // fading this in — this used to also cross-fade the
                // Bismillah reveal that lived here (removed 2026-09-05,
                // see this file's header), where the same span-mismatch
                // once caused a real, visible overlap (2026-08-29).
                final linear = ((_dissolveController.value - 0.5) / 0.5).clamp(0.0, 1.0);
                final t = Curves.easeOutCubic.transform(linear);
                final opacity = t;
                final scale = 0.85 + (t * 0.15);
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
