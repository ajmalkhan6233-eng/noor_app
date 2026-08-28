// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Sri Lankan public holidays and Poya (full moon) days, for the
// Islamic Calendar's "also mark local holidays" feature.
//
// Source: Ministry of Home Affairs, 2026 government holiday schedule:
// https://moha.gov.lk/web/images/latest_document/government_holidays/2026/2026_E.pdf
// The government-linked listing reproduces the same 26 dates:
// https://govt.sl/en-us/public-holidays.php
//
// - 4 fixed-date civic holidays (New Year's Day, Independence Day,
//   May Day, Christmas) recur every year and need no per-year
//   verification.
// The official listing distinguishes Vesak (1 May) from Adhi Poson
// (30 May). Do not relabel either date as Adhi Vesak.

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

  // 2026 dates from the official government schedule — do not extend
  // this block for other years without a dated source.
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
    // Vesak Full Moon Poya Day — the official schedule places this on
    // 1 May; 2 May is also observed.
    if (date.month == 5 && date.day == 1) {
      holidays.add(const SriLankaHoliday(name: 'Vesak Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 5 && date.day == 2) {
      holidays.add(const SriLankaHoliday(name: 'Day Following Vesak Full Moon Poya Day', isPoya: false));
    }
    if (date.month == 5 && date.day == 28) {
      holidays.add(const SriLankaHoliday(name: 'Eid al-Adha (approximate)', isPoya: false));
    }
    if (date.month == 5 && date.day == 30) {
      holidays.add(const SriLankaHoliday(name: 'Adhi Poson Full Moon Poya Day', isPoya: true));
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
    if (date.month == 10 && date.day == 25) {
      holidays.add(const SriLankaHoliday(name: 'Vap Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 11 && date.day == 8) {
      holidays.add(const SriLankaHoliday(name: 'Deepavali Festival Day', isPoya: false));
    }
    if (date.month == 11 && date.day == 24) {
      holidays.add(const SriLankaHoliday(name: 'Ill Full Moon Poya Day', isPoya: true));
    }
    if (date.month == 12 && date.day == 23) {
      holidays.add(const SriLankaHoliday(name: 'Unduvap Full Moon Poya Day', isPoya: true));
    }
  }

  return holidays;
}
