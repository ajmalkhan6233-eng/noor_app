// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// All tasbih business logic lives here — presentation only dispatches
// events (`increment`, `reset`) and listens to state. No SQL, no
// HapticFeedback calls, and no math happen in the UI layer.

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/haptics/haptic_service.dart';
import '../../data/tasbih_repository.dart';
import 'tasbih_state.dart';

class TasbihCubit extends Cubit<TasbihState> {
  TasbihCubit({
    TasbihRepository? repository,
    HapticService? hapticService,
    String dhikrLabel = 'SubhanAllah',
  })  : _repository = repository ?? TasbihRepository(),
        _haptics = hapticService ?? const HapticService(),
        super(TasbihState(dhikrLabel: dhikrLabel));

  final TasbihRepository _repository;
  final HapticService _haptics;

  /// Restores the last saved count for the current dhikr, if any.
  Future<void> loadSaved() async {
    final saved = await _repository.loadSession(state.dhikrLabel);
    if (saved != null) {
      emit(state.copyWith(count: saved.count, target: saved.target));
    }
  }

  /// Switches the active dhikr, restoring whatever count was last
  /// saved under that label (zero if it's never been counted before).
  Future<void> selectDhikr(String dhikrLabel) async {
    final saved = await _repository.loadSession(dhikrLabel);
    emit(
      TasbihState(
        dhikrLabel: dhikrLabel,
        count: saved?.count ?? 0,
        target: saved?.target,
      ),
    );
  }

  /// Increments the count by one, fires the appropriate haptic
  /// feedback, and persists the new count.
  Future<void> increment() async {
    final newCount = state.count + 1;
    final hitMilestone = _haptics.isMilestone(newCount);

    emit(state.copyWith(count: newCount, justHitMilestone: hitMilestone));
    await _haptics.feedbackForCount(newCount);
    await _persist();
  }

  /// Resets the count to zero and persists the reset.
  Future<void> reset() async {
    emit(state.copyWith(count: 0, justHitMilestone: false));
    await _persist();
  }

  Future<void> _persist() async {
    await _repository.saveSession(
      TasbihSession(
        dhikrLabel: state.dhikrLabel,
        count: state.count,
        target: state.target,
      ),
    );
  }
}
