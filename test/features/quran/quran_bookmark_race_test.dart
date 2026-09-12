// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test: a rapid double-tap on the bookmark icon (both taps
// firing before the first toggleBookmark's DB round trip and state
// re-emit completed) used to create a duplicate bookmark row instead
// of adding then immediately removing it — quran_bookmarks has no
// unique constraint on (surah_id, ayah_number), and both concurrent
// calls read the same stale state.bookmarks and both decided to
// insert. Confirmed this test fails against the pre-fix code (2 rows)
// and passes now that toggleBookmark serializes concurrent calls.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/data/quran_bookmark.dart';
import 'package:noor/features/quran/data/quran_import_service.dart';
import 'package:noor/features/quran/data/quran_import_status.dart';
import 'package:noor/features/quran/data/quran_repository.dart';
import 'package:noor/features/quran/data/quran_surah.dart';
import 'package:noor/features/quran/logic/quran_cubit/quran_cubit.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';

class _FakeImportService implements QuranImportService {
  @override
  Future<QuranImportStatus> ensureImported({
    void Function(double progress)? onProgress,
  }) async => const QuranImported();
}

class _FakeQuranRepository extends QuranRepository {
  final List<QuranBookmark> _bookmarks = [];
  int _nextBookmarkId = 1;

  @override
  Future<List<QuranSurah>> surahs() async => [];

  @override
  Future<List<QuranBookmark>> bookmarks() async {
    // Simulate a real async DB round trip (sqflite always has one),
    // so both concurrent toggle calls are mid-flight at the same time
    // instead of resolving synchronously.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    return List.unmodifiable(_bookmarks);
  }

  @override
  Future<void> addBookmark(int surahId, int ayahNumber) async {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    _bookmarks.add(
      QuranBookmark(id: _nextBookmarkId++, surahId: surahId, ayahNumber: ayahNumber),
    );
  }

  @override
  Future<void> removeBookmark(int bookmarkId) async {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    _bookmarks.removeWhere((b) => b.id == bookmarkId);
  }

  @override
  Future<QuranReadingPosition?> lastRead() async => null;
}

class _FakeSettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings> load() async => const AppSettings();

  @override
  Future<void> save(AppSettings settings) async {}
}

void main() {
  test(
    'two near-simultaneous taps on the same ayah bookmark icon do not '
    'create a duplicate row',
    () async {
      final cubit = QuranCubit(
        repository: _FakeQuranRepository(),
        importService: _FakeImportService(),
        settingsRepository: _FakeSettingsRepository(),
      );
      await cubit.init();

      await Future.wait([
        cubit.toggleBookmark(1, 1),
        cubit.toggleBookmark(1, 1),
      ]);

      // Add then immediately remove: net result is not bookmarked,
      // and never a duplicate row.
      expect(
        cubit.state.bookmarks.where((b) => b.surahId == 1 && b.ayahNumber == 1),
        isEmpty,
      );

      await cubit.close();
    },
  );
}
