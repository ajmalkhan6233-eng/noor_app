// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure logic, no I/O: the two men-only Tawaf etiquette reminders.
// [circuitCount] is the number of *completed* circuits (0 before the
// first, up to 7 once Tawaf is finished).
//
// - Idtiba (right shoulder bared): applies to men only, for the whole
//   Tawaf, until the 7th circuit is completed — then the shoulder is
//   covered again.
// - Ramal (brisk, short steps): applies to men only, during the first
//   three circuits; from the 4th circuit onward the pace is normal.
//
// Women always walk at a normal pace with both shoulders covered, so
// neither reminder ever applies to them.

/// Snapshot of which Tawaf-only etiquette reminders currently apply.
class TawafReminderState {
  const TawafReminderState({
    required this.idtibaActive,
    required this.ramalActive,
  });

  /// True while the right shoulder should remain bared.
  final bool idtibaActive;

  /// True while brisk, short steps are called for.
  final bool ramalActive;
}

/// Reminder for someone who does not perform Idtiba/Ramal at all.
const TawafReminderState kNotApplicableTawafReminders = TawafReminderState(
  idtibaActive: false,
  ramalActive: false,
);

/// Computes the current Idtiba/Ramal state for [circuitCount] completed
/// circuits and whether the pilgrim [isMale].
TawafReminderState tawafRemindersFor({
  required int circuitCount,
  required bool isMale,
}) {
  if (!isMale) return kNotApplicableTawafReminders;

  return TawafReminderState(
    idtibaActive: circuitCount < 7,
    ramalActive: circuitCount < 3,
  );
}
