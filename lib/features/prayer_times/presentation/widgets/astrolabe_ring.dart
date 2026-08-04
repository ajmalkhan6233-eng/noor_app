// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The one bold element in the app: an arc across the top tracing the
// day from Fajr to Isha, the five prayers marked along it, and a gold
// marker at today's position between them. Everything else stays
// quiet so this can carry the screen. On first load the arc sweeps in
// clockwise rather than snapping into place.

import 'package:flutter/material.dart';

import '../../../../core/presentation/motion/motion.dart';
import '../../data/prayer_times_result.dart';
import 'astrolabe_painter.dart';

class AstrolabeRing extends StatefulWidget {
  const AstrolabeRing({super.key, required this.times, required this.now});

  final PrayerTimesComputed times;
  final DateTime now;

  @override
  State<AstrolabeRing> createState() => _AstrolabeRingState();
}

class _AstrolabeRingState extends State<AstrolabeRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (Motion.reduced(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Day progress arc from Fajr to Isha, current time marked',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: const Size(double.infinity, 132),
          painter: AstrolabePainter(
            times: widget.times,
            now: widget.now,
            sweep: CurvedAnimation(
              parent: _controller,
              curve: Motion.curve,
            ).value,
          ),
        ),
      ),
    );
  }
}
