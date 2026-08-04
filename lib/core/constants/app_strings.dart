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

  /// Mandatory splash-screen greeting, shown in full caps on launch.
  /// A religious invocation, not UI chrome — never translated.
  static const String splashGreeting = 'BISMILLAHIR RAHMANIR RAHEEM';

  /// Internal project watermark. Not shown in the UI; used only in
  /// source-file header comments per `.clinerules` §7.
  static const String watermark = 'ALLAH';
}
