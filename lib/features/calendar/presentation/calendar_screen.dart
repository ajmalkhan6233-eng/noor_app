// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A Gregorian month grid with each day's Hijri equivalent underneath
// — computed locally (see core/utils/hijri_date.dart), never fetched.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/hijri_date.dart';
import '../../settings/data/settings_repository.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  int _hijriOffsetDays = 0;

  @override
  void initState() {
    super.initState();
    SettingsRepository().load().then((settings) {
      if (mounted) setState(() => _hijriOffsetDays = settings.hijriOffsetDays);
    });
  }

  void _changeMonth(int delta) {
    setState(() => _month = DateTime(_month.year, _month.month + delta));
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final firstWeekday = DateTime(_month.year, _month.month, 1).weekday % 7;
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text('${_monthName(_month.month)} ${_month.year}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeMonth(-1),
            tooltip: 'Previous month',
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeMonth(1),
            tooltip: 'Next month',
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 0.75,
        ),
        itemCount: firstWeekday + daysInMonth,
        itemBuilder: (context, index) {
          if (index < firstWeekday) return const SizedBox.shrink();
          final day = index - firstWeekday + 1;
          final date = DateTime(_month.year, _month.month, day);
          final hijri = HijriDate.fromGregorian(
            date,
            offsetDays: _hijriOffsetDays,
          );
          final isToday = date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
          return Semantics(
            label: '${_monthName(_month.month)} $day, ${hijri.formatted}',
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isToday ? AppColors.emerald : AppColors.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.hairline),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      color: isToday ? AppColors.paper : AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${hijri.day}',
                    style: AppTypography.caption.copyWith(
                      color: isToday ? AppColors.paper : AppColors.sage,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _monthName(int month) => const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ][month - 1];
}
