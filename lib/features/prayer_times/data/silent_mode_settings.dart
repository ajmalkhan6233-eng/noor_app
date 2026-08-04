// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Per-prayer "silence the phone" toggle, plus one shared number of
// extra minutes added after iqamath before ringer volume is restored.

class SilentModeSettings {
  const SilentModeSettings({
    this.fajr = false,
    this.dhuhr = false,
    this.asr = false,
    this.maghrib = false,
    this.isha = false,
    this.extraMinutesAfterIqamath = 5,
  });

  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;

  /// Minutes after iqamath before the ringer is restored to normal.
  final int extraMinutesAfterIqamath;

  bool forPrayer(String name) {
    switch (name) {
      case 'Fajr':
        return fajr;
      case 'Dhuhr':
        return dhuhr;
      case 'Asr':
        return asr;
      case 'Maghrib':
        return maghrib;
      case 'Isha':
        return isha;
      default:
        return false;
    }
  }

  SilentModeSettings copyWith({
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
    int? extraMinutesAfterIqamath,
  }) {
    return SilentModeSettings(
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      extraMinutesAfterIqamath:
          extraMinutesAfterIqamath ?? this.extraMinutesAfterIqamath,
    );
  }
}
