// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Plain persistence/domain model for a pilgrim profile — deliberately
// minimal, no login, no account. Multiple profiles on one device are
// distinguished only by [displayName].

enum PilgrimExperienceLevel { beginner, experienced }

extension PilgrimExperienceLevelValue on PilgrimExperienceLevel {
  /// Value stored in `pilgrim_profile.experience_level`.
  String get value => name;
}

PilgrimExperienceLevel pilgrimExperienceLevelFromValue(String value) {
  return PilgrimExperienceLevel.values.firstWhere(
    (level) => level.value == value,
    orElse: () => PilgrimExperienceLevel.beginner,
  );
}

/// Immutable model mirroring the `pilgrim_profile` table.
class PilgrimProfile {
  const PilgrimProfile({
    this.id,
    required this.displayName,
    this.totalUmrahCompleted = 0,
    this.totalHajjCompleted = 0,
    required this.experienceLevel,
    this.preferredLanguage,
    required this.createdAt,
  });

  final int? id;
  final String displayName;
  final int totalUmrahCompleted;
  final int totalHajjCompleted;
  final PilgrimExperienceLevel experienceLevel;
  final String? preferredLanguage;
  final DateTime createdAt;

  PilgrimProfile copyWith({
    int? id,
    int? totalUmrahCompleted,
    int? totalHajjCompleted,
  }) {
    return PilgrimProfile(
      id: id ?? this.id,
      displayName: displayName,
      totalUmrahCompleted: totalUmrahCompleted ?? this.totalUmrahCompleted,
      totalHajjCompleted: totalHajjCompleted ?? this.totalHajjCompleted,
      experienceLevel: experienceLevel,
      preferredLanguage: preferredLanguage,
      createdAt: createdAt,
    );
  }
}
