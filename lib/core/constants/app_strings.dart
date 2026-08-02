// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Global user-facing strings. Keeping these centralized avoids typos
// scattered across widgets and makes future localization easier.

/// Static string constants for `noor`.
abstract final class AppStrings {
  /// App display name.
  static const String appName = 'noor';

  /// Mandatory splash-screen greeting, shown in full caps on launch.
  static const String splashGreeting = 'BISMILLAHIR RAHMANIR RAHEEM';

  /// Internal project watermark. Not shown in the UI; used only in
  /// source-file header comments per `.clinerules` §7.
  static const String watermark = 'ALLAH';

  // Tasbih
  static const String tasbihScreenTitle = 'Tasbih';
  static const String tasbihCounterSemanticLabel = 'Tasbih counter';
  static const String tasbihResetSemanticLabel = 'Reset tasbih count';
}
