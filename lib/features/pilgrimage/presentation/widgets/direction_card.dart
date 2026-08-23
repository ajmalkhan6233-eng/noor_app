// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Current Sa'i walking direction — a full explanation for beginners,
// just the direction indicator for experienced pilgrims.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/pilgrim_profile.dart';
import '../../data/sai_direction.dart';

class DirectionCard extends StatelessWidget {
  const DirectionCard({
    super.key,
    required this.direction,
    required this.experienceLevel,
  });

  final SaiDirection direction;
  final PilgrimExperienceLevel experienceLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = direction == SaiDirection.safaToMarwah
        ? l10n.saiDirectionSafaToMarwah
        : l10n.saiDirectionMarwahToSafa;
    final isBeginner = experienceLevel == PilgrimExperienceLevel.beginner;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_forward, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink),
              ),
            ],
          ),
          if (isBeginner) ...[
            const SizedBox(height: 8),
            Text(l10n.saiDirectionExplanation, style: const TextStyle(color: AppColors.sage)),
          ],
        ],
      ),
    );
  }
}
