// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The persistent "living universe" background layer described in
// CLAUDE.md's Visual Direction and docs/05_UI_UX_AND_3D_DESIGN_SYSTEM.md
// section 7 — slow-moving, low-opacity gold/cyan particles drifting
// against the obsidian background, present behind every screen. A
// codebase-wide search before building this (see the session that
// added it) found no prior implementation anywhere — no
// BackdropFilter usage, no background/particle-field file — despite
// the docs describing it as already shipped, so this is a fresh
// build, not a rewire.
//
// One repeating AnimationController drives a single CustomPainter (see
// cosmic_background_painter.dart) — deliberately not per-particle
// widgets or controllers, and no per-frame allocation (particle list
// generated once in initState). Frozen under reduced motion (particles
// still render, just don't move) rather than removed entirely, since
// they're decorative background, not information.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../motion/motion.dart';
import 'cosmic_background_painter.dart';

class CosmicBackground extends StatefulWidget {
  const CosmicBackground({super.key, this.particleCount = 44});

  final int particleCount;

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<DriftingParticle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = DriftingParticle.generate(widget.particleCount);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 90),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = Motion.reduced(context);
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.paper),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: CosmicPainter(
            particles: _particles,
            // Frozen at 0 under reduced motion — particles still
            // paint (they're background, not a motion effect), they
            // just don't drift.
            t: reduced ? 0 : _controller.value,
          ),
        ),
      ),
    );
  }
}
