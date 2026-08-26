// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Sri Lankan public holidays and Poya (full moon) days, for the
// Islamic Calendar's "also mark local holidays" feature.
//
// COVERAGE — read before adding to this list. This is a deliberately
// partial, honestly-labelled seed, not the complete official
// calendar:
//
// - 4 fixed-date civic holidays (New Year's Day, Independence Day,
//   May Day, Christmas) recur every year and need no per-year
//   verification.
// - A handful of specific 2026 movable dates (Sinhala/Tamil New Year,
//   Medin/Vesak/Poson Poya) were found via web search citing Sri
//   Lanka's official Extraordinary Gazette under the Holidays Act
//   No. 29 of 1971 (aggregated by gazette.lk); this sandbox's network
//   egress proxy blocked directly fetching the gazette or any
//   aggregator page, so only the specific dates surfaced in search
//   result summaries could be confirmed — not the full ~26 public +
//   13 Poya day list for 2026.
// - No Poya day is included for months not listed above. Do not
//   assume every month has one marked here even though every month
//   has one in reality — this list is not exhaustive.
//
// Updating: replace the 2026 movable-date entries with the full
// official list (from the Government Printing Department gazette, or
// a source you can point this session at) rather than guessing
// remaining dates — Poya days are lunar and shift yearly.
//
// RESOLVED 2026-08-26 (was "UNRESOLVED CONFLICT" below): two
// independently-run searches this session — a general web search
// summarizing dailynews.lk/govt.sl/lakpura.com/gazette.lk, and a
// direct fetch of induwara.lk's "gazette-verified calendar" page —
// both agree Vesak Full Moon Poya Day is **1 May 2026**, coinciding
// with May Day, with 2 May also observed. gazette.lk itself only
// exposes the real gazette as a PDF this session's tooling can't
// read, so this still isn't a primary-source confirmation, but two
// independent secondary sources agreeing (and neither citing 30 May)
// is enough to correct the date. Moved from 30 May to 1 May below.
//
// Still missing, deliberately not filled in: Vap/Il/Unduvap Full Moon
// Poya (Oct/Nov/Dec) and Deepavali. induwara.lk's own answer for
// these was internally inconsistent with the standard Poya month
// cycle (labelled an October date "Il" — Il is traditionally
// November's Poya, Vap is October's), and no other reachable source
// gave exact Oct-Dec dates, so nothing from that source was used.
// Confirm against the actual gazette PDF (or a source that doesn't
// contradict the standard month-to-Poya-name mapping) before adding
// these three.
//
// Also still missing: full confirmation of Eid-ul-Fitr/Eid al-Adha
// beyond the approximate flag already used below per the moon-sighting
// note in this loop's planning brief — Islamic lunar dates aren't
// fixed in advance the way solar-calendar Poya days are.

class SriLankaHoliday {
  const SriLankaHoliday({required this.name, required this.isPoya});

  /// For moon-sighting-dependent Islamic dates (Eid, Milad-un-Nabi),
  /// the name itself carries "(approximate)" — they aren't fixed this
  /// far in advance the way solar-calendar Poya days are, and only
  /// `.name` is ever shown to the user (see calendar_day_cell.dart).
  final String name;
  final bool isPoya;
}

List<SriLankaHoliday> sriLankaHolidaysOn(DateTime date) {
  final holidays = <SriLankaHoliday>[];

  // Fixed-date civic holidays — recur every year.
  if (date.month == 1 && date.day == 1) {
    holidays.add(const SriLankaHoliday(name: "New Year's Day", isPoya: false));
  }
  if (date.month == 2 && date.day == 4) {
    holidays.add(const SriLankaHoliday(name: 'Independence Day', isPoya: false));
  }
  if (date.month == 5 && date.day == 1) {
    holidays.add(const SriLankaHoliday(name: 'May Day', isPoya: false));
  }
  if (date.month == 12 && date.day == 25) {
    holidays.add(const SriLankaHoliday(name: 'Christmas Day', isPoya: false));
  }

  // 2026 movable dates confirmed via search (see file header) — do
  // not extend this block for other years without a real source.
  if (date.year == 2026) {
    if (date.month == 1 && date.day == 3) {
      holidays.add(const SriLankaHoliday(name: 'Duruthu Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 1 && date.day == 15) {
      holidays.add(const SriLankaHoliday(name: 'Tamil Thai Pongal Day', isPoya: false));
    }
    if (date.month == 2 && date.day == 1) {
      holidays.add(const SriLankaHoliday(name: 'Navam Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 2 && date.day == 15) {
      holidays.add(const SriLankaHoliday(name: 'Maha Shivaratri Day', isPoya: false));
    }
    if (date.month == 3 && date.day == 2) {
      holidays.add(const SriLankaHoliday(name: 'Medin Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 3 && date.day == 21) {
      holidays.add(const SriLankaHoliday(name: 'Eid-ul-Fitr (approximate)', isPoya: false));
    }
    if (date.month == 4 && date.day == 1) {
      holidays.add(const SriLankaHoliday(name: 'Bak Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 4 && date.day == 3) {
      holidays.add(const SriLankaHoliday(name: 'Good Friday', isPoya: false));
    }
    if (date.month == 4 && (date.day == 13 || date.day == 14)) {
      holidays.add(const SriLankaHoliday(name: 'Sinhala & Tamil New Year', isPoya: false));
    }
    // Vesak Full Moon Poya Day — 1 May 2026, coinciding with May Day
    // (see the RESOLVED note above); 2 May is also observed.
    if (date.month == 5 && date.day == 1) {
      holidays.add(const SriLankaHoliday(name: 'Vesak Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 5 && date.day == 2) {
      holidays.add(const SriLankaHoliday(name: 'Day Following Vesak Full Moon Poya Day', isPoya: false));
    }
    if (date.month == 5 && date.day == 28) {
      holidays.add(const SriLankaHoliday(name: 'Eid al-Adha (approximate)', isPoya: false));
    }
    if (date.month == 6 && date.day == 29) {
      holidays.add(const SriLankaHoliday(name: 'Poson Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 7 && date.day == 29) {
      holidays.add(const SriLankaHoliday(name: 'Esala Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 8 && date.day == 26) {
      holidays.add(const SriLankaHoliday(name: 'Milad-un-Nabi (approximate)', isPoya: false));
    }
    if (date.month == 8 && date.day == 27) {
      holidays.add(const SriLankaHoliday(name: 'Nikini Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 9 && date.day == 26) {
      holidays.add(const SriLankaHoliday(name: 'Binara Full Moon Poya Day', isPoya: true));
    }
  }

  return holidays;
}
