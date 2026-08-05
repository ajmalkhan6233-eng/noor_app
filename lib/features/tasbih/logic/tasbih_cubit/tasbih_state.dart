import 'package:equatable/equatable.dart';

class TasbihState extends Equatable {
  final int count;
  final int? target;
  final String dhikrLabel;

  const TasbihState({
    required this.count,
    required this.dhikrLabel,
    this.target,
  });

  factory TasbihState.initial() => const TasbihState(
        count: 0,
        dhikrLabel: 'SubhanAllah',
      );

  static const Set<int> _milestones = {33, 66, 100};

  bool get isMilestone => _milestones.contains(count);
  bool get reachedTarget => target != null && count >= target!;

  TasbihState copyWith({int? count, int? target, String? dhikrLabel}) {
    return TasbihState(
      count: count ?? this.count,
      target: target ?? this.target,
      dhikrLabel: dhikrLabel ?? this.dhikrLabel,
    );
  }

  @override
  List<Object?> get props => [count, target, dhikrLabel];
}
