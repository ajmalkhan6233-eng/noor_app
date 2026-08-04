// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A short, deliberately uncrowded list of common dhikr — not every
// possible phrase, just the ones most people reach for.

enum DhikrOption {
  subhanAllah,
  alhamdulillah,
  allahuAkbar,
  laIlahaIllallah,
  astaghfirullah,
}

extension DhikrOptionLabel on DhikrOption {
  String get label {
    switch (this) {
      case DhikrOption.subhanAllah:
        return 'SubhanAllah';
      case DhikrOption.alhamdulillah:
        return 'Alhamdulillah';
      case DhikrOption.allahuAkbar:
        return 'Allahu Akbar';
      case DhikrOption.laIlahaIllallah:
        return 'La ilaha illallah';
      case DhikrOption.astaghfirullah:
        return 'Astaghfirullah';
    }
  }
}
