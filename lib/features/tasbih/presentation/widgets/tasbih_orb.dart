// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A tactile, physically-manipulable counter: pull it — freely, almost
// anywhere across the screen — and it tilts in 3D toward your finger;
// let go and a spring snaps it back to centre with a wiggle. A
// milestone (33/66/100) adds a stronger shake on top of that same
// snap. A slow, subtle breathing/sway idle animation keeps it from
// looking static when nobody's touching it. Haptics and the count
// itself stay owned by TasbihCubit — this widget only ever forwards
// taps and renders.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../../../../core/effects/particle_burst.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'orb_face.dart';

class TasbihOrb extends StatefulWidget {
  const TasbihOrb({
    super.key,
    required this.count,
    required this.onTap,
    this.pulsing = false,
  });

  final int count;
  final VoidCallback onTap;
  final bool pulsing;

  @override
  State<TasbihOrb> createState() => _TasbihOrbState();
}

class _TasbihOrbState extends State<TasbihOrb> with TickerProviderStateMixin {
  /// Fraction of the shorter screen dimension the orb may travel from
  /// centre while held — generous enough to feel like it moves freely
  /// across the screen, while still guaranteeing a spring-back with
  /// room to move in either direction.
  static const _maxPullFraction = 0.42;

  late final AnimationController _springController;
  late final AnimationController _shakeController;
  late final AnimationController _tapController;
  late final AnimationController _idleController;
  Offset _dragOffset = Offset.zero;
  Offset _releaseOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(() {
        setState(() {
          _dragOffset = Offset.lerp(_releaseOffset, Offset.zero, _springController.value)!;
        });
      });
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 260),
    );
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
  }

  double _maxPull() {
    final size = MediaQuery.sizeOf(context);
    return math.min(size.width, size.height) * _maxPullFraction;
  }

  @override
  void didUpdateWidget(TasbihOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing && !oldWidget.pulsing) {
      _shakeController.forward(from: 0);
      ParticleBurst.play(context);
    }
  }

  @override
  void dispose() {
    _springController.dispose();
    _shakeController.dispose();
    _tapController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _springController.stop();
    final maxPull = _maxPull();
    setState(() {
      final next = _dragOffset + details.delta;
      final distance = next.distance;
      _dragOffset = distance > maxPull ? next * (maxPull / distance) : next;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _releaseOffset = _dragOffset;
    _springController.value = 0;
    _springController.animateWith(
      SpringSimulation(const SpringDescription(mass: 1, stiffness: 180, damping: 10), 0, 1, 0),
    );
  }

  void _handleTap() {
    _tapController.forward().then((_) => _tapController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: SemanticButton(
        label: semanticCountLabel(l10n.tasbihCounterSemanticLabel, widget.count),
        hint: l10n.tasbihIncrementHint,
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_shakeController, _tapController, _idleController]),
          builder: (context, child) {
            final shake = math.sin(_shakeController.value * math.pi * 6) *
                (1 - _shakeController.value) *
                10;
            final tapScale = 1 - (math.sin(_tapController.value * math.pi) * 0.08);
            // Subtle idle breathing/sway so the orb is never fully
            // static — negligible next to a drag or tap in progress,
            // and skipped entirely when the system asks for reduced
            // motion.
            final idleT = _idleController.value * 2 * math.pi;
            final idleScale = reduceMotion ? 1.0 : 1 + math.sin(idleT) * 0.015;
            final idleTiltY = reduceMotion ? 0.0 : math.sin(idleT * 0.5) * 0.02;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..translateByDouble(
                  _dragOffset.dx + shake,
                  _dragOffset.dy,
                  0.0,
                  1.0,
                )
                ..rotateX(_dragOffset.dy * 0.02)
                ..rotateY(-_dragOffset.dx * 0.02 + idleTiltY)
                ..scaleByDouble(
                  tapScale * idleScale,
                  tapScale * idleScale,
                  tapScale * idleScale,
                  1.0,
                ),
              child: child,
            );
          },
          child: OrbFace(
            count: widget.count,
            pulsing: widget.pulsing,
            pullFraction: (_dragOffset.distance / _maxPull()).clamp(0.0, 1.0),
          ),
        ),
      ),
    );
  }
}
