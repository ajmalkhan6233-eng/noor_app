// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Sa'i: seven passes between Safa and Marwah, alternating direction
// each round.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/pilgrim_profile.dart';
import '../../logic/session_cubit/session_cubit.dart';
import '../../logic/session_cubit/session_state.dart';
import 'direction_card.dart';
import 'pilgrimage_counter_button.dart';
import 'pilgrimage_dua_card.dart';

class SaiStepView extends StatelessWidget {
  const SaiStepView({super.key, required this.profile, required this.state});

  final PilgrimProfile profile;
  final PilgrimageSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final count = state.session?.saiRoundCount ?? 0;
    final finished = count >= 7;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(l10n.saiScreenTitle, style: const TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(l10n.roundProgressLabel(count), style: const TextStyle(color: AppColors.sage)),
          const SizedBox(height: 16),
          DirectionCard(direction: state.saiDirection, experienceLevel: profile.experienceLevel),
          const SizedBox(height: 16),
          PilgrimageDuaCard(duaKey: 'sai', title: l10n.saiDuaSectionTitle),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: PilgrimageCounterButton(
                count: count,
                semanticLabel: l10n.saiCounterSemanticLabel,
                semanticHint: l10n.saiIncrementHint,
                pulsing: state.justHitMilestone,
                onTap: finished ? null : () => context.read<PilgrimageSessionCubit>().incrementSai(),
              ),
            ),
          ),
          if (finished)
            SemanticButton(
              label: l10n.completeSessionButtonLabel,
              hint: l10n.completeSessionButtonHint,
              onTap: () => context.read<PilgrimageSessionCubit>().completeSession(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.emerald, borderRadius: BorderRadius.circular(12)),
                child: Text(l10n.completeSessionButtonLabel, style: const TextStyle(color: AppColors.card, fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}
