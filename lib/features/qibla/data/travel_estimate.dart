// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Rough, clearly-labelled travel-time estimates for the Qibla route
// card — pure arithmetic on the already-computed great-circle
// distance, no new data source. Rates are round, commonly-cited
// figures for each mode (commercial widebody cruise speed; a loaded
// camel caravan's typical daily distance; a walking pilgrim's typical
// daily distance) — approximations by design, never presented as
// precise.

abstract final class TravelEstimate {
  static const double _flyingKmPerHour = 850;
  static const double _camelKmPerDay = 40;
  static const double _footKmPerDay = 25;
  static const double _daysPerMonth = 30;

  static double flyingHours(double distanceKm) => distanceKm / _flyingKmPerHour;

  static double camelDays(double distanceKm) => distanceKm / _camelKmPerDay;

  static double footMonths(double distanceKm) => (distanceKm / _footKmPerDay) / _daysPerMonth;
}
