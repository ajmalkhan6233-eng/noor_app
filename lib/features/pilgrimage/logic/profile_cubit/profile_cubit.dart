// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Profile selection/creation for the pilgrimage tracker. No SQL and no
// HapticFeedback calls happen here — persistence goes through
// `PilgrimProfileRepository` only.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/pilgrim_profile.dart';
import '../../data/pilgrim_profile_repository.dart';
import 'profile_state.dart';

class PilgrimProfileCubit extends Cubit<PilgrimProfileState> {
  PilgrimProfileCubit({PilgrimProfileRepository? repository})
    : _repository = repository ?? PilgrimProfileRepository(),
      super(const PilgrimProfileState());

  final PilgrimProfileRepository _repository;

  /// Loads every known profile for the picker screen.
  Future<void> loadProfiles() async {
    emit(state.copyWith(isLoading: true));
    final profiles = await _repository.listProfiles();
    emit(state.copyWith(profiles: profiles, isLoading: false));
  }

  /// Selects an existing profile by [displayName].
  void select(PilgrimProfile profile) {
    emit(state.copyWith(selected: profile));
  }

  /// Creates a new profile and selects it, refusing a duplicate name.
  Future<void> createProfile({
    required String displayName,
    required PilgrimExperienceLevel experienceLevel,
    String? preferredLanguage,
  }) async {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return;

    final existing = await _repository.findByName(trimmed);
    if (existing != null) {
      emit(state.copyWith(selected: existing));
      return;
    }

    final created = await _repository.createProfile(
      displayName: trimmed,
      experienceLevel: experienceLevel,
      preferredLanguage: preferredLanguage,
    );
    emit(
      state.copyWith(profiles: [created, ...state.profiles], selected: created),
    );
  }
}
