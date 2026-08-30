// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/calendar_reminder.dart';

class CalendarReminderTile extends StatelessWidget {
  const CalendarReminderTile({super.key, required this.reminder, required this.onDelete});

  final CalendarReminder reminder;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final time = reminder.time;
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$hour:$minute $period',
            style: TextStyle(color: context.colors.gold, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(reminder.note, style: TextStyle(color: context.colors.ink)),
          ),
          SemanticButton(
            label: reminder.note,
            hint: l10n.calendarReminderDeleteHint,
            onTap: onDelete,
            child: Icon(Icons.close, size: 18, color: context.colors.sage),
          ),
        ],
      ),
    );
  }
}
