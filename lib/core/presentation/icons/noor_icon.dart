// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Drop-in replacement for `Icon(iconData, color:, size:)` backed by
// this app's own original line-art set instead of Material's — same
// call shape so swapping it in at each call site was a one-line change.

import 'package:flutter/material.dart';

import 'more_icon_painters_a.dart';
import 'more_icon_painters_b.dart';
import 'nav_icon_painters.dart';
import 'nav_icon_painters_b.dart';
import 'nav_icon_painters_more.dart';
import 'noor_icon_type.dart';

class NoorIcon extends StatelessWidget {
  const NoorIcon(this.type, {super.key, required this.color, this.size = 24, this.active = true});

  final NoorIconType type;
  final Color color;
  final double size;

  /// Only meaningful for the 5 bottom-nav glyphs, which paint their own
  /// glossy badge and pick their own gold/cyan tint from this instead
  /// of an external [color] — every other icon type ignores it.
  final bool active;

  CustomPainter _painter() => switch (type) {
    NoorIconType.home => HomeIconPainter(color, active: active),
    NoorIconType.prayerTimes => PrayerTimesIconPainter(color, active: active),
    NoorIconType.quran => QuranIconPainter(color, active: active),
    NoorIconType.duas => DuasIconPainter(color, active: active),
    NoorIconType.more => MoreIconPainter(color, active: active),
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
