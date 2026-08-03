// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure timing math for the word-by-word greeting reveal: each word
// scales up from small/distant to full size, the whole phrase holds,
// then continues scaling past the viewer while fading out.

import 'package:flutter/material.dart';

import '../../constants/splash_config.dart';

/// Scale + opacity of one greeting word at a point in time.
@immutable
class GreetingWordFrame {
  const GreetingWordFrame({required this.scale, required this.opacity});

  final double scale;
  final double opacity;

  static const hidden = GreetingWordFrame(scale: 0, opacity: 0);
}

/// Computes [GreetingWordFrame]s from the shared cosmic elapsed clock.
abstract final class GreetingTimeline {
  /// Time (seconds) at which every word has finished appearing and the
  /// phrase begins its shared hold.
  static double _appearEnd(int wordCount) =>
      SplashConfig.wordStaggerSeconds * (wordCount - 1) +
      SplashConfig.wordAppearDurationSeconds;

  /// Time (seconds) at which the shared exit (scale-through + fade)
  /// begins, common to every word regardless of its own reveal time.
  static double exitStart(int wordCount) =>
      _appearEnd(wordCount) + SplashConfig.holdDurationSeconds;

  /// Frame for word [index] (0-based) of [wordCount] words at time [t].
  static GreetingWordFrame frameFor(int index, int wordCount, double t) {
    final wordStart = SplashConfig.wordStaggerSeconds * index;
    if (t < wordStart) return GreetingWordFrame.hidden;

    final appearEnd = wordStart + SplashConfig.wordAppearDurationSeconds;
    final exitStartT = exitStart(wordCount);

    if (t < appearEnd) {
      final progress =
          Curves.easeOut.transform((t - wordStart) / (appearEnd - wordStart));
      return GreetingWordFrame(
        scale: _lerp(SplashConfig.wordSmallScale, 1.0, progress),
        opacity: progress,
      );
    }

    if (t < exitStartT) return const GreetingWordFrame(scale: 1, opacity: 1);

    final exitProgress = ((t - exitStartT) / SplashConfig.exitDurationSeconds)
        .clamp(0.0, 1.0);
    final eased = Curves.easeIn.transform(exitProgress);
    return GreetingWordFrame(
      scale: _lerp(1.0, SplashConfig.wordFarScale, eased),
      opacity: 1.0 - eased,
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}
