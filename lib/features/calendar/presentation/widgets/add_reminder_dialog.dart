// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/calendar_reminder_cubit/calendar_reminder_cubit.dart';

Future<void> showAddReminderDialog(BuildContext context, CalendarReminderCubit cubit) async {
  final l10n = AppLocalizations.of(context)!;
  final noteController = TextEditingController();
  var time = TimeOfDay.now();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => AlertDialog(
        backgroundColor: dialogContext.colors.card,
        title: Text(l10n.calendarReminderAddButton, style: TextStyle(color: dialogContext.colors.ink)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: noteController,
              autofocus: true,
              style: TextStyle(color: dialogContext.colors.ink),
              decoration: InputDecoration(
                hintText: l10n.calendarReminderNoteHint,
                hintStyle: TextStyle(color: dialogContext.colors.sage),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final picked = await showTimePicker(context: dialogContext, initialTime: time);
                if (picked != null) setDialogState(() => time = picked);
              },
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 18, color: dialogContext.colors.gold),
                  const SizedBox(width: 8),
                  Text(time.format(dialogContext), style: TextStyle(color: dialogContext.colors.gold)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelLabel, style: TextStyle(color: dialogContext.colors.sage)),
          ),
          TextButton(
            onPressed: () {
              final note = noteController.text.trim();
              if (note.isEmpty) return;
              cubit.add(note: note, hour: time.hour, minute: time.minute);
              Navigator.of(dialogContext).pop();
            },
            child: Text(l10n.saveLabel, style: TextStyle(color: dialogContext.colors.gold)),
          ),
        ],
      ),
    ),
  );
  noteController.dispose();
}
