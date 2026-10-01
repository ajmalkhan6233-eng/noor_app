// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Quietly gets the Quran ready after Home is on screen, so a first-time
// user finds the surah list ready instead of watching the one-time
// import. The import service is single-flight, so opening the Quran tab
// while this runs simply joins it. Failures are ignored: the Quran
// screen runs the same import itself and reports any problem there.

import 'quran_import_service.dart';
import 'quran_repository.dart';

Future<void> prewarmQuran({
  QuranImportService? importService,
  QuranRepository? repository,
}) async {
  try {
    await (importService ?? QuranImportService()).ensureImported();
    await (repository ?? QuranRepository()).surahs();
  } catch (_) {}
}
