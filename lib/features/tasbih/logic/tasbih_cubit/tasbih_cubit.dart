import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/haptics/haptic_service.dart';
import 'tasbih_state.dart';

/// Owns all Tasbih counting logic. The presentation layer only ever
/// calls increment() / reset() / setDhikr() — it never touches
/// haptics or count math directly (rule 3 in .clinerules).
class TasbihCubit extends Cubit<TasbihState> {
  TasbihCubit({HapticService? hapticService})
      : _haptics = hapticService ?? HapticService.instance,
        super(TasbihState.initial());

  final HapticService _haptics;

  Future<void> increment() async {
    final newCount = state.count + 1;
    emit(state.copyWith(count: newCount));
    await _haptics.onCount(newCount);
  }

  Future<void> reset() async {
    emit(state.copyWith(count: 0));
    await _haptics.onReset();
  }

  void setDhikr(String label) {
    emit(state.copyWith(dhikrLabel: label));
  }

  void setTarget(int? target) {
    emit(state.copyWith(target: target));
  }
}
