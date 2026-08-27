// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The plaintext shape backed up and restored — encrypted as a whole
// by backup_crypto.dart before it ever touches disk. Only genuinely
// personal, locally-generated data: prayer/fasting streak history,
// Quran and Azkar bookmarks, and the Zakat calculator's remembered
// gold/silver price. Never Quran/Azkar text itself — that's bundled,
// verified, reimportable from the app's own assets on any install.

class BackupPayload {
  const BackupPayload({
    required this.exportedAt,
    required this.prayerCompletions,
    required this.fastingDays,
    required this.quranBookmarks,
    required this.azkarBookmarks,
    this.zakatGoldPricePerGram,
    this.zakatSilverPricePerGram,
  });

  static const int formatVersion = 1;

  final DateTime exportedAt;
  final List<PrayerCompletionEntry> prayerCompletions;
  final List<String> fastingDays;
  final List<QuranBookmarkEntry> quranBookmarks;
  final List<AzkarBookmarkEntry> azkarBookmarks;
  final double? zakatGoldPricePerGram;
  final double? zakatSilverPricePerGram;

  Map<String, dynamic> toJson() => {
    'formatVersion': formatVersion,
    'exportedAt': exportedAt.toIso8601String(),
    'prayerCompletions': [for (final e in prayerCompletions) e.toJson()],
    'fastingDays': fastingDays,
    'quranBookmarks': [for (final e in quranBookmarks) e.toJson()],
    'azkarBookmarks': [for (final e in azkarBookmarks) e.toJson()],
    'zakatGoldPricePerGram': zakatGoldPricePerGram,
    'zakatSilverPricePerGram': zakatSilverPricePerGram,
  };

  /// Throws [FormatException] on a payload from a newer, incompatible
  /// format — never silently guesses at an unknown shape.
  factory BackupPayload.fromJson(Map<String, dynamic> json) {
    final version = json['formatVersion'] as int?;
    if (version == null || version > formatVersion) {
      throw FormatException('Unsupported backup format version: $version');
    }
    return BackupPayload(
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      prayerCompletions: [
        for (final e in (json['prayerCompletions'] as List))
          PrayerCompletionEntry.fromJson(e as Map<String, dynamic>),
      ],
      fastingDays: [for (final d in (json['fastingDays'] as List)) d as String],
      quranBookmarks: [
        for (final e in (json['quranBookmarks'] as List))
          QuranBookmarkEntry.fromJson(e as Map<String, dynamic>),
      ],
      azkarBookmarks: [
        for (final e in (json['azkarBookmarks'] as List))
          AzkarBookmarkEntry.fromJson(e as Map<String, dynamic>),
      ],
      zakatGoldPricePerGram: (json['zakatGoldPricePerGram'] as num?)?.toDouble(),
      zakatSilverPricePerGram: (json['zakatSilverPricePerGram'] as num?)?.toDouble(),
    );
  }
}

class PrayerCompletionEntry {
  const PrayerCompletionEntry({required this.date, required this.prayer});
  final String date;
  final String prayer;

  Map<String, dynamic> toJson() => {'date': date, 'prayer': prayer};
  factory PrayerCompletionEntry.fromJson(Map<String, dynamic> json) =>
      PrayerCompletionEntry(date: json['date'] as String, prayer: json['prayer'] as String);
}

/// Surah/ayah number, not a raw row id — stable across installs since
/// those are canonical Quran identifiers, unlike an autoincrement id.
class QuranBookmarkEntry {
  const QuranBookmarkEntry({
    required this.surahId,
    required this.ayahNumber,
    required this.createdAt,
  });
  final int surahId;
  final int ayahNumber;
  final String createdAt;

  Map<String, dynamic> toJson() =>
      {'surahId': surahId, 'ayahNumber': ayahNumber, 'createdAt': createdAt};
  factory QuranBookmarkEntry.fromJson(Map<String, dynamic> json) => QuranBookmarkEntry(
    surahId: json['surahId'] as int,
    ayahNumber: json['ayahNumber'] as int,
    createdAt: json['createdAt'] as String,
  );
}

/// The item's Arabic text, not its raw row id — `azkar_items.id` is an
/// autoincrement id that isn't guaranteed to line up across installs
/// or dataset re-imports, so restoring by id could bookmark the wrong
/// item. Resolved back to whatever id matches on the importing device.
class AzkarBookmarkEntry {
  const AzkarBookmarkEntry({required this.arabicText, required this.createdAt});
  final String arabicText;
  final String createdAt;

  Map<String, dynamic> toJson() => {'arabicText': arabicText, 'createdAt': createdAt};
  factory AzkarBookmarkEntry.fromJson(Map<String, dynamic> json) =>
      AzkarBookmarkEntry(arabicText: json['arabicText'] as String, createdAt: json['createdAt'] as String);
}
