// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../data/pilgrimage_session.dart';
import '../../data/sai_direction.dart';
import '../../data/tawaf_reminders.dart';

/// Where the active pilgrimage session view currently is.
enum PilgrimageSessionStatus { loading, needsSetup, active, completed }

/// State for the active Tawaf/Sa'i session flow.
class PilgrimageSessionState extends Equatable {
  const PilgrimageSessionState({
    this.status = PilgrimageSessionStatus.loading,
    this.session,
    this.isMale = true,
    this.justHitMilestone = false,
  });

  final PilgrimageSessionStatus status;
  final PilgrimageSession? session;

  /// In-memory only, per §"Scope" — never persisted to the DB. Drives
  /// the Idtiba/Ramal reminders, which apply to men only.
  final bool isMale;

  /// True for a single emitted frame right after the 7th circuit or
  /// round completes, so the UI can trigger a matching visual pulse.
  final bool justHitMilestone;

  /// Idtiba/Ramal reminder state for the current Tawaf circuit count.
  TawafReminderState get tawafReminders => tawafRemindersFor(
    circuitCount: session?.tawafCircuitCount ?? 0,
    isMale: isMale,
  );

  /// Direction of the Sa'i round currently in progress (or just
  /// finished, once all 7 are complete).
  SaiDirection get saiDirection {
    final round = ((session?.saiRoundCount ?? 0) + 1).clamp(1, 7);
    return saiDirectionForRound(round);
  }

  PilgrimageSessionState copyWith({
    PilgrimageSessionStatus? status,
    PilgrimageSession? session,
    bool? isMale,
    bool? justHitMilestone,
  }) {
    return PilgrimageSessionState(
      status: status ?? this.status,
      session: session ?? this.session,
      isMale: isMale ?? this.isMale,
      justHitMilestone: justHitMilestone ?? false,
    );
  }

  @override
  List<Object?> get props => [status, session, isMale, justHitMilestone];
}
