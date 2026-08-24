// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Surfaces today's recommended Sunnah fasting days — Mondays/
// Thursdays, and the Hijri White Days (13th-15th of any month) — using
// the Hijri conversion already in lib/core/utils/hijri_date.dart. Only
// renders on a day one of these actually applies; silent otherwise,
// so it doesn't clutter Home on the ~5 days out of 7 neither applies.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../l10n/generated/app_localizations.dart';

bool isSunnahFastingWeekday(DateTime gregorianDate) {
  return gregorianDate.weekday == DateTime.monday ||
      gregorianDate.weekday == DateTime.thursday;
}

bool isHijriWhiteDay(int hijriDayOfMonth) =>
    hijriDayOfMonth >= 13 && hijriDayOfMonth <= 15;

class SunnahFastingCard extends StatelessWidget {
  const SunnahFastingCard({super.key, this.hijriOffsetDays = 0});

  final int hijriOffsetDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now();
    final hijriToday = HijriDate.fromGregorian(today, offsetDays: hijriOffsetDays);
    final isWeekday = isSunnahFastingWeekday(today);
    final isWhiteDay = isHijriWhiteDay(hijriToday.day);
    if (!isWeekday && !isWhiteDay) return const SizedBox.shrink();

    final reason = isWhiteDay && isWeekday
        ? l10n.sunnahFastingWhiteDayAndWeekdayReason
        : isWhiteDay
        ? l10n.sunnahFastingWhiteDayReason
        : l10n.sunnahFastingWeekdayReason;

    return Semantics(
      label: '${l10n.sunnahFastingCardTitle}. $reason',
      excludeSemantics: true,
      child: AppCard(
        borderColor: AppColors.goldBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.sunnahFastingCardTitle, style: AppTypography.sectionHeader),
            const SizedBox(height: 8),
            Text(reason, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}
