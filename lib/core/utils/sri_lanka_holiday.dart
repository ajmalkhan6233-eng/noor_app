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

class SriLankaHoliday {
  const SriLankaHoliday({required this.name, required this.isPoya});

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
    if (date.month == 3 && date.day == 2) {
      holidays.add(const SriLankaHoliday(name: 'Medin Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 4 && (date.day == 13 || date.day == 14)) {
      holidays.add(const SriLankaHoliday(name: 'Sinhala & Tamil New Year', isPoya: false));
    }
    if (date.month == 5 && date.day == 30) {
      holidays.add(const SriLankaHoliday(name: 'Vesak Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 6 && date.day == 29) {
      holidays.add(const SriLankaHoliday(name: 'Poson Full Moon Poya Day', isPoya: true));
    }
  }

  return holidays;
}
