// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/tasbih/data/tasbih_repository.dart';
import 'package:noor/features/tasbih/logic/tasbih_cubit/tasbih_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SlowRepository extends TasbihRepository {
  @override
  Future<TasbihSession?> loadSession(String dhikrLabel) async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return null;
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('closing the cubit while a dhikr is loading does not throw', () async {
    final cubit = TasbihCubit(repository: _SlowRepository());
    final pending = cubit.selectDhikr('Alhamdulillah');
    await cubit.close();
    await pending;

    final pendingLoad = TasbihCubit(repository: _SlowRepository());
    final load = pendingLoad.loadSaved();
    await pendingLoad.close();
    await load;
  });
}
