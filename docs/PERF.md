# Quran performance (2026-10-01)

No device was available. Numbers below are from `flutter test` on the development PC (real bundled
Quran, real SQLite through ffi, real text layout), so they are not phone numbers; phone times are
slower, which is why the design removes work instead of just trimming it.

## What was wrong (read from the code)
1. **Page splitting was quadratic-ish and on the UI thread.** `splitIntoPages` re-laid out the whole
   growing page text once per ayah (`TextPainter.layout` on `a1..ak` for every k). The code comments
   record ~30 s for the whole Quran on a phone. The full-Quran reader waited for *every* page behind a
   spinner; a new user (empty cache) saw that spinner for the whole pass. Resuming a surah froze the
   UI thread for its whole measurement.
2. **Everything-at-once loading.** "Read the full Quran" loads all 6,236 ayahs and paginates all 114
   surahs before showing the first page.
3. **Search race.** Every keystroke ran a query; a slow older query could finish after a newer one and
   overwrite (or blank) the results. No debounce.
4. **Eager list.** The surah index built all 114 tiles inside `StaggeredFadeIn` + `ParallaxItem`.
5. **First-run import started only when the Quran tab opened** (hash + parse + 6,236 inserts + a
   6,236-row translation backfill, each in many small commits), so a new user waited on the Quran tab.

## What changed
- `data/page_packer.dart`: guess-and-verify packing (previous page size is the guess, binary search
  when too big). Identical pages to the old algorithm (tested against it), ~40% fewer layouts on a long
  surah and far fewer on short-ayah surahs. Progressive variant yields to the UI between chunks.
- `SurahPaginator` / `FullQuranPaginator`: the first page is shown after one chunk; the rest is built in
  the background (8 ms slices). Full-Quran result still cached in memory and on disk. Resuming at a saved
  position waits only until that page exists.
- Surah list: `ListView.builder`, no staggered fades or parallax.
- Search: 200 ms debounce, sequence guard so only the newest query publishes; empty box clears at once.
- Import: single flight (pre-warm and the Quran tab share it), one transaction per table; pre-warm starts
  2 s after Home appears (cancelled if Home goes away) and never throws.
- Last read position: unchanged (already resumes the saved ayah in both readers).
- No Quran text was touched.

## Measurements (test environment, `test/features/quran/quran_perf_test.dart`)
| Step | Time | Budget |
|---|---|---|
| Surah list ready (114 rows) | 12-14 ms | 500 ms |
| Al-Baqarah: load 286 ayahs + first page ready | 92-111 ms | 500 ms |
| Full Quran: first page ready (6,236 ayahs loaded) | 7-9 ms | 500 ms |
| Search "mercy" / "بسم" / "kahf" | 17-23 ms each | 500 ms |
| First-time import (verify, parse, insert, translation) | 2.4-2.8 s | (hidden by pre-warm) |
The tests fail if any budget row exceeds 500 ms. `page_packer_test.dart` fails if the packer stops
matching the old algorithm or goes back to one measurement per ayah (286 -> 173 on the test surah).

## Observations not changed
- Arabic search with a plain alef (e.g. "الرحمن") returns nothing because the stored text uses
  Uthmani characters (alef wasla etc.) and the stripping does not normalise them; "بسم" works. Search
  normalisation is a text-handling decision; see docs/NEEDS_DECISION.md.
- Unmeasured on a phone: real first-run import time with SQLCipher, TextPainter cost per page.
