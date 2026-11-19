// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// User-selectable calculation settings. Nothing here is ever assumed
// by default logic elsewhere — the cubit always carries an explicit
// [PrayerSettings], and the screen always shows it.

import 'prayer_adjustments.dart';
import 'prayer_high_latitude_rule.dart';

/// Standard prayer-time calculation methods, mapped onto the `adhan`
/// package's equivalents inside `PrayerRepository` only.
enum PrayerCalculationMethod {
  muslimWorldLeague,
  ummAlQura,
  egyptian,
  karachi,
  isna,
  dubai,
  qatar,
  kuwait,
  singapore,
  turkey,
  tehran,
  // Appended at the end: values are persisted by name.
  sriLankaAcju,
}

/// Which madhab's rule governs the Asr shadow-length calculation.
enum PrayerMadhab { shafi, hanafi }

/// The calculation method and madhab in effect — always explicit,
/// always visible on screen, never silently assumed.
class PrayerSettings {
  const PrayerSettings({
    // Default for Sri Lanka since 2026-11-19: matched to the ACJU
    // timetables (see sri_lanka_acju_method.dart). MWL was 5-9 minutes
    // off ACJU for Fajr and Isha.
    this.method = PrayerCalculationMethod.sriLankaAcju,
    this.madhab = PrayerMadhab.shafi,
    this.highLatitudeRule = PrayerHighLatitudeRule.middleOfNight,
    this.adjustments = const PrayerAdjustmentMinutes(),
  });

  final PrayerCalculationMethod method;
  final PrayerMadhab madhab;
  final PrayerHighLatitudeRule highLatitudeRule;
  final PrayerAdjustmentMinutes adjustments;

  PrayerSettings copyWith({
    PrayerCalculationMethod? method,
    PrayerMadhab? madhab,
    PrayerHighLatitudeRule? highLatitudeRule,
    PrayerAdjustmentMinutes? adjustments,
  }) {
    return PrayerSettings(
      method: method ?? this.method,
      madhab: madhab ?? this.madhab,
      highLatitudeRule: highLatitudeRule ?? this.highLatitudeRule,
      adjustments: adjustments ?? this.adjustments,
    );
  }
}

/// Human-readable labels for [PrayerCalculationMethod], for the
/// method-selector UI.
extension PrayerCalculationMethodLabel on PrayerCalculationMethod {
  String get label {
    switch (this) {
      case PrayerCalculationMethod.muslimWorldLeague:
        return 'Muslim World League';
      case PrayerCalculationMethod.ummAlQura:
        return 'Umm al-Qura';
      case PrayerCalculationMethod.egyptian:
        return 'Egyptian General Authority';
      case PrayerCalculationMethod.karachi:
        return 'University of Islamic Sciences, Karachi';
      case PrayerCalculationMethod.isna:
        return 'ISNA (North America)';
      case PrayerCalculationMethod.dubai:
        return 'Dubai';
      case PrayerCalculationMethod.qatar:
        return 'Qatar';
      case PrayerCalculationMethod.kuwait:
        return 'Kuwait';
      case PrayerCalculationMethod.singapore:
        return 'Singapore';
      case PrayerCalculationMethod.turkey:
        return 'Turkey (Diyanet)';
      case PrayerCalculationMethod.tehran:
        return 'Tehran (Institute of Geophysics)';
      case PrayerCalculationMethod.sriLankaAcju:
        return 'Sri Lanka (ACJU timetable match)';
    }
  }
}

/// Human-readable labels for [PrayerMadhab], for the madhab selector.
extension PrayerMadhabLabel on PrayerMadhab {
  String get label {
    switch (this) {
      case PrayerMadhab.shafi:
        return 'Shafi';
      case PrayerMadhab.hanafi:
        return 'Hanafi';
    }
  }
}
