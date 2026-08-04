// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One day cell: Gregorian day number and Hijri day number side by
// side, tinted for Ramadan, and marked for Eid al-Fitr, Eid al-Adha,
// Ashura, and the White Days.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../core/utils/islamic_occasion.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.gregorianDay,
    required this.hijri,
    required this.isToday,
  });

  final int gregorianDay;
  final HijriDate hijri;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final occasions = occasionsOn(hijri);
    final isRamadan = occasions.contains(IslamicOccasion.ramadan);
    final isWhiteDay = occasions.contains(IslamicOccasion.whiteDays);
    final hasMajorOccasion = occasions.any(
      (o) => o != IslamicOccasion.ramadan && o != IslamicOccasion.whiteDays,
    );

    final label = [
      '$gregorianDay ${hijri.formatted}',
      if (occasions.isNotEmpty) occasions.map((o) => o.label).join(', '),
    ].join(', ');

    return Semantics(
      label: label,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isToday
              ? AppColors.emerald
              : isRamadan
                  ? AppColors.emerald.withValues(alpha: 0.08)
                  : AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasMajorOccasion ? AppColors.emerald : AppColors.hairline,
            width: hasMajorOccasion ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$gregorianDay',
              style: TextStyle(
                color: isToday ? AppColors.paper : AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${hijri.day}',
              style: AppTypography.caption.copyWith(
                color: isToday ? AppColors.paper : AppColors.sage,
              ),
            ),
            if (hasMajorOccasion || isWhiteDay) ...[
              const SizedBox(height: 2),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasMajorOccasion
                      ? (isToday ? AppColors.paper : AppColors.emerald)
                      : Colors.transparent,
                  border: isWhiteDay && !hasMajorOccasion
                      ? Border.all(
                          color: isToday ? AppColors.paper : AppColors.emerald,
                        )
                      : null,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
