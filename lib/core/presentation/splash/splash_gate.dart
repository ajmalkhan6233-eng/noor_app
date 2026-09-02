// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Bismillah/NOOR splash is a brand moment meant for the very
// first-ever launch, not every open. Persisted via shared_preferences
// (not the settings DB — this is a lightweight, per-device timestamp,
// not user-configurable app data) so a normal reopen goes straight to
// the prayer countdown, but a genuinely fresh session (first install,
// or the app not opened in a while) still gets the full sequence.

import 'package:shared_preferences/shared_preferences.dart';

class SplashGate {
  static const _lastShownKey = 'splash_last_shown_at_millis';

  /// Reopening within this window skips the splash.
  static const Duration inactivityThreshold = Duration(hours: 24);

  Future<bool> shouldShowSplash() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShownMillis = prefs.getInt(_lastShownKey);
    if (lastShownMillis == null) return true;
    final lastShown = DateTime.fromMillisecondsSinceEpoch(lastShownMillis);
    return DateTime.now().difference(lastShown) >= inactivityThreshold;
  }

  Future<void> markSplashShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastShownKey, DateTime.now().millisecondsSinceEpoch);
  }
}
