// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

/// One user-created reminder attached to a specific Gregorian date.
@immutable
class CalendarReminder {
  const CalendarReminder({
    required this.id,
    required this.date,
    required this.note,
    required this.hour,
    required this.minute,
  });

  final int id;

  /// Day precision only — the calendar this belongs to has no
  /// per-reminder notion of a range, just a single date.
  final DateTime date;

  final String note;
  final int hour;
  final int minute;

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  /// The date and time combined into one instant, for scheduling.
  DateTime get scheduledAt => DateTime(date.year, date.month, date.day, hour, minute);
}
