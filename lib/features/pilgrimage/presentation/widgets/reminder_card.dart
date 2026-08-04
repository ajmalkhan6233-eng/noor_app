// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Idtiba/Ramal reminders during Tawaf — full explanations for
// beginners, a compact badge for experienced pilgrims. Only ever
// shown for male sessions; callers must gate on `isMale` themselves.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/pilgrim_profile.dart';
import '../../data/tawaf_reminders.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminders,
    required this.experienceLevel,
  });

  final TawafReminderState reminders;
  final PilgrimExperienceLevel experienceLevel;

  @override
  Widget build(BuildContext context) {
    if (!reminders.idtibaActive && !reminders.ramalActive) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    final isBeginner = experienceLevel == PilgrimExperienceLevel.beginner;

    if (!isBeginner) {
      return Wrap(
        spacing: 8,
        children: [
          if (reminders.idtibaActive) _badge(l10n.idtibaBadgeLabel),
          if (reminders.ramalActive) _badge(l10n.ramalBadgeLabel),
        ],
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reminders.idtibaActive) ...[
            Text(l10n.idtibaTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
            const SizedBox(height: 4),
            Text(l10n.idtibaExplanation, style: const TextStyle(color: AppColors.sage)),
          ],
          if (reminders.idtibaActive && reminders.ramalActive) const SizedBox(height: 12),
          if (reminders.ramalActive) ...[
            Text(l10n.ramalTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
            const SizedBox(height: 4),
            Text(l10n.ramalExplanation, style: const TextStyle(color: AppColors.sage)),
          ],
        ],
      ),
    );
  }

  Widget _badge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.emeraldSoft.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.emerald, fontSize: 12),
      ),
    );
  }
}
