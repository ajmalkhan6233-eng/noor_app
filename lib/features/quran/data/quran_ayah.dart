// Bismillahir Rahmanir Raheem — watermark: ALLAH

class QuranAyah {
  const QuranAyah({
    required this.surahId,
    required this.ayahNumber,
    required this.arabicText,
    this.translation,
  });

  final int surahId;
  final int ayahNumber;
  final String arabicText;
  final String? translation;
}
