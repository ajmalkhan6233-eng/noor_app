// Bismillahir Rahmanir Raheem — watermark: ALLAH

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
  _FakeImportService(this.status);
  final QuranImportStatus status;

  @override
  Future<QuranImportStatus> ensureImported({
    void Function(double progress)? onProgress,
  }) async => status;
}

class _FakeQuranRepository extends QuranRepository {
  final List<QuranBookmark> _bookmarks = [];
  int _nextBookmarkId = 1;

  @override
  Future<List<QuranSurah>> surahs() async =>
      [const QuranSurah(id: 1, ayahCount: 7, nameTranslit: 'Al-Fatiha')];

  @override
  Future<List<QuranAyah>> ayahsForSurah(int surahId) async => [
    QuranAyah(surahId: surahId, ayahNumber: 1, arabicText: 'placeholder'),
  ];

  @override
  Future<List<QuranAyah>> search(String query) async =>
      query.isEmpty ? [] : await ayahsForSurah(1);

  @override
  Future<List<QuranBookmark>> bookmarks() async => List.unmodifiable(_bookmarks);

  @override
  Future<void> addBookmark(int surahId, int ayahNumber) async {
    _bookmarks.add(
      QuranBookmark(id: _nextBookmarkId++, surahId: surahId, ayahNumber: ayahNumber),
    );
  }

  @override
  Future<void> removeBookmark(int bookmarkId) async {
    _bookmarks.removeWhere((b) => b.id == bookmarkId);
  }

  @override
  Future<QuranReadingPosition?> lastRead() async => null;

  @override
  Future<void> setLastRead(int surahId, int ayahNumber) async {}
}

class _FakeSettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings> load() async => const AppSettings(arabicFontScale: 1.4);

  @override
  Future<void> save(AppSettings settings) async {}
}

void main() {
  group('QuranCubit.init', () {
    test('surfaces QuranAssetMissing without touching the repository', () async {
      final cubit = QuranCubit(
        repository: _FakeQuranRepository(),
        importService: _FakeImportService(const QuranAssetMissing()),
        settingsRepository: _FakeSettingsRepository(),
      );
      await cubit.init();

      expect(cubit.state.isImported, isFalse);
      expect(cubit.state.importStatus, isA<QuranAssetMissing>());
      expect(cubit.state.surahs, isEmpty);
    });

    test('loads surahs once imported', () async {
      final cubit = QuranCubit(
        repository: _FakeQuranRepository(),
        importService: _FakeImportService(const QuranImported()),
        settingsRepository: _FakeSettingsRepository(),
      );
      await cubit.init();

      expect(cubit.state.isImported, isTrue);
      expect(cubit.state.surahs, hasLength(1));
      expect(cubit.state.arabicFontScale, 1.4);
    });
  });

  group('QuranCubit interactions', () {
    late QuranCubit cubit;

    setUp(() async {
      cubit = QuranCubit(
        repository: _FakeQuranRepository(),
        importService: _FakeImportService(const QuranImported()),
        settingsRepository: _FakeSettingsRepository(),
      );
      await cubit.init();
    });

    test('openSurah loads that surah\'s ayahs', () async {
      await cubit.openSurah(1);
      expect(cubit.state.currentSurahId, 1);
      expect(cubit.state.currentAyahs, isNotEmpty);
    });

    test('toggleBookmark adds then removes', () async {
      await cubit.toggleBookmark(1, 1);
      expect(cubit.state.bookmarks, hasLength(1));

      await cubit.toggleBookmark(1, 1);
      expect(cubit.state.bookmarks, isEmpty);
    });

    test('search populates results for a non-empty query', () async {
      await cubit.search('test');
      expect(cubit.state.searchResults, isNotEmpty);

      await cubit.search('');
      expect(cubit.state.searchResults, isEmpty);
    });
  });
}
