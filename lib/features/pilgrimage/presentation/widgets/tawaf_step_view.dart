// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Tawaf: seven circuits around the Kaaba. Idtiba/Ramal reminders show
// only for male sessions, full explanations in beginner mode.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/pilgrim_profile.dart';
import '../../logic/session_cubit/session_cubit.dart';
import '../../logic/session_cubit/session_state.dart';
import 'pilgrimage_counter_button.dart';
import 'reminder_card.dart';

class TawafStepView extends StatelessWidget {
  const TawafStepView({super.key, required this.profile, required this.state});

  final PilgrimProfile profile;
  final PilgrimageSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final count = state.session?.tawafCircuitCount ?? 0;
    final finished = count >= 7;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(l10n.tawafScreenTitle, style: const TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(l10n.circuitProgressLabel(count), style: const TextStyle(color: AppColors.sage)),
          const SizedBox(height: 16),
          if (state.isMale)
            ReminderCard(reminders: state.tawafReminders, experienceLevel: profile.experienceLevel),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: PilgrimageCounterButton(
                count: count,
                semanticLabel: l10n.tawafCounterSemanticLabel,
                semanticHint: l10n.tawafIncrementHint,
                pulsing: state.justHitMilestone,
                onTap: finished ? null : () => context.read<PilgrimageSessionCubit>().incrementTawaf(),
              ),
            ),
          ),
          if (finished) ...[
            Semantics(
              liveRegion: true,
              label: l10n.tawafCompleteMessage,
              child: Text(l10n.tawafCompleteMessage, style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            SemanticButton(
              label: l10n.continueToSaiButtonLabel,
              hint: l10n.continueToSaiButtonHint,
              onTap: () => context.read<PilgrimageSessionCubit>().advanceToSai(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.emerald, borderRadius: BorderRadius.circular(12)),
                child: Text(l10n.continueToSaiButtonLabel, style: const TextStyle(color: AppColors.card, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
