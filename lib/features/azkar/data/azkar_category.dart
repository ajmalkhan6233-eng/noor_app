// Bismillahir Rahmanir Raheem — watermark: ALLAH

/// The azkar categories this feature is scoped for. `dbKey` must
/// match `azkar_categories.category_key` exactly (seeded in
/// `azkar_schema.dart`) for the five originally-seeded categories.
/// [childProtection] and [visitingGrave] were added on request
/// (2026-08-24 live-device review, matching categories present in a
/// reference app) but have no seeded `dbKey` match yet — real,
/// verified Hisn al-Muslim text for them hasn't been sourced, so
/// `AzkarRepository.itemsForCategory` correctly returns empty for
/// both and the row falls through to AzkarEmptyState's "not sourced
/// yet" message. That's deliberate: showing the category now signals
/// intent/roadmap without inventing the dua text itself, which
/// CLAUDE.md's Religious Content rule forbids.
enum AzkarCategory { morning, evening, afterPrayer, sleep, travel, childProtection, visitingGrave }

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
      case AzkarCategory.visitingGrave:
        return 'visiting_grave';
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
      case AzkarCategory.visitingGrave:
        return 'Visiting the Grave';
    }
  }
}
