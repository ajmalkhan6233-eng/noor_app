// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Seven small bars, oldest first, the last one being today. Tapping a
/// bar reports that day through [onTapDay].
class ProgressWeekBars extends StatelessWidget {
  const ProgressWeekBars({
    super.key,
    required this.counts,
    required this.today,
    this.onTapDay,
  });

  final List<int> counts;
  final DateTime today;
  final void Function(DateTime date, int count)? onTapDay;

  static const double _maxHeight = 44;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tag = Localizations.localeOf(context).toLanguageTag();
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < counts.length; i++)
          _bar(
            colors,
            l10n,
            count: counts[i],
            date: DateTime(today.year, today.month, today.day - (counts.length - 1 - i)),
            weekday: DateFormat.E(tag).format(
              DateTime(today.year, today.month, today.day - (counts.length - 1 - i)),
            ),
            isToday: i == counts.length - 1,
          ),
      ],
    );
  }

  Widget _bar(
    AppColorTokens colors,
    AppLocalizations l10n, {
    required int count,
    required DateTime date,
    required String weekday,
    required bool isToday,
  }) {
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: _maxHeight,
          width: 22,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: count == 0 ? 3 : _maxHeight * count / 5),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, height, _) => Container(
                height: height,
                decoration: BoxDecoration(
                  color: count == 0
                      ? colors.hairline
                      : (count >= 5 ? colors.gold : colors.accentSecondary),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(weekday, style: AppTypography.caption(isToday ? colors.ink : colors.sage)),
        ),
      ],
    );
    final label = l10n.progressBarTapSemantics(weekday, count);
    return Expanded(
      child: onTapDay == null
          ? Semantics(label: label, excludeSemantics: true, child: column)
          : SemanticButton(
              label: label,
              hint: l10n.progressTapForDay,
              onTap: () => onTapDay!(date, count),
              child: column,
            ),
    );
  }
}
