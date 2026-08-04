// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/pilgrimage/data/pilgrim_profile.dart';
import 'package:noor/features/pilgrimage/data/pilgrim_profile_repository.dart';
import 'package:noor/features/pilgrimage/logic/profile_cubit/profile_cubit.dart';

class _FakeProfileRepository extends PilgrimProfileRepository {
  final List<PilgrimProfile> _profiles = [];
  int _nextId = 1;

  @override
  Future<List<PilgrimProfile>> listProfiles() async => List.of(_profiles);

  @override
  Future<PilgrimProfile?> findByName(String displayName) async {
    for (final profile in _profiles) {
      if (profile.displayName == displayName) return profile;
    }
    return null;
  }

  @override
  Future<PilgrimProfile> createProfile({
    required String displayName,
    required PilgrimExperienceLevel experienceLevel,
    String? preferredLanguage,
  }) async {
    final profile = PilgrimProfile(
      id: _nextId++,
      displayName: displayName,
      experienceLevel: experienceLevel,
      preferredLanguage: preferredLanguage,
      createdAt: DateTime.now(),
    );
    _profiles.add(profile);
    return profile;
  }
}

void main() {
  group('PilgrimProfileCubit', () {
    test('loadProfiles surfaces every known profile', () async {
      final repository = _FakeProfileRepository();
      await repository.createProfile(
        displayName: 'Yusuf',
        experienceLevel: PilgrimExperienceLevel.beginner,
      );
      final cubit = PilgrimProfileCubit(repository: repository);

      await cubit.loadProfiles();

      expect(cubit.state.profiles, hasLength(1));
      expect(cubit.state.profiles.first.displayName, 'Yusuf');
      await cubit.close();
    });

    test('createProfile adds and selects a new profile', () async {
      final cubit = PilgrimProfileCubit(repository: _FakeProfileRepository());

      await cubit.createProfile(
        displayName: 'Amina',
        experienceLevel: PilgrimExperienceLevel.experienced,
      );

      expect(cubit.state.selected?.displayName, 'Amina');
      expect(cubit.state.selected?.experienceLevel, PilgrimExperienceLevel.experienced);
      await cubit.close();
    });

    test('createProfile with a duplicate name selects the existing profile', () async {
      final repository = _FakeProfileRepository();
      final cubit = PilgrimProfileCubit(repository: repository);
      await cubit.createProfile(displayName: 'Bilal', experienceLevel: PilgrimExperienceLevel.beginner);
      final firstId = cubit.state.selected?.id;

      await cubit.createProfile(displayName: 'Bilal', experienceLevel: PilgrimExperienceLevel.experienced);

      expect(cubit.state.selected?.id, firstId);
      expect(cubit.state.profiles, hasLength(1));
      await cubit.close();
    });

    test('createProfile ignores a blank name', () async {
      final cubit = PilgrimProfileCubit(repository: _FakeProfileRepository());

      await cubit.createProfile(displayName: '   ', experienceLevel: PilgrimExperienceLevel.beginner);

      expect(cubit.state.selected, isNull);
      await cubit.close();
    });
  });
}
