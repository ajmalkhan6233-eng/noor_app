// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/corner_radius.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/progress/streak_milestones.dart';

/// The four streak badges; earned ones are coloured, the rest quiet.
class ProgressBadgesRow extends StatelessWidget {
  const ProgressBadgesRow({super.key, required this.bestStreak});

  final int bestStreak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final next = nextMilestone(bestStreak);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(l10n.progressBadgesTitle, style: AppTypography.caption(colors.sage)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final badge in ProgressBadge.values)
              Expanded(child: _Badge(badge: badge, earned: isEarned(badge, bestStreak))),
          ],
        ),
        if (next != null) ...[
          const SizedBox(height: 6),
          Text(l10n.progressNextBadge(next), style: AppTypography.caption(colors.sage)),
        ],
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.badge, required this.earned});

  final ProgressBadge badge;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return Semantics(
      label: earned ? l10n.progressBadgeEarned(badge.days) : l10n.progressBadgeLocked(badge.days),
      excludeSemantics: true,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: context.colors.flatSurfaces ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: context.colors.flatSurfaces
                  ? BorderRadius.circular(context.radiusFor(0))
                  : null,
              color: earned ? colors.gold.withValues(alpha: 0.18) : Colors.transparent,
              border: Border.all(color: earned ? colors.gold : colors.hairline, width: earned ? 2 : 1),
            ),
            child: Icon(
              earned ? Icons.workspace_premium : Icons.lock_outline,
              size: 22,
              color: earned ? colors.gold : colors.hairline,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              l10n.progressBadgeLabel(badge.days),
              style: AppTypography.caption(earned ? colors.ink : colors.sage),
            ),
          ),
        ],
      ),
    );
  }
}
