// Bismillahir Rahmanir Raheem — watermark: ALLAH

/// Per-prayer notification toggles (no toggle for sunrise — it isn't
/// a prayer).
class NotificationSettings {
  const NotificationSettings({
    this.fajr = true,
    this.dhuhr = true,
    this.asr = true,
    this.maghrib = true,
    this.isha = true,
  });

  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;

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

  /// Returns a copy with [name]'s toggle set to [value] — the inverse
  /// of [forPrayer], for callers that only know the prayer by name
  /// (e.g. building one toggle per row in a list).
  NotificationSettings withPrayer(String name, bool value) {
    switch (name) {
      case 'Fajr':
        return copyWith(fajr: value);
      case 'Dhuhr':
        return copyWith(dhuhr: value);
      case 'Asr':
        return copyWith(asr: value);
      case 'Maghrib':
        return copyWith(maghrib: value);
      case 'Isha':
        return copyWith(isha: value);
      default:
        return this;
    }
  }

  NotificationSettings copyWith({
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
  }) {
    return NotificationSettings(
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }
}
