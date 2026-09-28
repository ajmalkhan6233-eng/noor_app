// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Launch sequence, drawn by Flutter after the plain-obsidian OS splash:
// the app icon (crisp, from design/noor_icon_master.png) fades to the
// gold NOOR wordmark, then the Bismillah, then the Assalamu Alaikum
// greeting. One controller drives four overlapping opacity windows, so
// each step crossfades into the next and there is never an empty frame.
// The strong glow is splash-only — in-app glows stay soft. Reduced
// motion falls back to the still PlainSplashView.

import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../constants/app_color_tokens.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_typography.dart';
import '../../constants/splash_config.dart';
import '../motion/motion.dart';
import '../widgets/noor_splash_wordmark.dart';
import 'plain_splash_view.dart';

class NoorSequenceSplashView extends StatefulWidget {
  const NoorSequenceSplashView({super.key});

  @override
  State<NoorSequenceSplashView> createState() => _NoorSequenceSplashViewState();
}

class _NoorSequenceSplashViewState extends State<NoorSequenceSplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: SplashConfig.sequenceDuration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Opacity window: rises over [inA, inB], falls over [outA, outB].
  double _window(double inA, double inB, double outA, double outB) {
    final t = _controller.value;
    final up = ((t - inA) / (inB - inA)).clamp(0.0, 1.0);
    final down = outA >= 1 ? 0.0 : ((t - outA) / (outB - outA)).clamp(0.0, 1.0);
    return Curves.easeInOut.transform(up) *
        (1 - Curves.easeInOut.transform(down));
  }

  List<Shadow> _glow(Color c, double blur) => [
        Shadow(color: c.withValues(alpha: 0.85), blurRadius: blur),
        Shadow(color: c.withValues(alpha: 0.45), blurRadius: blur * 2),
      ];

  @override
  Widget build(BuildContext context) {
    if (Motion.reduced(context)) return const PlainSplashView();
    final colors = context.colors;
    final greeting = AppLocalizations.of(context)!.assalamuAlaikumGreeting;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final icon = _window(0.0, 0.12, 0.26, 0.38);
        final noor = _window(0.28, 0.40, 0.50, 0.62);
        final bismillah = _window(0.52, 0.64, 0.74, 0.84);
        final salam = _window(0.76, 0.88, 1.1, 1.2);
        return SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: icon,
                child: Container(
                  width: 168,
                  height: 168,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38),
                    boxShadow: [
                      BoxShadow(
                          color: colors.gold.withValues(alpha: 0.55),
                          blurRadius: 60,
                          spreadRadius: 6),
                      BoxShadow(
                          color: colors.accentSecondary.withValues(alpha: 0.25),
                          blurRadius: 90,
                          spreadRadius: 10),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(38),
                    child: Image.asset(
                      'design/noor_icon_master.png',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
              Opacity(
                  opacity: noor, child: const NoorSplashWordmark(glow: true)),
              Opacity(
                opacity: bismillah,
                child: Text(
                  AppStrings.splashGreeting,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.arabicFamily,
                    fontSize: 30,
                    height: 1.6,
                    color: colors.gold,
                    shadows: _glow(colors.gold, 22),
                  ),
                ),
              ),
              Opacity(
                opacity: salam,
                child: Text(
                  greeting,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.displayFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: colors.ink,
                    shadows: _glow(colors.gold, 26),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
