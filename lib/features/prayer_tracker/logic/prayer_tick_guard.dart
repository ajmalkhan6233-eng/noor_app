DateTime _calendarDay(DateTime value) => DateTime(value.year, value.month, value.day);

bool canTickPrayer({
  required DateTime viewedDate,
  required DateTime today,
  required DateTime now,
  required DateTime? prayerStart,
}) {
  final viewedDay = _calendarDay(viewedDate);
  final todayDay = _calendarDay(today);

  if (viewedDay.isBefore(todayDay)) return true;
  if (viewedDay.isAfter(todayDay)) return false;
  return prayerStart != null && !now.isBefore(prayerStart);
}