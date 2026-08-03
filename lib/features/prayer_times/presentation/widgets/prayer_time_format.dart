// Bismillahir Rahmanir Raheem — watermark: ALLAH

/// Formats [time] as a 24-hour `HH:mm` clock string, with no `intl`
/// dependency — this app adds no networking or heavy formatting
/// packages for a two-field time string.
String formatClock(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
