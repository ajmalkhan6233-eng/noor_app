// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Minutes added after the adhan (computed) time to get the iqamath
// (congregation start) time — set by the user, shown as a second
// column beside the adhan time. No sunrise entry: iqamath doesn't
// apply to sunrise.

class IqamathOffsetMinutes {
  // Defaults per direct request (2026-08-26): standard mosque-practice
  // starting points, Maghrib kept tight since its window is naturally
  // short. A user who has already changed these via Settings is
  // unaffected — only fresh values fall back to these.
  const IqamathOffsetMinutes({
    this.fajr = 20,
    this.dhuhr = 10,
    this.asr = 10,
    this.maghrib = 5,
    this.isha = 10,
  });

  final int fajr;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;

  int forPrayer(String name) {
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
        return 0;
    }
  }

  IqamathOffsetMinutes copyWith({
    int? fajr,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
  }) {
    return IqamathOffsetMinutes(
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }
}
