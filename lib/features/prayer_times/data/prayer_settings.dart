// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// User-selectable calculation settings. Nothing here is ever assumed
// by default logic elsewhere — the cubit always carries an explicit
// [PrayerSettings], and the screen always shows it.

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
}

/// Which madhab's rule governs the Asr shadow-length calculation.
enum PrayerMadhab { shafi, hanafi }

/// The calculation method and madhab in effect — always explicit,
/// always visible on screen, never silently assumed.
class PrayerSettings {
  const PrayerSettings({
    this.method = PrayerCalculationMethod.muslimWorldLeague,
    this.madhab = PrayerMadhab.shafi,
  });

  final PrayerCalculationMethod method;
  final PrayerMadhab madhab;

  PrayerSettings copyWith({
    PrayerCalculationMethod? method,
    PrayerMadhab? madhab,
  }) {
    return PrayerSettings(
      method: method ?? this.method,
      madhab: madhab ?? this.madhab,
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
