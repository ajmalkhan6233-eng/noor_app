// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A tactile, physically-manipulable counter: pull it off-centre and
// it tilts in 3D toward your finger; let go and a spring snaps it
// back with a wiggle. A milestone (33/66/100) adds a stronger shake
// on top of that same snap. Haptics and the count itself stay owned
// by TasbihCubit — this widget only ever forwards taps and renders.

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
  static const _maxPull = 36.0;

  late final AnimationController _springController;
  late final AnimationController _shakeController;
  late final AnimationController _tapController;
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
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _springController.stop();
    setState(() {
      final next = _dragOffset + details.delta;
      final distance = next.distance;
      _dragOffset = distance > _maxPull ? next * (_maxPull / distance) : next;
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
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: SemanticButton(
        label: semanticCountLabel(l10n.tasbihCounterSemanticLabel, widget.count),
        hint: l10n.tasbihIncrementHint,
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_shakeController, _tapController]),
          builder: (context, child) {
            final shake = math.sin(_shakeController.value * math.pi * 6) *
                (1 - _shakeController.value) *
                10;
            final tapScale = 1 - (math.sin(_tapController.value * math.pi) * 0.08);
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..translateByDouble(_dragOffset.dx + shake, _dragOffset.dy, 0, 1)
                ..rotateX(_dragOffset.dy * 0.02)
                ..rotateY(-_dragOffset.dx * 0.02)
                ..scaleByDouble(tapScale, tapScale, tapScale, 1),
              child: child,
            );
          },
          child: OrbFace(count: widget.count, pulsing: widget.pulsing),
        ),
      ),
    );
  }
}
