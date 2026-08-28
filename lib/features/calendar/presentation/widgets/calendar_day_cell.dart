// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One day cell: Gregorian day number and Hijri day number side by
// side, tinted for Ramadan, and marked for Eid al-Fitr, Eid al-Adha,
// Ashura, and the White Days — plus a small cyan dot for Sri Lankan
// public holidays/Poya days (see sri_lanka_holiday.dart for coverage
// caveats: a partial, honestly-labelled seed, not the full official
// calendar).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../core/utils/islamic_occasion.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../core/utils/sri_lanka_holiday.dart';
import '../../../../core/constants/app_color_tokens.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.gregorianDate,
    required this.hijri,
    required this.isToday,
    required this.onTap,
  });

  final DateTime gregorianDate;
  final HijriDate hijri;
  final bool isToday;
  final VoidCallback onTap;

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

    return SemanticButton(
      label: label,
      hint: 'Double tap for full details',
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          // Today: gold fill (light) so the dark context.colors.paper text
          // below stays readable — a solid emerald fill (dark) behind
          // dark text was inverted-contrast, effectively unreadable.
          color: isToday
              ? context.colors.gold
              : isRamadan
                  ? context.colors.gold.withValues(alpha: 0.08)
                  : context.colors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasMajorOccasion ? context.colors.gold : context.colors.hairline,
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
                color: isToday ? context.colors.paper : context.colors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${hijri.day}',
              style: AppTypography.caption(context.colors.sage).copyWith(
                color: isToday ? context.colors.paper : context.colors.sage,
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
                            ? (isToday ? context.colors.paper : context.colors.gold)
                            : Colors.transparent,
                        border: isWhiteDay && !hasMajorOccasion
                            ? Border.all(
                                color: isToday ? context.colors.paper : context.colors.gold,
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
                        color: isToday ? context.colors.paper : context.colors.accentSecondary,
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
