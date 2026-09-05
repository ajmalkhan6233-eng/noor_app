// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// All tasbih business logic lives here — presentation only dispatches
// events (`increment`, `reset`) and listens to state. No SQL, no
// HapticFeedback calls, and no math happen in the UI layer.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/haptics/haptic_service.dart';
import '../../data/tasbih_repository.dart';
import 'tasbih_state.dart';

const _hapticsPrefKey = 'tasbih_haptics_enabled';

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

  /// Restores the last saved count for the current dhikr, and the
  /// user's vibration preference, if any.
  Future<void> loadSaved() async {
    final saved = await _repository.loadSession(state.dhikrLabel);
    final prefs = await SharedPreferences.getInstance();
    final hapticsEnabled = prefs.getBool(_hapticsPrefKey) ?? true;
    emit(
      state.copyWith(
        count: saved?.count,
        target: saved?.target,
        hapticsEnabled: hapticsEnabled,
      ),
    );
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
        hapticsEnabled: state.hapticsEnabled,
      ),
    );
  }

  /// Flips whether taps fire haptic feedback, persisting the choice.
  Future<void> toggleHaptics() async {
    final enabled = !state.hapticsEnabled;
    emit(state.copyWith(hapticsEnabled: enabled));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsPrefKey, enabled);
  }

  /// Increments the count by one, fires the appropriate haptic
  /// feedback, and persists the new count.
  Future<void> increment() async {
    final newCount = state.count + 1;
    final hitMilestone = _haptics.isMilestone(newCount);

    emit(state.copyWith(count: newCount, justHitMilestone: hitMilestone));
    if (state.hapticsEnabled) await _haptics.feedbackForCount(newCount);
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
