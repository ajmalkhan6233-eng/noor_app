// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The one bold element in the app: an arc across the top tracing the
// day from Fajr to Isha, the five prayers marked along it, and a gold
// marker at today's position between them. Everything else stays
// quiet so this can carry the screen.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/prayer_times_result.dart';

class AstrolabeRing extends StatelessWidget {
  const AstrolabeRing({super.key, required this.times, required this.now});

  final PrayerTimesComputed times;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Day progress arc from Fajr to Isha, current time marked',
      child: CustomPaint(
        size: const Size(double.infinity, 132),
        painter: _AstrolabePainter(times: times, now: now),
      ),
    );
  }
}

class _AstrolabePainter extends CustomPainter {
  _AstrolabePainter({required this.times, required this.now});

  final PrayerTimesComputed times;
  final DateTime now;

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
      -math.pi,
      false,
      track,
    );

    final totalSeconds = times.isha.difference(times.fajr).inSeconds;
    if (totalSeconds <= 0) return;

    for (final entry in times.prayerEntries) {
      _drawMark(canvas, center, radius, _fractionOf(entry.$2, totalSeconds));
    }
    _drawNowMarker(canvas, center, radius, _fractionOf(now, totalSeconds));
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
  bool shouldRepaint(covariant _AstrolabePainter oldDelegate) =>
      oldDelegate.now != now || oldDelegate.times != times;
}
