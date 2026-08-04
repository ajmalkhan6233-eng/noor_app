// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Plain persistence/domain model mirroring the `pilgrimage_session`
// table. `currentStep` walks a simple Tawaf -> Sa'i -> done sequence
// for both Umrah and Hajj sessions in this commit.

enum PilgrimageType { umrah, hajj }

extension PilgrimageTypeValue on PilgrimageType {
  /// Value stored in `pilgrimage_session.type`.
  String get value => name;
}

PilgrimageType pilgrimageTypeFromValue(String value) {
  return PilgrimageType.values.firstWhere(
    (type) => type.value == value,
    orElse: () => PilgrimageType.umrah,
  );
}

/// The sequence of steps a session walks through. Kept as plain `int`
/// constants (rather than an enum) because `current_step` is stored
/// as a raw INTEGER column per the schema.
abstract final class PilgrimageStep {
  static const int notStarted = 0;
  static const int tawaf = 1;
  static const int sai = 2;
  static const int done = 3;
}

/// Immutable model mirroring the `pilgrimage_session` table.
class PilgrimageSession {
  const PilgrimageSession({
    this.sessionId,
    required this.pilgrimId,
    required this.type,
    this.currentStep = PilgrimageStep.notStarted,
    this.tawafCircuitCount = 0,
    this.saiRoundCount = 0,
    this.isCompleted = false,
    required this.startTime,
    this.endTime,
  });

  final int? sessionId;
  final int pilgrimId;
  final PilgrimageType type;
  final int currentStep;
  final int tawafCircuitCount;
  final int saiRoundCount;
  final bool isCompleted;
  final DateTime startTime;
  final DateTime? endTime;

  PilgrimageSession copyWith({
    int? sessionId,
    int? currentStep,
    int? tawafCircuitCount,
    int? saiRoundCount,
    bool? isCompleted,
    DateTime? endTime,
  }) {
    return PilgrimageSession(
      sessionId: sessionId ?? this.sessionId,
      pilgrimId: pilgrimId,
      type: type,
      currentStep: currentStep ?? this.currentStep,
      tawafCircuitCount: tawafCircuitCount ?? this.tawafCircuitCount,
      saiRoundCount: saiRoundCount ?? this.saiRoundCount,
      isCompleted: isCompleted ?? this.isCompleted,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
