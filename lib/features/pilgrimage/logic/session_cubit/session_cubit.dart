// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Active Tawaf/Sa'i session logic — presentation only dispatches
// events and listens to state. No SQL happens in the UI layer; all
// persistence goes through `PilgrimageSessionRepository`.

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/pilgrimage_session.dart';
import '../../data/pilgrimage_session_repository.dart';
import 'session_state.dart';

class PilgrimageSessionCubit extends Cubit<PilgrimageSessionState> {
  PilgrimageSessionCubit({PilgrimageSessionRepository? repository})
    : _repository = repository ?? PilgrimageSessionRepository(),
      super(const PilgrimageSessionState());

  final PilgrimageSessionRepository _repository;
  int? _pilgrimId;

  /// Loads [pilgrimId]'s in-progress session, if any, so a Tawaf/Sa'i
  /// in progress resumes automatically after the app is reopened.
  Future<void> load(int pilgrimId) async {
    _pilgrimId = pilgrimId;
    emit(state.copyWith(status: PilgrimageSessionStatus.loading));
    final incomplete = await _repository.incompleteSessionFor(pilgrimId);
    emit(
      incomplete != null
          ? state.copyWith(
              status: PilgrimageSessionStatus.active,
              session: incomplete,
            )
          : const PilgrimageSessionState(
              status: PilgrimageSessionStatus.needsSetup,
            ),
    );
  }

  /// Sets the in-memory-only gender flag driving Idtiba/Ramal.
  void setGender({required bool isMale}) {
    emit(state.copyWith(isMale: isMale));
  }

  /// Starts a brand-new Umrah/Hajj session for the loaded profile.
  Future<void> startSession(PilgrimageType type) async {
    final pilgrimId = _pilgrimId;
    if (pilgrimId == null) return;
    final session = await _repository.createSession(
      pilgrimId: pilgrimId,
      type: type,
    );
    emit(
      state.copyWith(status: PilgrimageSessionStatus.active, session: session),
    );
  }

  /// Advances the Tawaf circuit count by one, clamped at 7. Fires a
  /// heavy pulse exactly when the 7th circuit completes.
  Future<void> incrementTawaf() async {
    final session = state.session;
    if (session == null || session.tawafCircuitCount >= 7) return;

    final next = session.tawafCircuitCount + 1;
    final justFinished = next == 7;
    emit(
      state.copyWith(
        session: session.copyWith(tawafCircuitCount: next),
        justHitMilestone: justFinished,
      ),
    );
    justFinished ? HapticFeedback.heavyImpact() : HapticFeedback.lightImpact();
    await _repository.updateTawafCount(session.sessionId!, next);
  }

  /// Advances the Sa'i round count by one, clamped at 7. Fires a heavy
  /// pulse exactly when the 7th round completes.
  Future<void> incrementSai() async {
    final session = state.session;
    if (session == null || session.saiRoundCount >= 7) return;

    final next = session.saiRoundCount + 1;
    final justFinished = next == 7;
    emit(
      state.copyWith(
        session: session.copyWith(saiRoundCount: next),
        justHitMilestone: justFinished,
      ),
    );
    justFinished ? HapticFeedback.heavyImpact() : HapticFeedback.lightImpact();
    await _repository.updateSaiCount(session.sessionId!, next);
  }

  /// Moves from the Tawaf step to the Sa'i step.
  Future<void> advanceToSai() async {
    final session = state.session;
    if (session == null) return;
    await _repository.updateCurrentStep(session.sessionId!, PilgrimageStep.sai);
    emit(
      state.copyWith(
        session: session.copyWith(currentStep: PilgrimageStep.sai),
      ),
    );
  }

  /// Marks the session complete, which also bumps the profile's
  /// lifetime Umrah/Hajj counter.
  Future<void> completeSession() async {
    final session = state.session;
    if (session == null) return;
    await _repository.completeSession(session);
    emit(
      state.copyWith(
        status: PilgrimageSessionStatus.completed,
        session: session.copyWith(
          isCompleted: true,
          currentStep: PilgrimageStep.done,
        ),
      ),
    );
  }
}
