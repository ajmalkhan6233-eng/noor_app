// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Per-prayer manual offsets in minutes, set by the user in Settings —
// applied on top of (never replacing) the chosen calculation method's
// own built-in adjustments.

/// Minute offsets applied to each computed prayer time.
class PrayerAdjustmentMinutes {
  const PrayerAdjustmentMinutes({
    this.fajr = 0,
    this.sunrise = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
  });

  final int fajr;
  final int sunrise;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;

  PrayerAdjustmentMinutes copyWith({
    int? fajr,
    int? sunrise,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
  }) {
    return PrayerAdjustmentMinutes(
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }
}
