// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Bottom sheet for one day: which of the five prayers were ticked.
// Opened by tapping the ring (today) or a day bar / heatmap cell. It is
// read-only; ticking happens on Home.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/prayer_tracker_repository.dart';

Future<void> showProgressDaySheet(
  BuildContext context, {
  required DateTime date,
  required Future<Set<String>> Function(DateTime date) loadPrayers,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.colors.card,
    isScrollControlled: true,
    builder: (sheetContext) => _DaySheet(date: date, loadPrayers: loadPrayers),
  );
}

class _DaySheet extends StatelessWidget {
  const _DaySheet({required this.date, required this.loadPrayers});

  final DateTime date;
  final Future<Set<String>> Function(DateTime date) loadPrayers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final tag = Localizations.localeOf(context).toLanguageTag();
    final title = DateFormat.yMMMMEEEEd(tag).format(date);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: FutureBuilder<Set<String>>(
          future: loadPrayers(date),
          builder: (context, snapshot) {
            final done = snapshot.data ?? const <String>{};
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(l10n.progressDayTitle(title), style: AppTypography.bodyStrong(colors.ink)),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.progressDaySummary(done.length),
                  style: AppTypography.caption(colors.sage),
                ),
                const SizedBox(height: 12),
                for (final prayer in trackedPrayers)
                  _PrayerLine(name: prayer, ticked: done.contains(prayer), l10n: l10n),
                const SizedBox(height: 12),
                Text(l10n.progressDayEditHint, style: AppTypography.caption(colors.sage)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.progressDayDone, style: AppTypography.body(colors.gold)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PrayerLine extends StatelessWidget {
  const _PrayerLine({required this.name, required this.ticked, required this.l10n});

  final String name;
  final bool ticked;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: '$name: ${ticked ? l10n.progressDayDone : l10n.progressDayNotDone}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              ticked ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 20,
              color: ticked ? colors.gold : colors.hairline,
            ),
            const SizedBox(width: 12),
            Text(name, style: AppTypography.body(ticked ? colors.ink : colors.sage)),
          ],
        ),
      ),
    );
  }
}
