// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Drop-in replacement for `Icon(iconData, color:, size:)` backed by
// this app's own original line-art set instead of Material's — same
// call shape so swapping it in at each call site was a one-line change.

import 'package:flutter/material.dart';

import 'more_icon_painters_a.dart';
import 'more_icon_painters_b.dart';
import 'nav_icon_painters.dart';
import 'noor_icon_type.dart';

class NoorIcon extends StatelessWidget {
  const NoorIcon(this.type, {super.key, required this.color, this.size = 24});

  final NoorIconType type;
  final Color color;
  final double size;

  CustomPainter _painter() => switch (type) {
    NoorIconType.home => HomeIconPainter(color),
    NoorIconType.prayerTimes => PrayerTimesIconPainter(color),
    NoorIconType.quran => QuranIconPainter(color),
    NoorIconType.duas => DuasIconPainter(color),
    NoorIconType.more => MoreIconPainter(color),
    NoorIconType.qibla => QiblaIconPainter(color),
    NoorIconType.tasbih => TasbihIconPainter(color),
    NoorIconType.calendar => CalendarIconPainter(color),
    NoorIconType.zakat => ZakatIconPainter(color),
    NoorIconType.settings => SettingsIconPainter(color),
    NoorIconType.about => AboutIconPainter(color),
    NoorIconType.feedback => FeedbackIconPainter(color),
    NoorIconType.support => SupportIconPainter(color),
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _painter()),
    );
  }
}
