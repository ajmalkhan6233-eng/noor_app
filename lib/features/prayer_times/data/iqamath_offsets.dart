// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Minutes added after the adhan (computed) time to get the iqamath
// (congregation start) time — set by the user, shown as a second
// column beside the adhan time. No sunrise entry: iqamath doesn't
// apply to sunrise.

class IqamathOffsetMinutes {
  const IqamathOffsetMinutes({
    this.fajr = 20,
    this.dhuhr = 15,
    this.asr = 15,
    this.maghrib = 10,
    this.isha = 15,
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
