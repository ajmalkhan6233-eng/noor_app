// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/utils/arabic_text.dart';

void main() {
  group('stripArabicDiacritics', () {
    test('leaves plain Arabic letters untouched', () {
      // "kitab" (book) — ordinary Arabic, not Quranic text, with no
      // diacritics: the function should be a no-op here.
      const word = 'كتاب';
      expect(stripArabicDiacritics(word), word);
    });

    test('removes fatha, damma, kasra, sukun, and shadda', () {
      // "kataba" (he wrote) fully vocalised, then the same word with
      // its diacritics removed — ordinary vocabulary, not scripture.
      const vocalised = 'كَتَبَ';
      const bare = 'كتب';
      expect(stripArabicDiacritics(vocalised), bare);
    });

    test('removes tatweel', () {
      const withTatweel = 'كـتاب';
      const withoutTatweel = 'كتاب';
      expect(stripArabicDiacritics(withTatweel), withoutTatweel);
    });

    test('leaves non-Arabic text untouched', () {
      expect(stripArabicDiacritics('hello 123'), 'hello 123');
    });
  });
}
