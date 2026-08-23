// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One day cell: Gregorian day number and Hijri day number side by
// side, tinted for Ramadan, and marked for Eid al-Fitr, Eid al-Adha,
// Ashura, and the White Days — plus a small cyan dot for Sri Lankan
// public holidays/Poya days (see sri_lanka_holiday.dart for coverage
// caveats: a partial, honestly-labelled seed, not the full official
// calendar).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../core/utils/islamic_occasion.dart';
import '../../../../core/utils/sri_lanka_holiday.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.gregorianDate,
    required this.hijri,
    required this.isToday,
  });

  final DateTime gregorianDate;
  final HijriDate hijri;
  final bool isToday;

  int get gregorianDay => gregorianDate.day;

  @override
  Widget build(BuildContext context) {
    final occasions = occasionsOn(hijri);
    final isRamadan = occasions.contains(IslamicOccasion.ramadan);
    final isWhiteDay = occasions.contains(IslamicOccasion.whiteDays);
    final hasMajorOccasion = occasions.any(
      (o) => o != IslamicOccasion.ramadan && o != IslamicOccasion.whiteDays,
    );
    final holidays = sriLankaHolidaysOn(gregorianDate);
    final hasHoliday = holidays.isNotEmpty;

    final label = [
      '$gregorianDay ${hijri.formatted}',
      if (occasions.isNotEmpty) occasions.map((o) => o.label).join(', '),
      if (holidays.isNotEmpty) holidays.map((h) => h.name).join(', '),
    ].join(', ');

    return Semantics(
      label: label,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          // Today: gold fill (light) so the dark AppColors.paper text
          // below stays readable — a solid emerald fill (dark) behind
          // dark text was inverted-contrast, effectively unreadable.
          color: isToday
              ? AppColors.gold
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
            if (hasMajorOccasion || isWhiteDay || hasHoliday) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasMajorOccasion || isWhiteDay)
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
                  if (hasHoliday) ...[
                    if (hasMajorOccasion || isWhiteDay) const SizedBox(width: 3),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isToday ? AppColors.paper : AppColors.accentSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
