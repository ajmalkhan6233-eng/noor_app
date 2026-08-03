# Quran source text

This app does not ship any Quranic text. To enable the Quran feature,
add a Tanzil "simple text" format file here named:

    tanzil-simple.txt

Format: one ayah per line, `sura|aya|text` (pipe-separated), e.g. a
line for surah 2 ayah 255 begins `2|255|...`.

After adding the file, compute its SHA-256 and set
`QuranImportService.expectedSha256` (in
`lib/features/quran/data/quran_import_service.dart`) to that value:

    shasum -a 256 assets/quran/tanzil-simple.txt

Until both the file and the matching hash are in place, the Quran
screen shows a clear "not available" notice instead of any content —
it never imports or displays unverified text.
