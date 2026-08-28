// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of big_bang_splash_view.dart to stay under the 150-line-
// per-file rule. The Arabic Bismillah settling in over the particle
// burst's back half, then fading out as the dissolve into NOOR
// begins — see BigBangSplashView's own header for the full sequence.

import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';
import '../../constants/app_typography.dart';

class BismillahReveal extends StatelessWidget {
  const BismillahReveal({
    super.key,
    required this.burstController,
    required this.dissolveController,
  });

  final Animation<double> burstController;
  final Animation<double> dissolveController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([burstController, dissolveController]),
      builder: (context, child) {
        // Both ramps are eased (not the raw linear controller value)
        // so the settle reads as a graceful arrival rather than
        // snapping to full opacity/scale (2026-08-28 live-device
        // finding: every phase here was linear, which is what made a
        // merely-short duration also feel mechanical rather than just
        // brisk).
        final burstInLinear = ((burstController.value - 0.5) / 0.5).clamp(0.0, 1.0);
        final burstIn = Curves.easeOutCubic.transform(burstInLinear);
        final dissolveOut = 1.0 - Curves.easeIn.transform(dissolveController.value);
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
                color: Color(0xFFFFB703),
                fontSize: 30,
                height: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
