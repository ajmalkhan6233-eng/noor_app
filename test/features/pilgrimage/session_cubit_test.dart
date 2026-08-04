// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/pilgrimage/data/pilgrim_profile_repository.dart';
import 'package:noor/features/pilgrimage/data/pilgrimage_session.dart';
import 'package:noor/features/pilgrimage/data/pilgrimage_session_repository.dart';
import 'package:noor/features/pilgrimage/logic/session_cubit/session_cubit.dart';
import 'package:noor/features/pilgrimage/logic/session_cubit/session_state.dart';

/// Records lifetime-counter increments in memory instead of touching
/// `sqflite_sqlcipher`, which needs a platform channel unit tests don't
/// have.
class _FakeProfileRepository extends PilgrimProfileRepository {
  final Map<int, int> umrahCounts = {};
  final Map<int, int> hajjCounts = {};

  @override
  Future<void> incrementUmrahCompleted(int pilgrimId) async {
    umrahCounts[pilgrimId] = (umrahCounts[pilgrimId] ?? 0) + 1;
  }

  @override
  Future<void> incrementHajjCompleted(int pilgrimId) async {
    hajjCounts[pilgrimId] = (hajjCounts[pilgrimId] ?? 0) + 1;
  }
}

/// In-memory stand-in for the real session table.
class _FakeSessionRepository extends PilgrimageSessionRepository {
  _FakeSessionRepository(this._profiles);

  final _FakeProfileRepository _profiles;
  final Map<int, PilgrimageSession> _sessions = {};
  int _nextId = 1;

  @override
  Future<PilgrimageSession?> incompleteSessionFor(int pilgrimId) async {
    for (final session in _sessions.values) {
      if (session.pilgrimId == pilgrimId && !session.isCompleted) {
        return session;
      }
    }
    return null;
  }

  @override
  Future<PilgrimageSession> createSession({
    required int pilgrimId,
    required PilgrimageType type,
  }) async {
    final session = PilgrimageSession(
      sessionId: _nextId++,
      pilgrimId: pilgrimId,
      type: type,
      currentStep: PilgrimageStep.tawaf,
      startTime: DateTime.now(),
    );
    _sessions[session.sessionId!] = session;
    return session;
  }

  @override
  Future<void> updateTawafCount(int sessionId, int count) async {
    _sessions[sessionId] = _sessions[sessionId]!.copyWith(tawafCircuitCount: count);
  }

  @override
  Future<void> updateSaiCount(int sessionId, int count) async {
    _sessions[sessionId] = _sessions[sessionId]!.copyWith(saiRoundCount: count);
  }

  @override
  Future<void> updateCurrentStep(int sessionId, int step) async {
    _sessions[sessionId] = _sessions[sessionId]!.copyWith(currentStep: step);
  }

  @override
  Future<void> completeSession(PilgrimageSession session) async {
    _sessions[session.sessionId!] = session.copyWith(isCompleted: true);
    if (session.type == PilgrimageType.umrah) {
      await _profiles.incrementUmrahCompleted(session.pilgrimId);
    } else {
      await _profiles.incrementHajjCompleted(session.pilgrimId);
    }
  }
}

Future<void> _finishTawafAndSai(PilgrimageSessionCubit cubit) async {
  for (var i = 0; i < 7; i++) {
    await cubit.incrementTawaf();
  }
  await cubit.advanceToSai();
  for (var i = 0; i < 7; i++) {
    await cubit.incrementSai();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PilgrimageSessionCubit circuit/round counting', () {
    test('increments 1 through 7 and clamps at 7', () async {
      final repo = _FakeSessionRepository(_FakeProfileRepository());
      final cubit = PilgrimageSessionCubit(repository: repo);
      await cubit.load(1);
      await cubit.startSession(PilgrimageType.umrah);

      for (var i = 1; i <= 7; i++) {
        await cubit.incrementTawaf();
        expect(cubit.state.session!.tawafCircuitCount, i);
      }

      // Extra taps beyond 7 must not advance further.
      await cubit.incrementTawaf();
      expect(cubit.state.session!.tawafCircuitCount, 7);
      await cubit.close();
    });

    test('a fresh session starts its counters at zero', () async {
      final repo = _FakeSessionRepository(_FakeProfileRepository());
      final cubit = PilgrimageSessionCubit(repository: repo);
      await cubit.load(1);
      await cubit.startSession(PilgrimageType.hajj);

      expect(cubit.state.session!.tawafCircuitCount, 0);
      expect(cubit.state.session!.saiRoundCount, 0);
      await cubit.close();
    });

    test('justHitMilestone is true only right at the 7th circuit', () async {
      final repo = _FakeSessionRepository(_FakeProfileRepository());
      final cubit = PilgrimageSessionCubit(repository: repo);
      await cubit.load(1);
      await cubit.startSession(PilgrimageType.umrah);

      for (var i = 1; i < 7; i++) {
        await cubit.incrementTawaf();
        expect(cubit.state.justHitMilestone, isFalse);
      }
      await cubit.incrementTawaf();
      expect(cubit.state.justHitMilestone, isTrue);
      await cubit.close();
    });
  });

  group('PilgrimageSessionCubit profile increments', () {
    test('completing an Umrah session increments only the Umrah counter', () async {
      final profiles = _FakeProfileRepository();
      final cubit = PilgrimageSessionCubit(repository: _FakeSessionRepository(profiles));
      await cubit.load(5);
      await cubit.startSession(PilgrimageType.umrah);
      await _finishTawafAndSai(cubit);

      await cubit.completeSession();

      expect(profiles.umrahCounts[5], 1);
      expect(profiles.hajjCounts[5], isNull);
      await cubit.close();
    });

    test('completing a Hajj session increments only the Hajj counter', () async {
      final profiles = _FakeProfileRepository();
      final cubit = PilgrimageSessionCubit(repository: _FakeSessionRepository(profiles));
      await cubit.load(9);
      await cubit.startSession(PilgrimageType.hajj);
      await _finishTawafAndSai(cubit);

      await cubit.completeSession();

      expect(profiles.hajjCounts[9], 1);
      expect(profiles.umrahCounts[9], isNull);
      await cubit.close();
    });

    test('multiple completions accumulate', () async {
      final profiles = _FakeProfileRepository();
      final sessionRepo = _FakeSessionRepository(profiles);

      for (var i = 0; i < 3; i++) {
        final cubit = PilgrimageSessionCubit(repository: sessionRepo);
        await cubit.load(2);
        await cubit.startSession(PilgrimageType.umrah);
        await _finishTawafAndSai(cubit);
        await cubit.completeSession();
        await cubit.close();
      }

      expect(profiles.umrahCounts[2], 3);
    });
  });

  group('PilgrimageSessionCubit resume', () {
    test('load restores an incomplete session instead of starting fresh', () async {
      final profiles = _FakeProfileRepository();
      final sessionRepo = _FakeSessionRepository(profiles);

      final first = PilgrimageSessionCubit(repository: sessionRepo);
      await first.load(3);
      await first.startSession(PilgrimageType.umrah);
      await first.incrementTawaf();
      await first.incrementTawaf();
      await first.close();

      final resumed = PilgrimageSessionCubit(repository: sessionRepo);
      await resumed.load(3);

      expect(resumed.state.status, PilgrimageSessionStatus.active);
      expect(resumed.state.session!.tawafCircuitCount, 2);
      await resumed.close();
    });
  });
}
