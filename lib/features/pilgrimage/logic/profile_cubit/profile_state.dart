// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../data/pilgrim_profile.dart';

/// State for picking or creating a pilgrim profile.
class PilgrimProfileState extends Equatable {
  const PilgrimProfileState({
    this.profiles = const [],
    this.selected,
    this.isLoading = false,
  });

  /// All known profiles, for the picker list.
  final List<PilgrimProfile> profiles;

  /// The profile chosen (or just created) to track a session for.
  final PilgrimProfile? selected;

  final bool isLoading;

  PilgrimProfileState copyWith({
    List<PilgrimProfile>? profiles,
    PilgrimProfile? selected,
    bool? isLoading,
  }) {
    return PilgrimProfileState(
      profiles: profiles ?? this.profiles,
      selected: selected ?? this.selected,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [profiles, selected, isLoading];
}
