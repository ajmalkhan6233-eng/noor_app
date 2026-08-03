// Bismillahir Rahmanir Raheem — watermark: ALLAH

/// The five azkar categories this feature is scoped for. `dbKey` must
/// match `azkar_categories.category_key` exactly (seeded in
/// `azkar_schema.dart`).
enum AzkarCategory { morning, evening, afterPrayer, sleep, travel }

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
    }
  }
}
