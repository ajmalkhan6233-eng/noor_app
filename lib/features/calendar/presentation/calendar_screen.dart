// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A Gregorian month grid with each day's Hijri equivalent side by
// side — computed locally (see core/utils/hijri_date.dart), never
// fetched — marking Ramadan, the two Eids, Ashura, and the White Days.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/hijri_date.dart';
import '../../../core/utils/islamic_occasion.dart';
import '../../../core/utils/sri_lanka_holiday.dart';
import '../../settings/data/settings_repository.dart';
import 'widgets/calendar_day_cell.dart';
import 'widgets/calendar_legend.dart';

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
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
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
                return CalendarDayCell(
                  gregorianDate: date,
                  hijri: hijri,
                  isToday: isToday,
                  onTap: () => _showDayDetail(context, date, hijri),
                );
              },
            ),
          ),
          const CalendarLegend(),
        ],
      ),
    );
  }

  void _showDayDetail(BuildContext context, DateTime date, HijriDate hijri) {
    final occasions = occasionsOn(hijri);
    final holidays = sriLankaHolidaysOn(date);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_monthName(date.month)} ${date.day}, ${date.year}',
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(hijri.formatted, style: AppTypography.caption),
            if (occasions.isNotEmpty || holidays.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(color: AppColors.hairline, height: 1),
              const SizedBox(height: 16),
              for (final occasion in occasions) _detailRow(occasion.label, AppColors.gold),
              for (final holiday in holidays)
                _detailRow(holiday.name, AppColors.accentSecondary),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, Color dotColor) {
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
          Text(label, style: const TextStyle(color: AppColors.ink)),
        ],
      ),
    );
  }

  String _monthName(int month) => const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ][month - 1];
}
