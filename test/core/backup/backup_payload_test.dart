// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/backup/backup_payload.dart';

void main() {
  test('round-trips every field through toJson/fromJson', () {
    final payload = BackupPayload(
      exportedAt: DateTime.utc(2026, 8, 27, 12, 0, 0),
      prayerCompletions: const [PrayerCompletionEntry(date: '2026-08-26', prayer: 'Fajr')],
      fastingDays: const ['2026-08-25'],
      quranBookmarks: const [
        QuranBookmarkEntry(surahId: 2, ayahNumber: 255, createdAt: '2026-08-20T10:00:00Z'),
      ],
      azkarBookmarks: const [
        AzkarBookmarkEntry(arabicText: 'سُبْحَانَ اللَّهِ', createdAt: '2026-08-21T10:00:00Z'),
      ],
      zakatGoldPricePerGram: 25.5,
      zakatSilverPricePerGram: 1.2,
    );

    final roundTripped = BackupPayload.fromJson(payload.toJson());

    expect(roundTripped.exportedAt, payload.exportedAt);
    expect(roundTripped.prayerCompletions.single.date, '2026-08-26');
    expect(roundTripped.prayerCompletions.single.prayer, 'Fajr');
    expect(roundTripped.fastingDays, ['2026-08-25']);
    expect(roundTripped.quranBookmarks.single.surahId, 2);
    expect(roundTripped.quranBookmarks.single.ayahNumber, 255);
    expect(roundTripped.azkarBookmarks.single.arabicText, 'سُبْحَانَ اللَّهِ');
    expect(roundTripped.zakatGoldPricePerGram, 25.5);
    expect(roundTripped.zakatSilverPricePerGram, 1.2);
  });

  test('rejects a backup from a newer, unknown format version', () {
    final json = {
      'formatVersion': BackupPayload.formatVersion + 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'prayerCompletions': [],
      'fastingDays': [],
      'quranBookmarks': [],
      'azkarBookmarks': [],
    };

    expect(() => BackupPayload.fromJson(json), throwsFormatException);
  });
}
