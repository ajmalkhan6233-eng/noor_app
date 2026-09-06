// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Non-translatable constants: the app's name and the mandatory Arabic
// splash invocation, which must render identically regardless of the
// selected UI language (see `.clinerules` — religious text is never
// localized). Every translatable UI-chrome string lives in the ARB
// files under `lib/l10n/` and is read via `AppLocalizations`.

/// Static string constants for `noor`.
abstract final class AppStrings {
  /// App display name.
  static const String appName = 'noor';

  /// Mandatory splash-screen invocation, in Arabic script — copied
  /// verbatim from assets/quran/tanzil-uthmani.txt line "1|1" (Tanzil
  /// Uthmani script, Surah Al-Fatiha ayah 1), not re-typed from
  /// memory, per CLAUDE.md's Religious Content rule. Live-device
  /// review (2026-08-24) asked for the splash to open on Arabic, not
  /// the earlier Latin-transliteration text — this constant's value
  /// changed, not just its display treatment.
  static const String splashGreeting = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';

  /// English fallback for [splashGreeting]'s Semantics label only —
  /// screen readers announcing raw Arabic script by codepoint is not
  /// useful; the visible text itself always stays Arabic.
  static const String splashGreetingSemanticLabel = 'Bismillah — In the name of Allah';

  /// Internal project watermark. Not shown in the UI; used only in
  /// source-file header comments per `.clinerules` §7.
  static const String watermark = 'ALLAH';
}
