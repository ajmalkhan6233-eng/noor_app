// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 3's streak capsule: flame icon, "X DAY STREAK", and today's
// goals fraction/percent — backed by the same PrayerTrackerCubit data
// as DailyGoalsList (see home_overview_screen.dart, which provides one
// shared instance so both stay in sync).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/kinetic_digits.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_tracker/data/prayer_tracker_repository.dart';

class StreakCapsule extends StatelessWidget {
  const StreakCapsule({
    super.key,
    required this.streakDays,
    required this.completedCount,
  });

  final int streakDays;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = trackedPrayers.length;
    final percent = total == 0 ? 0 : ((completedCount / total) * 100).round();

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderColor: context.colors.gold,
      glowColor: context.colors.gold,
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: context.colors.gold, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KineticDigits(
                  text: l10n.dayStreakBadgeLabel(streakDays),
                  semanticsLabel: l10n.dayStreakBadgeLabel(streakDays),
                  style: TextStyle(
                    color: context.colors.gold,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.goalsProgressLabel(completedCount, total, percent),
                  style: AppTypography.caption(context.colors.sage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
