// Bismillahir Rahmanir Raheem — watermark: ALLAH

/// One surah's metadata. `nameArabic`/`nameTranslit` are `null` until
/// populated by a future import — the reader falls back to the surah
/// number rather than fabricating a name.
class QuranSurah {
  const QuranSurah({
    required this.id,
    required this.ayahCount,
    this.nameArabic,
    this.nameTranslit,
  });

  final int id;
  final int ayahCount;
  final String? nameArabic;
  final String? nameTranslit;

  String get displayName => nameTranslit ?? 'Surah $id';
}
