// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Tunables for the launch splash: a gold/cyan particle burst
// ("Big Bang") from centre, settling into the Allah calligraphy —
// the Cosmic Expansion art direction's entry point. Falls back to
// PlainSplashView (a calm, still greeting, no motion) under reduced
// motion — see BigBangSplashView.

abstract final class SplashConfig {
  /// How long the burst takes to fully expand and fade, and for the
  /// Bismillah to settle in over its back half. Cut roughly in half
  /// (2026-08-25 live-device review: "it should, like, in an instant
  /// ... coming up to the front" — the splash overall felt slow).
  static const Duration burstDuration = Duration(milliseconds: 500);

  /// How long the Bismillah holds alone, after the burst settles and
  /// before it starts dissolving into the NOOR wordmark.
  static const Duration bismillahHoldDuration = Duration(milliseconds: 300);

  /// How long the Bismillah-to-NOOR crossfade takes.
  static const Duration dissolveDuration = Duration(milliseconds: 350);

  /// How long the whole sequence (splash screen mounted -> caller's
  /// onFinished) holds before fading into the dashboard. Must clear
  /// burstDuration + bismillahHoldDuration + dissolveDuration with
  /// enough left over for NOOR to sit alone briefly, or the outer
  /// fade-out cuts the dissolve off mid-way.
  static const Duration holdDuration = Duration(milliseconds: 1450);

  /// Fade-in and fade-out duration for the whole splash (reduced-
  /// motion path only — the burst path fades itself in via
  /// [burstDuration]).
  static const Duration fadeDuration = Duration(milliseconds: 300);
}
