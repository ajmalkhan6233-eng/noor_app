// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Benchmark-style checks (real bundled Quran, real SQLite via ffi, real
// text layout): first content must be ready in well under 500 ms in the
// test environment. The measured numbers are printed and recorded in
// docs/PERF.md. A regression back to "measure the whole Quran before
// showing anything" fails these tests.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/database_helper.dart';
import 'package:noor/core/database/schema/quran_schema.dart';
import 'package:noor/features/quran/data/quran_import_service.dart';
import 'package:noor/features/quran/data/quran_repository.dart';
import 'package:noor/features/quran/presentation/widgets/full_quran_page_splitter.dart';
import 'package:noor/features/quran/presentation/widgets/surah_page_splitter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const _budgetMs = 500;
const _style = TextStyle(fontSize: 22, height: 2.1);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Database db;
  late QuranRepository repo;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    final helper = DatabaseHelper.forTesting(db);
    final watch = Stopwatch()..start();
    final status = await QuranImportService(databaseHelper: helper).ensureImported();
    // ignore: avoid_print
    print('PERF first-time import (verify + parse + insert + translation): ${watch.elapsedMilliseconds} ms');
    expect(status.runtimeType.toString(), 'QuranImported');
    repo = QuranRepository(databaseHelper: helper);
  });

  tearDownAll(() => db.close());


  Future<int> timeMs(String label, Future<void> Function() body) async {
    final watch = Stopwatch()..start();
    await body();
    final ms = watch.elapsedMilliseconds;
    // ignore: avoid_print
    print('PERF $label: $ms ms');
    return ms;
  }

  test('surah list is ready fast', () async {
    late List<dynamic> surahs;
    final ms = await timeMs('surah list ready', () async => surahs = await repo.surahs());
    expect(surahs.length, 114);
    expect(ms, lessThan(_budgetMs));
  });

  test('Al-Baqarah: ayahs loaded and first page ready fast', () async {
    var pageCount = 0;
    final ms = await timeMs('Al-Baqarah first page ready', () async {
      final ayahs = await repo.ayahsForSurah(2);
      expect(ayahs.length, 286);
      await splitIntoPagesProgressive(
        ayahs: ayahs,
        style: _style,
        maxWidth: 360,
        maxHeight: 560,
        onChunk: (pages) {
          pageCount = pages.length;
          return false; // stop after the first chunk: that is what the UI shows first
        },
      );
    });
    expect(pageCount, 1);
    expect(ms, lessThan(_budgetMs));
  });

  test('full Quran: first pages ready fast (not after the whole book)', () async {
    final all = await repo.allAyahs();
    final surahs = await repo.surahs();
    expect(all.length, 6236);
    final ms = await timeMs('full Quran first page ready', () async {
      await splitBookProgressive(
        ayahs: all,
        surahs: surahs,
        style: _style,
        maxWidth: 360,
        maxHeight: 560,
        onPages: (pages) => false,
      );
    });
    expect(ms, lessThan(_budgetMs));
  });

  test('search is fast (Arabic, English, surah name)', () async {
    for (final query in ['mercy', 'بسم', 'kahf']) {
      late List<dynamic> results;
      final ms = await timeMs('search "$query"', () async => results = await repo.search(query));
      expect(results, isNotEmpty, reason: query);
      expect(ms, lessThan(_budgetMs), reason: query);
    }
  });
}
