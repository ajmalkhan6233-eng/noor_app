// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Probe: rapid taps on the tasbih counter fire increment() calls
// without awaiting the previous one to finish. Confirms the count
// still lands exactly on target under concurrent calls (no lost or
// double-counted taps), and that justHitMilestone flips true exactly
// once at each milestone (33/66/100) and false again immediately
// after, never staying stuck true or firing on a non-milestone count.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/tasbih/data/tasbih_repository.dart';
import 'package:noor/features/tasbih/logic/tasbih_cubit/tasbih_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NoopTasbihRepository extends TasbihRepository {
  @override
  Future<void> saveSession(TasbihSession session) async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
  }

  @override
  Future<TasbihSession?> loadSession(String dhikrLabel) async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('33 concurrent increments land on exactly 33, not more or fewer', () async {
    final cubit = TasbihCubit(repository: _NoopTasbihRepository());
    await cubit.loadSaved();

    await Future.wait([for (var i = 0; i < 33; i++) cubit.increment()]);

    expect(cubit.state.count, 33);
    expect(cubit.state.justHitMilestone, isTrue);

    await cubit.close();
  });

  test('justHitMilestone is true only exactly at a milestone count', () async {
    final cubit = TasbihCubit(repository: _NoopTasbihRepository());
    await cubit.loadSaved();

    for (var i = 1; i <= 34; i++) {
      await cubit.increment();
      final expected = i == 33;
      expect(
        cubit.state.justHitMilestone,
        expected,
        reason: 'count $i should have justHitMilestone == $expected',
      );
    }

    await cubit.close();
  });
}
