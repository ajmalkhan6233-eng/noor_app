// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../data/calendar_reminder.dart';

class CalendarReminderState extends Equatable {
  const CalendarReminderState({this.reminders = const [], this.loading = true});

  final List<CalendarReminder> reminders;
  final bool loading;

  CalendarReminderState copyWith({List<CalendarReminder>? reminders, bool? loading}) {
    return CalendarReminderState(
      reminders: reminders ?? this.reminders,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [reminders, loading];
}
