// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Tunables for the launch splash: a gold/cyan particle burst
// ("Big Bang") from centre, settling into the Allah calligraphy —
// the Cosmic Expansion art direction's entry point. Falls back to
// PlainSplashView (a calm, still greeting, no motion) under reduced
// motion — see BigBangSplashView.

abstract final class SplashConfig {
  /// How long the burst takes to fully expand and fade.
  static const Duration burstDuration = Duration(milliseconds: 900);

  /// How long the greeting holds once settled, before fading into the
  /// dashboard.
  static const Duration holdDuration = Duration(milliseconds: 1400);

  /// Fade-in and fade-out duration for the whole splash (reduced-
  /// motion path only — the burst path fades itself in via
  /// [burstDuration]).
  static const Duration fadeDuration = Duration(milliseconds: 500);
}
