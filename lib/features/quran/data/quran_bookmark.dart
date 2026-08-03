// Bismillahir Rahmanir Raheem — watermark: ALLAH

class QuranBookmark {
  const QuranBookmark({
    required this.id,
    required this.surahId,
    required this.ayahNumber,
  });

  final int id;
  final int surahId;
  final int ayahNumber;
}

class QuranReadingPosition {
  const QuranReadingPosition({required this.surahId, required this.ayahNumber});

  final int surahId;
  final int ayahNumber;
}
