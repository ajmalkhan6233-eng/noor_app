// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure, top-level parsing functions — run on a background isolate via
// `compute()` so the CPU work of turning ~1.4MB of Tanzil text and
// metadata XML into row maps never blocks the UI thread. No network,
// no side effects: bytes in, row maps out.

import 'dart:convert';

import 'package:xml/xml.dart';

import '../../../core/utils/arabic_text.dart';

class QuranImportInput {
  const QuranImportInput({
    required this.quranBytes,
    required this.metadataBytes,
  });

  final List<int> quranBytes;
  final List<int> metadataBytes;
}

class QuranImportParsed {
  const QuranImportParsed({required this.surahRows, required this.ayahRows});

  final List<Map<String, Object?>> surahRows;
  final List<Map<String, Object?>> ayahRows;
}

/// Top-level so it can be handed to `compute()`.
QuranImportParsed parseQuranImport(QuranImportInput input) {
  return QuranImportParsed(
    surahRows: _parseSurahMetadata(input.metadataBytes),
    ayahRows: _parseAyahs(input.quranBytes),
  );
}

List<Map<String, Object?>> _parseAyahs(List<int> bytes) {
  final text = utf8.decode(bytes, allowMalformed: true);
  final rows = <Map<String, Object?>>[];
  for (final line in const LineSplitter().convert(text)) {
    final parts = line.split('|');
    if (parts.length != 3) continue;
    final surahId = int.tryParse(parts[0]);
    final ayahNumber = int.tryParse(parts[1]);
    if (surahId == null || ayahNumber == null) continue;
    final arabicText = parts[2];
    rows.add({
      'surah_id': surahId,
      'ayah_number': ayahNumber,
      'arabic_text': arabicText,
      'arabic_text_stripped': stripArabicDiacritics(arabicText),
    });
  }
  return rows;
}

class QuranTranslationRow {
  const QuranTranslationRow({
    required this.surahId,
    required this.ayahNumber,
    required this.text,
  });

  final int surahId;
  final int ayahNumber;
  final String text;
}

/// Parses a Tanzil-format `sura|aya|text` translation file. Top-level
/// so it can be handed to `compute()`, same as [parseQuranImport].
List<QuranTranslationRow> parseQuranTranslation(List<int> bytes) {
  final text = utf8.decode(bytes, allowMalformed: true);
  final rows = <QuranTranslationRow>[];
  for (final line in const LineSplitter().convert(text)) {
    final parts = line.split('|');
    if (parts.length < 3) continue;
    final surahId = int.tryParse(parts[0]);
    final ayahNumber = int.tryParse(parts[1]);
    if (surahId == null || ayahNumber == null) continue;
    // Rejoin in case the translation text itself contained a literal
    // '|' — split(3) above would have already handled this, but stay
    // defensive since this only ever runs against verified bytes.
    final ayahText = parts.sublist(2).join('|');
    rows.add(
      QuranTranslationRow(surahId: surahId, ayahNumber: ayahNumber, text: ayahText),
    );
  }
  return rows;
}

List<Map<String, Object?>> _parseSurahMetadata(List<int> bytes) {
  final xmlText = utf8.decode(bytes, allowMalformed: true);
  final doc = XmlDocument.parse(xmlText);
  final rows = <Map<String, Object?>>[];
  for (final sura in doc.findAllElements('sura')) {
    final type = sura.getAttribute('type');
    rows.add({
      'id': int.parse(sura.getAttribute('index')!),
      'name_arabic': sura.getAttribute('name'),
      'name_translit': sura.getAttribute('tname'),
      'name_english': sura.getAttribute('ename'),
      'revelation_place': type == 'Meccan' ? 'meccan' : 'medinan',
      'ayah_count': int.parse(sura.getAttribute('ayas')!),
    });
  }
  return rows;
}
