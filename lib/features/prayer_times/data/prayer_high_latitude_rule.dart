// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// How to bound Fajr/Isha at latitudes where the night is unusually
// short or long — mirrors `adhan`'s HighLatitudeRule, kept as our own
// enum so `logic`/`presentation` never import `adhan` directly.

enum PrayerHighLatitudeRule { middleOfNight, seventhOfNight, twilightAngle }

extension PrayerHighLatitudeRuleLabel on PrayerHighLatitudeRule {
  String get label {
    switch (this) {
      case PrayerHighLatitudeRule.middleOfNight:
        return 'Middle of the night';
      case PrayerHighLatitudeRule.seventhOfNight:
        return 'Seventh of the night';
      case PrayerHighLatitudeRule.twilightAngle:
        return 'Twilight angle';
    }
  }
}
