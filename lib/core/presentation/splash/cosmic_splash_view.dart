// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Orchestrates the cosmic splash: a single Ticker drives a shared
// elapsed-time clock, consumed independently by the background/glow
// painter, the starfield painter, and the greeting overlay — each
// isolated behind its own RepaintBoundary.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../constants/splash_config.dart';
import 'background_glow_painter.dart';
import 'greeting_overlay.dart';
import 'star.dart';
import 'star_field_painter.dart';

/// The animated starfield + breathing glow + word-by-word greeting.
class CosmicSplashView extends StatefulWidget {
  const CosmicSplashView({super.key});

  @override
  State<CosmicSplashView> createState() => _CosmicSplashViewState();
}

class _CosmicSplashViewState extends State<CosmicSplashView>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _elapsedSeconds = ValueNotifier(0);
  late final Ticker _ticker;
  late final List<Star> _stars;

  @override
  void initState() {
    super.initState();
    _stars = Star.generateField(
      SplashConfig.starCount,
      SplashConfig.starFieldSeed,
    );
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    _elapsedSeconds.value =
        elapsed.inMicroseconds / Duration.microsecondsPerSecond;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _elapsedSeconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(child: _backgroundLayer()),
        RepaintBoundary(child: _starLayer()),
        RepaintBoundary(child: _greetingLayer()),
      ],
    );
  }

  Widget _backgroundLayer() => AnimatedBuilder(
    animation: _elapsedSeconds,
    builder: (context, _) =>
        CustomPaint(painter: BackgroundGlowPainter(
          elapsedSeconds: _elapsedSeconds.value,
        )),
  );

  Widget _starLayer() => AnimatedBuilder(
    animation: _elapsedSeconds,
    builder: (context, _) => CustomPaint(
      painter: StarFieldPainter(
        stars: _stars,
        elapsedSeconds: _elapsedSeconds.value,
      ),
    ),
  );

  Widget _greetingLayer() => AnimatedBuilder(
    animation: _elapsedSeconds,
    builder: (context, _) =>
        GreetingOverlay(elapsedSeconds: _elapsedSeconds.value),
  );
}
