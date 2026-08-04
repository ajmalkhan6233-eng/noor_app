// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// CustomPainter for the astrolabe ring — split out of astrolabe_ring
// so neither file grows past the 150-line limit.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/prayer_times_result.dart';

class AstrolabePainter extends CustomPainter {
  AstrolabePainter({required this.times, required this.now, required this.sweep});

  final PrayerTimesComputed times;
  final DateTime now;

  /// 0 at first frame, 1 once the entrance sweep has completed.
  final double sweep;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = math.min(size.width / 2, size.height) - 20;
    final track = Paint()
      ..color = AppColors.hairline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      -math.pi * sweep,
      false,
      track,
    );

    final totalSeconds = times.isha.difference(times.fajr).inSeconds;
    if (totalSeconds <= 0) return;

    for (final entry in times.prayerEntries) {
      final f = _fractionOf(entry.$2, totalSeconds);
      if (f <= sweep) _drawMark(canvas, center, radius, f);
    }
    final nowFraction = _fractionOf(now, totalSeconds);
    if (nowFraction <= sweep) {
      _drawNowMarker(canvas, center, radius, nowFraction);
    }
  }

  double _fractionOf(DateTime time, int totalSeconds) {
    final elapsed = time.difference(times.fajr).inSeconds;
    return (elapsed / totalSeconds).clamp(0.0, 1.0);
  }

  Offset _pointAt(Offset center, double radius, double fraction) {
    final angle = math.pi - fraction * math.pi;
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy - radius * math.sin(angle),
    );
  }

  void _drawMark(Canvas canvas, Offset center, double radius, double f) {
    final paint = Paint()..color = AppColors.goldSoft;
    canvas.drawCircle(_pointAt(center, radius, f), 3, paint);
  }

  void _drawNowMarker(Canvas canvas, Offset center, double radius, double f) {
    final point = _pointAt(center, radius, f);
    canvas.drawCircle(point, 6, Paint()..color = AppColors.gold);
    canvas.drawCircle(
      point,
      6,
      Paint()
        ..color = AppColors.gold.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
  }

  @override
  bool shouldRepaint(covariant AstrolabePainter oldDelegate) =>
      oldDelegate.now != now ||
      oldDelegate.times != times ||
      oldDelegate.sweep != sweep;
}
