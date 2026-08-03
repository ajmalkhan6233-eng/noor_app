// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Renders "BISMILLAHIR RAHMANIR RAHEEM" as individually-timed words
// driven by [GreetingTimeline], on top of the starfield.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_typography.dart';
import '../../constants/splash_config.dart';
import 'greeting_timeline.dart';

/// Word-by-word gold greeting overlay for the cosmic splash.
class GreetingOverlay extends StatelessWidget {
  GreetingOverlay({super.key, required this.elapsedSeconds})
    : words = AppStrings.splashGreeting.split(' ');

  final double elapsedSeconds;
  final List<String> words;

  @override
  Widget build(BuildContext context) {
    // One word per line, each in a generously-tall fixed-height row —
    // Transform.scale grows a word's paint bounds without affecting
    // layout, so without this a scaled word can bleed into whichever
    // neighbour shares its line. A tall dedicated row per word gives
    // that growth somewhere to go.
    return ExcludeSemantics(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < words.length; i++)
              SizedBox(
                height: SplashConfig.wordLineHeight,
                child: Center(child: _buildWord(i, words[i])),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWord(int index, String word) {
    final frame = GreetingTimeline.frameFor(
      index,
      words.length,
      elapsedSeconds,
    );
    if (frame.opacity <= 0) return const SizedBox.shrink();

    return Opacity(
      opacity: frame.opacity,
      child: Transform.scale(
        scale: frame.scale,
        child: Text(
          word,
          style: TextStyle(
            fontFamily: AppTypography.displayFamily,
            color: AppColors.gold,
            fontSize: SplashConfig.textFontSize,
            fontWeight: FontWeight.w300,
            letterSpacing: SplashConfig.textLetterSpacing,
            shadows: [
              Shadow(
                color: AppColors.gold.withValues(alpha: 0.25),
                blurRadius: SplashConfig.textShadowBlurRadius,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
