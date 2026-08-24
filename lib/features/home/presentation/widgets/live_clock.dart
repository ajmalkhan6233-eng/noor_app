// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The device's actual current time, ticking — requested explicitly on
// Home (2026-08-24 live-device review): distinct from the next-prayer
// countdown below it, which counts down rather than showing "now".

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class LiveClock extends StatefulWidget {
  const LiveClock({super.key});

  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late final Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _now = DateTime.now()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = DateFormat.jms(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(_now);
    return Center(
      child: Semantics(
        liveRegion: true,
        label: 'Current time: $text',
        child: ExcludeSemantics(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: AppTypography.displayFamily,
              fontFeatures: [FontFeature.tabularFigures()],
              fontSize: 30,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
