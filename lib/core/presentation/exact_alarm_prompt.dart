// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One-time setup prompt for Android's "Alarms & reminders" (exact alarm)
// grant, shown right after the location step of first-run onboarding.
// Without the grant every adhan is scheduled as an inexact alarm and can
// fire minutes to an hour late (verified live 2026-09-28). Shows nothing
// when the grant is already held, or when the platform can't tell
// (non-Android / tests). Tapping "Open settings" opens the system page.
// Skipping is fine — the same request stays in Settings.

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/app_color_tokens.dart';
import '../../l10n/generated/app_localizations.dart';

Future<void> maybePromptExactAlarm(BuildContext context) async {
  final android = FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  bool? canExact;
  try {
    canExact = await android?.canScheduleExactNotifications();
  } catch (_) {}
  if (canExact != false || !context.mounted) return;

  final open = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ctx.colors.card,
      title: Text(AppLocalizations.of(ctx)!.exactAlarmTitle, style: TextStyle(color: ctx.colors.ink)),
      content: Text(
        AppLocalizations.of(ctx)!.exactAlarmBody,
        style: TextStyle(color: ctx.colors.sage, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(AppLocalizations.of(ctx)!.commonNotNow, style: TextStyle(color: ctx.colors.sage)),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(AppLocalizations.of(ctx)!.exactAlarmOpenSettings, style: TextStyle(color: ctx.colors.gold)),
        ),
      ],
    ),
  );
  if (open == true) await android?.requestExactAlarmsPermission();
}
