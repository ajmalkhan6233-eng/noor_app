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

  // Prayer times
  static const String prayerTimesScreenTitle = 'Prayer Times';
  static const String useGpsSemanticLabel = 'Use my current location';
  static const String manualLatitudeSemanticLabel = 'Manual latitude entry';
  static const String manualLongitudeSemanticLabel = 'Manual longitude entry';
  static const String applyManualLocationSemanticLabel =
      'Apply manual coordinates';
  static const String calculationMethodSemanticLabel =
      'Prayer time calculation method';
  static const String madhabSemanticLabel = 'Asr madhab';
  static const String highLatitudeUnresolvedMessage =
      'No genuine Isha (or Fajr) time exists for this location and date — '
      'the sun does not reach the required angle. Showing an estimated '
      'clock time here would be misleading, so none is shown.';

  // Qibla
  static const String qiblaScreenTitle = 'Qibla';
  static const String qiblaNeedleSemanticLabel = 'Qibla direction needle';
  static const String qiblaCalibrationPromptMessage =
      'Compass reading is uncalibrated or unreliable — move your device '
      'in a figure-eight motion to calibrate. The needle is dimmed until '
      'then so it is never shown pointing confidently in a wrong direction.';
  static const String qiblaNoCompassMessage =
      'This device has no compass — showing the qibla bearing as a number '
      'only.';

  // Quran / Azkar / Home nav
  static const String quranScreenTitle = 'Quran';
  static const String azkarScreenTitle = 'Azkar';
  static const String settingsSemanticLabel = 'Settings';
}
