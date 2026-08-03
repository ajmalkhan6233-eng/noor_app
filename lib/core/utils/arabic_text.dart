// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Strips Arabic diacritics (tashkeel) and tatweel so Quran search can
// match text regardless of how the user types it — never used to
// alter what's actually displayed, only a derived search column.
// Expressed purely as Unicode code-point ranges, not literal
// characters, so nothing here is itself Arabic-language text.

final RegExp _diacriticsPattern = RegExp(
  '[\u{0610}-\u{061A}\u{064B}-\u{065F}\u{0670}\u{06D6}-\u{06DC}'
  '\u{06DF}-\u{06E4}\u{06E7}-\u{06E8}\u{06EA}-\u{06ED}\u{0640}]',
  unicode: true,
);

/// Returns [text] with diacritics/tatweel removed, for diacritic-
/// insensitive search matching.
String stripArabicDiacritics(String text) =>
    text.replaceAll(_diacriticsPattern, '');
