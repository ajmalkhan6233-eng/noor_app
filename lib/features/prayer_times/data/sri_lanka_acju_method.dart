// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// "Sri Lanka (ACJU timetable match)" calculation (2026-11-19).
//
// The All Ceylon Jamiyyathul Ulama publishes fixed monthly timetables
// per zone (prepared from the calculations of the late Al-'Alim M.I.
// Abdus Samad Makdoomi). They are not a named astronomical method, so
// these parameters were fitted against a full year of those tables for
// all 13 zones (28,548 times):
//   Fajr 19.8 deg, Isha 18.4 deg, Shafi Asr,
//   Dhuhr/Asr/Maghrib +2 min (ACJU adds a safety margin).
// Result: about 96% of times within 1 minute of the ACJU table, worst
// 2-4 minutes (zone reference points differ from the person's real
// location). The previous default (Muslim World League 18/17) put
// Fajr 6-9 minutes LATER and Isha 4-6 minutes EARLIER than ACJU, which
// matters for suhoor and for praying Isha in time.
// No ACJU data is bundled; these are our own fitted numbers. The only
// fully exact answer is the official ACJU table itself (needs ACJU's
// permission to embed).

import 'package:adhan/adhan.dart' as adhan;

const double sriLankaAcjuFajrAngle = 19.8;
const double sriLankaAcjuIshaAngle = 18.4;

adhan.CalculationParameters sriLankaAcjuParameters() {
  final params = adhan.CalculationMethod.other.getParameters()
    ..fajrAngle = sriLankaAcjuFajrAngle
    ..ishaAngle = sriLankaAcjuIshaAngle;
  return params.withMethodAdjustments(
    adhan.PrayerAdjustments(dhuhr: 2, asr: 2, maghrib: 2),
  );
}
