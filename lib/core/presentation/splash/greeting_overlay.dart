// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Renders "BISMILLAHIR RAHMANIR RAHEEM" as individually-timed words
// driven by [GreetingTimeline], on top of the starfield.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
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
    return ExcludeSemantics(
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            for (var i = 0; i < words.length; i++)
              _buildWord(context, i, words[i]),
          ],
        ),
      ),
    );
  }

  Widget _buildWord(BuildContext context, int index, String word) {
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
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: SplashConfig.textFontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: SplashConfig.textLetterSpacing,
          ),
        ),
      ),
    );
  }
}
