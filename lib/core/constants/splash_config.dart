// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Tunables for the launch splash: a gold/cyan particle burst
// ("Big Bang") from centre, settling into the Allah calligraphy —
// the Cosmic Expansion art direction's entry point. Falls back to
// PlainSplashView (a calm, still greeting, no motion) under reduced
// motion — see BigBangSplashView.

abstract final class SplashConfig {
  /// How long the burst takes to fully expand and fade, and for the
  /// Bismillah to settle in over its back half.
  ///
  /// This value has swung three times across live-device passes, each
  /// time chasing the previous pass's overcorrection rather than a
  /// number pulled from nowhere: 2026-08-25 cut it in half (felt too
  /// slow); 2026-08-28 doubled it back plus added real easing curves
  /// (the cut, combined with zero easing anywhere, made it feel both
  /// slow AND mechanical — snapping rather than settling); later the
  /// same day, with easing already in place, the total sequence had
  /// crept to 4-5 real seconds and needed to come back down under
  /// 2.5s total. The fix each time was the SHAPE of the motion
  /// (easing) plus the TOTAL budget below, not this one number in
  /// isolation — keep that in mind before changing it again alone.
  static const Duration burstDuration = Duration(milliseconds: 500);

  /// How long the Bismillah holds alone, after the burst settles and
  /// before it starts dissolving into the NOOR wordmark. Needs to be
  /// long enough to actually register as "there for a moment" (250ms
  /// was too little) without blowing the ~2.5s total budget (500ms
  /// was too much, once the native Android splash screen and Flutter
  /// engine startup on top of this Dart-side sequence are accounted
  /// for — a real device felt "4-5 seconds" total, not the ~2.4s this
  /// Dart-side number alone would suggest).
  static const Duration bismillahHoldDuration = Duration(milliseconds: 350);

  /// How long the Bismillah-to-NOOR crossfade takes.
  static const Duration dissolveDuration = Duration(milliseconds: 450);

  /// How long the whole sequence (splash screen mounted -> caller's
  /// onFinished) holds before fading into the dashboard. Must clear
  /// burstDuration + bismillahHoldDuration + dissolveDuration with
  /// enough left over for NOOR to sit alone briefly. Combined with
  /// [fadeDuration] below, this Dart-side sequence now totals ~1.95s —
  /// under the 2.5s ceiling with margin for whatever the native splash
  /// screen adds on top before Dart even starts.
  static const Duration holdDuration = Duration(milliseconds: 1700);

  /// Fade-in and fade-out duration for the whole splash (reduced-
  /// motion path only for the fade-*in* — the burst path fades itself
  /// in via [burstDuration] — but this also drives the real fade-*out*
  /// into the dashboard for every user, motion-reduced or not).
  static const Duration fadeDuration = Duration(milliseconds: 250);
}
