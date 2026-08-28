// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../settings/data/notification_settings.dart';
import '../../data/iqamath_offsets.dart';
import '../../data/prayer_times_result.dart';
import 'prayer_row_leading_controls.dart';
import 'prayer_time_format.dart';
import '../../../../core/constants/app_color_tokens.dart';

/// The five daily prayers plus sunrise, in chronological order. The
/// prayer currently in effect carries a thin gold left rule — the
/// only colour accent in an otherwise quiet list. When [iqamathOffsets]
/// is supplied, each prayer (never sunrise) also shows its iqamath
/// time beside the adhan time. When [notifications] and
/// [onToggleNotification] are both supplied (Home dashboard only), a
/// small bell toggle appears inline on each prayer row instead of a
/// separate notifications section.
class PrayerTimesList extends StatefulWidget {
  const PrayerTimesList({
    super.key,
    required this.times,
    this.iqamathOffsets,
    this.notifications,
    this.onToggleNotification,
  });

  final PrayerTimesComputed times;
  final IqamathOffsetMinutes? iqamathOffsets;
  final NotificationSettings? notifications;
  final void Function(String prayer, bool enabled)? onToggleNotification;

  @override
  State<PrayerTimesList> createState() => _PrayerTimesListState();
}

class _PrayerTimesListState extends State<PrayerTimesList> {
  late final Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String? _currentPrayerName() {
    String? current;
    for (final entry in widget.times.prayerEntries) {
      if (!entry.$2.isAfter(_now)) current = entry.$1;
    }
    return current;
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentPrayerName();
    return StaggeredFadeIn(
      children: [
        _row('Fajr', widget.times.fajr, current == 'Fajr'),
        _row('Sunrise', widget.times.sunrise, false),
        for (final (name, time) in widget.times.prayerEntries.skip(1))
          _row(name, time, name == current),
      ],
    );
  }

  Widget _row(String name, DateTime time, bool isCurrent) {
    final offsets = widget.iqamathOffsets;
    final showIqamath = offsets != null && name != 'Sunrise';
    final iqamathTime = showIqamath
        ? time.add(Duration(minutes: offsets.forPrayer(name)))
        : null;
    final notifications = widget.notifications;
    final showBell = notifications != null && name != 'Sunrise';
    final bellOn = showBell && notifications.forPrayer(name);
    final label =
        '$name: ${formatClock(time)}'
        '${iqamathTime != null ? ', iqamath ${formatClock(iqamathTime)}' : ''}'
        '${isCurrent ? ', current' : ''}';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: isCurrent ? context.colors.gold : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              PrayerRowLeadingControls(
                name: name,
                showBell: showBell,
                bellOn: bellOn,
                onToggleBell: showBell
                    ? () => widget.onToggleNotification!(name, !bellOn)
                    : null,
              ),
              Semantics(
                label: label,
                child: ExcludeSemantics(
                  child: Text(name, style: TextStyle(color: context.colors.ink)),
                ),
              ),
            ],
          ),
          ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(formatClock(time), style: AppTypography.time(context.colors.ink)),
                if (iqamathTime != null) ...[
                  const SizedBox(width: 10),
                  Text(formatClock(iqamathTime), style: AppTypography.caption(context.colors.sage)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
