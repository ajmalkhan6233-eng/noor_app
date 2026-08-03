// Bismillahir Rahmanir Raheem — watermark: ALLAH

/// One dhikr. `source` is mandatory — enforced all the way down at
/// the `azkar_items.source NOT NULL` column — every item must cite
/// where its text comes from.
class AzkarItem {
  const AzkarItem({
    required this.id,
    required this.arabicText,
    this.transliteration,
    this.translation,
    required this.repeatCount,
    required this.source,
  });

  final int id;
  final String arabicText;
  final String? transliteration;
  final String? translation;
  final int repeatCount;
  final String source;
}
