// Bismillahir Rahmanir Raheem — watermark: ALLAH

/// The azkar categories this feature is scoped for. `dbKey` must
/// match `azkar_categories.category_key` exactly. [childProtection],
/// [illness], [distress], [debt], and [visitingGrave] were added
/// 2026-08-25 — real, verified Hisn al-Muslim text (asellam/HisnElMuslim,
/// the same MIT-licensed source already used for after_prayer/sleep/
/// travel — see assets/azkar/README.md) extracted programmatically
/// (direct JSON field copy, never hand-typed) and seeded via
/// database_migrations.dart's `oldVersion < 6` branch.
///
/// [visitingSick] was split out of [illness] 2026-08-26 (direct
/// request: "Visiting the Sick" as its own category, distinct from
/// general illness) — see azkar_supplementary_import_3.dart.
///
/// [funeral], [weather], [foodFasting], and [marriage] were added to
/// close real gaps flagged in assets/azkar/README.md's own audit note
/// — same MIT-licensed asellam/HisnElMuslim source, extracted the
/// same programmatic way, see azkar_supplementary_import_4.dart.
enum AzkarCategory {
  morning,
  evening,
  afterPrayer,
  sleep,
  travel,
  childProtection,
  illness,
  distress,
  debt,
  visitingGrave,
  visitingSick,
  funeral,
  weather,
  foodFasting,
  marriage,
}

extension AzkarCategoryDb on AzkarCategory {
  String get dbKey {
    switch (this) {
      case AzkarCategory.morning:
        return 'morning';
      case AzkarCategory.evening:
        return 'evening';
      case AzkarCategory.afterPrayer:
        return 'after_prayer';
      case AzkarCategory.sleep:
        return 'sleep';
      case AzkarCategory.travel:
        return 'travel';
      case AzkarCategory.childProtection:
        return 'child_protection';
      case AzkarCategory.illness:
        return 'illness';
      case AzkarCategory.distress:
        return 'distress';
      case AzkarCategory.debt:
        return 'debt';
      case AzkarCategory.visitingGrave:
        return 'visiting_grave';
      case AzkarCategory.visitingSick:
        return 'visiting_sick';
      case AzkarCategory.funeral:
        return 'funeral';
      case AzkarCategory.weather:
        return 'weather';
      case AzkarCategory.foodFasting:
        return 'food_fasting';
      case AzkarCategory.marriage:
        return 'marriage';
    }
  }

  String get label {
    switch (this) {
      case AzkarCategory.morning:
        return 'Morning';
      case AzkarCategory.evening:
        return 'Evening';
      case AzkarCategory.afterPrayer:
        return 'After Prayer';
      case AzkarCategory.sleep:
        return 'Sleep';
      case AzkarCategory.travel:
        return 'Travel';
      case AzkarCategory.childProtection:
        return 'Child Protection';
      case AzkarCategory.illness:
        return 'Illness';
      case AzkarCategory.distress:
        return 'Distress';
      case AzkarCategory.debt:
        return 'Debt';
      case AzkarCategory.visitingGrave:
        return 'Visiting the Grave';
      case AzkarCategory.visitingSick:
        return 'Visiting the Sick';
      case AzkarCategory.funeral:
        return 'Funeral & Bereavement';
      case AzkarCategory.weather:
        return 'Weather';
      case AzkarCategory.foodFasting:
        return 'Food & Fasting';
      case AzkarCategory.marriage:
        return 'Marriage';
    }
  }
}
