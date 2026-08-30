// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reminders for one specific calendar date — loaded fresh each time
// the day-detail sheet opens, since this is a short-lived view, not
// something that needs to stay subscribed across the whole app.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../prayer_times/data/notification_service.dart';
import '../../data/calendar_reminder_repository.dart';
import 'calendar_reminder_state.dart';

class CalendarReminderCubit extends Cubit<CalendarReminderState> {
  CalendarReminderCubit({
    required this.date,
    CalendarReminderRepository? repository,
    NotificationService? notificationService,
  }) : _repository = repository ?? CalendarReminderRepository(),
       _notificationService = notificationService ?? NotificationService(),
       super(const CalendarReminderState()) {
    _load();
  }

  final DateTime date;
  final CalendarReminderRepository _repository;
  final NotificationService _notificationService;

  Future<void> _load() async {
    final reminders = await _repository.remindersOn(date);
    emit(state.copyWith(reminders: reminders, loading: false));
  }

  Future<void> add({required String note, required int hour, required int minute}) async {
    final id = await _repository.add(date: date, note: note, hour: hour, minute: minute);
    await _notificationService.scheduleCalendarReminder(
      reminderId: id,
      note: note,
      dateTime: DateTime(date.year, date.month, date.day, hour, minute),
    );
    await _load();
  }

  Future<void> remove(int reminderId) async {
    await _repository.delete(reminderId);
    await _notificationService.cancelCalendarReminder(reminderId);
    await _load();
  }
}
