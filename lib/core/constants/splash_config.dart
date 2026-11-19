// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Launch screen timing (2026-11-19): a still Bismillah + Noor for about
// half a second, then Home. The old 4.2 s animated sequence is gone.

abstract final class SplashConfig {
  /// How long the still launch screen stays before fading out.
  static const Duration holdDuration = Duration(milliseconds: 450);

  /// Fade in and out of the launch screen.
  static const Duration fadeDuration = Duration(milliseconds: 120);
}
