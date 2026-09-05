// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

/// Immutable state for the tasbih (dhikr counter) feature.
class TasbihState extends Equatable {
  const TasbihState({
    this.count = 0,
    this.dhikrLabel = 'SubhanAllah',
    this.target,
    this.justHitMilestone = false,
    this.hapticsEnabled = true,
  });

  /// Current tap count.
  final int count;

  /// Label of the dhikr currently being counted (e.g. "SubhanAllah").
  final String dhikrLabel;

  /// Optional target count (e.g. 33, 99, 100) for progress display.
  final int? target;

  /// True for a single emitted frame right after a milestone (33/66/100)
  /// is reached, so the UI can trigger a matching visual pulse.
  final bool justHitMilestone;

  /// Whether a tap fires haptic feedback — user-toggleable, on by
  /// default. Persisted separately from the dhikr count itself.
  final bool hapticsEnabled;

  TasbihState copyWith({
    int? count,
    String? dhikrLabel,
    int? target,
    bool? justHitMilestone,
    bool? hapticsEnabled,
  }) {
    return TasbihState(
      count: count ?? this.count,
      dhikrLabel: dhikrLabel ?? this.dhikrLabel,
      target: target ?? this.target,
      justHitMilestone: justHitMilestone ?? false,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }

  @override
  List<Object?> get props => [count, dhikrLabel, target, justHitMilestone, hapticsEnabled];
}
