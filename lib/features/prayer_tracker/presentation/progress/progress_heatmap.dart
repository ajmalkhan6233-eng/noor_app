// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Month calendar heatmap: one square per day, shaded by how many of the
// five prayers were ticked. Tap a day for its detail. Month arrows are
// 48dp targets and never go past the current month.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/corner_radius.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/progress/month_grid.dart';

class ProgressHeatmap extends StatelessWidget {
  const ProgressHeatmap({
    super.key,
    required this.month,
    required this.counts,
    required this.today,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onTapDay,
  });

  final DateTime month;
  final Map<DateTime, int> counts;
  final DateTime today;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final void Function(DateTime date, int count) onTapDay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final tag = Localizations.localeOf(context).toLanguageTag();
    final grid = buildMonthGrid(month, counts);
    return Column(
      children: [
        Row(
          children: [
            SemanticButton(
              label: l10n.progressPrevMonth,
              onTap: onPrevious,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.chevron_left, color: colors.gold),
              ),
            ),
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  DateFormat.yMMMM(tag).format(month),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyStrong(colors.ink),
                ),
              ),
            ),
            SemanticButton(
              label: l10n.progressNextMonth,
              enabled: canGoNext,
              onTap: onNext,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.chevron_right, color: canGoNext ? colors.gold : colors.hairline),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (final row in grid)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                for (final cell in row)
                  Expanded(child: cell == null ? const SizedBox(height: 40) : _cell(context, cell, l10n, tag)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _cell(BuildContext context, MonthCell cell, AppLocalizations l10n, String tag) {
    final colors = context.colors;
    final level = heatLevel(cell.count);
    final isToday = cell.date == DateTime(today.year, today.month, today.day);
    final isFuture = cell.date.isAfter(today);
    final shade = level == 0 ? Colors.transparent : colors.gold.withValues(alpha: 0.2 + 0.2 * level);
    final label = l10n.progressBarTapSemantics(DateFormat.MMMEd(tag).format(cell.date), cell.count);
    final box = Container(
      height: 40,
      margin: const EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: shade,
        borderRadius: BorderRadius.circular(context.radiusFor(8)),
        border: Border.all(
          color: isToday ? colors.gold : colors.hairline,
          width: isToday ? 2 : 1,
        ),
      ),
      child: Text(
        '${cell.date.day}',
        style: AppTypography.caption(
          level >= 3 ? colors.ink : (isFuture ? colors.hairline : colors.sage),
        ),
      ),
    );
    if (isFuture) return Semantics(label: label, excludeSemantics: true, child: box);
    return SemanticButton(
      label: label,
      hint: l10n.progressTapForDay,
      onTap: () => onTapDay(cell.date, cell.count),
      child: box,
    );
  }
}
