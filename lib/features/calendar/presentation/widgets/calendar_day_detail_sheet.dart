// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Bottom sheet opened by tapping a day in the month grid — date,
// Hijri equivalent, any occasions/holidays, and (2026-08-30, master
// directive items 10/11) that day's reminders: a note + a time, with
// the actual local notification wired through the existing
// NotificationService.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../core/utils/islamic_occasion.dart';
import '../../../../core/utils/sri_lanka_holiday.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/calendar_reminder_cubit/calendar_reminder_cubit.dart';
import '../../logic/calendar_reminder_cubit/calendar_reminder_state.dart';
import 'add_reminder_dialog.dart';
import 'calendar_reminder_tile.dart';

Future<void> showCalendarDayDetail(
  BuildContext context, {
  required DateTime date,
  required HijriDate hijri,
  required String monthName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.colors.card,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => BlocProvider(
      create: (_) => CalendarReminderCubit(date: date),
      child: _CalendarDayDetailContent(date: date, hijri: hijri, monthName: monthName),
    ),
  );
}

class _CalendarDayDetailContent extends StatelessWidget {
  const _CalendarDayDetailContent({required this.date, required this.hijri, required this.monthName});

  final DateTime date;
  final HijriDate hijri;
  final String monthName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final occasions = occasionsOn(hijri);
    final holidays = sriLankaHolidaysOn(date);
    final cubit = context.read<CalendarReminderCubit>();

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$monthName ${date.day}, ${date.year}',
            style: TextStyle(color: context.colors.ink, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(hijri.formatted, style: AppTypography.caption(context.colors.sage)),
          if (occasions.isNotEmpty || holidays.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: context.colors.hairline, height: 1),
            const SizedBox(height: 16),
            for (final occasion in occasions) _detailRow(context, occasion.label, context.colors.gold),
            for (final holiday in holidays) _detailRow(context, holiday.name, context.colors.accentSecondary),
          ],
          const SizedBox(height: 16),
          Divider(color: context.colors.hairline, height: 1),
          const SizedBox(height: 12),
          Text(l10n.calendarRemindersTitle, style: AppTypography.sectionHeader(context.colors.sage)),
          const SizedBox(height: 8),
          BlocBuilder<CalendarReminderCubit, CalendarReminderState>(
            builder: (context, state) {
              if (state.loading) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.gold),
                    ),
                  ),
                );
              }
              if (state.reminders.isEmpty) {
                return Text(
                  l10n.calendarReminderEmptyMessage,
                  style: TextStyle(color: context.colors.sage, fontStyle: FontStyle.italic),
                );
              }
              return Column(
                children: [
                  for (final reminder in state.reminders)
                    CalendarReminderTile(reminder: reminder, onDelete: () => cubit.remove(reminder.id)),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => showAddReminderDialog(context, cubit),
            icon: Icon(Icons.add, size: 18, color: context.colors.gold),
            label: Text(l10n.calendarReminderAddButton, style: TextStyle(color: context.colors.gold)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          ),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: context.colors.ink)),
        ],
      ),
    );
  }
}
