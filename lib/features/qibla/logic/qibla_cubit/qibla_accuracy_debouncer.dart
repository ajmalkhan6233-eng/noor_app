// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of qibla_cubit.dart to stay under the 150-line limit.
// Hysteresis for the good/not-good accuracy boundary specifically —
// magnetometer accuracy readings genuinely oscillate reading to
// reading on a real device (indoors, near other electronics), and
// that boundary drives two visible UI changes at once: the needle's
// dim/undim and whether CalibrationPrompt is mounted at all (a whole
// banner popping in and out, not just an alpha fade). Reported
// repeatedly as "the compass is blinking" even after the needle's own
// alpha was smoothed (see QiblaNeedle) — that fix only covered the
// needle's opacity, not this banner mount/unmount, which is the more
// jarring of the two. Requiring 3 consecutive readings on the new side
// before actually flipping means a single noisy sample can't do it
// alone.

import '../../../../core/sensors/compass_reading.dart';

class QiblaAccuracyDebouncer {
  static const _hysteresisStreak = 3;

  bool _uiGood = false;
  int _streakCount = 0;
  CompassAccuracy _lastDisplayed = CompassAccuracy.unavailable;

  /// Only the good/not-good boundary is debounced — CalibrationPrompt
  /// and the needle's dim both branch on that boundary alone, not on
  /// which specific non-good classification it is. [unavailable]
  /// passes straight through: that's a device-capability fact, not
  /// sensor noise, so there's nothing to debounce.
  CompassAccuracy call(CompassAccuracy raw) {
    if (raw == CompassAccuracy.unavailable) {
      _uiGood = false;
      _streakCount = 0;
      _lastDisplayed = CompassAccuracy.unavailable;
      return _lastDisplayed;
    }
    final rawGood = raw == CompassAccuracy.good;
    if (rawGood == _uiGood) {
      _streakCount = 0;
      _lastDisplayed = raw;
      return _lastDisplayed;
    }
    _streakCount++;
    if (_streakCount >= _hysteresisStreak) {
      _uiGood = rawGood;
      _streakCount = 0;
      _lastDisplayed = raw;
    }
    return _lastDisplayed;
  }
}
