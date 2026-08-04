// Bismillahir Rahmanir Raheem — watermark: ALLAH

/// Where a surah was revealed — structural metadata from the Tanzil
/// data file, not interpretive content.
enum RevelationPlace { meccan, medinan }

/// One surah's metadata, imported from Tanzil's `quran-data.xml`.
/// `nameArabic`/`nameTranslit`/`nameEnglish`/`revelationPlace` are
/// `null` until a verified import has run — the reader falls back to
/// the surah number rather than fabricating a name.
class QuranSurah {
  const QuranSurah({
    required this.id,
    required this.ayahCount,
    this.nameArabic,
    this.nameTranslit,
    this.nameEnglish,
    this.revelationPlace,
  });

  final int id;
  final int ayahCount;
  final String? nameArabic;
  final String? nameTranslit;
  final String? nameEnglish;
  final RevelationPlace? revelationPlace;

  String get displayName => nameTranslit ?? 'Surah $id';
}
