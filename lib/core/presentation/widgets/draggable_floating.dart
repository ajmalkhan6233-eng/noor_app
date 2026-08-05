// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Wraps [child] so it can be dragged anywhere within the parent's
// bounds; [widgetKey] persists/restores position. With [resizable], a
// pinch also scales between [minScale]/[maxScale], persisted too.

import 'package:flutter/material.dart';

import '../../database/widget_position_repository.dart';
import 'draggable_bounds.dart';
import 'draggable_gesture_area.dart';
import 'draggable_position_controller.dart';

class DraggableFloating extends StatefulWidget {
  const DraggableFloating({
    super.key,
    required this.child,
    required this.size,
    this.widgetKey,
    this.initialAlignment = Alignment.center,
    this.snapToNearestEdge = false,
    this.controller,
    this.resizable = false,
    this.minScale = 0.75,
    this.maxScale = 1.5,
  });

  final Widget child;
  final Size size;

  final String? widgetKey; // null means position is session-only
  final Alignment initialAlignment;
  final bool snapToNearestEdge;
  final DraggablePositionController? controller;

  final bool resizable;
  final double minScale;
  final double maxScale;

  @override
  State<DraggableFloating> createState() => _DraggableFloatingState();
}

class _DraggableFloatingState extends State<DraggableFloating> {
  final _repository = WidgetPositionRepository();
  Offset? _position;
  Size? _bounds;
  double _scale = 1.0;

  // Flutter reports scale as cumulative since gesture start.
  double _scaleAtGestureStart = 1.0;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleReset);
    final key = widget.widgetKey;
    if (key != null) _loadSaved(key);
  }

  Future<void> _loadSaved(String key) async {
    if (widget.resizable) {
      final saved = await _repository.loadWithScale(key);
      if (saved != null && mounted) {
        setState(() {
          _position = saved.offset;
          _scale = saved.scale;
        });
      }
    } else {
      final saved = await _repository.load(key);
      if (saved != null && mounted) setState(() => _position = saved);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleReset);
    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _position = null;
      _scale = 1.0;
    });
    final key = widget.widgetKey;
    if (key != null) _repository.clear(key);
  }

  Offset _defaultPosition(Size bounds) =>
      draggableDefaultPosition(bounds, widget.size, widget.initialAlignment);

  Offset _clamped(Offset offset, Size bounds) =>
      draggableClamp(offset, bounds, widget.size);

  void _persist(Size bounds) {
    var next = _position!;
    if (widget.snapToNearestEdge) {
      final snapLeft = next.dx + widget.size.width / 2 < bounds.width / 2;
      next = Offset(snapLeft ? 0 : bounds.width - widget.size.width, next.dy);
    }
    setState(() => _position = _clamped(next, bounds));
    final key = widget.widgetKey;
    if (key == null) return;
    widget.resizable
        ? _repository.saveWithScale(key, _position!, _scale)
        : _repository.save(key, _position!);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounds = Size(constraints.maxWidth, constraints.maxHeight);
        _bounds = bounds;
        _position ??= _clamped(_defaultPosition(bounds), bounds);
        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              left: _position!.dx,
              top: _position!.dy,
              child: Transform.scale(
                scale: _scale,
                child: widget.resizable
                    ? resizableGestureArea(
                        child: widget.child,
                        onStart: () => _scaleAtGestureStart = _scale,
                        onUpdate: (focalDelta, cumulativeScale) => setState(() {
                          _position = _clamped(_position! + focalDelta, _bounds!);
                          _scale = (_scaleAtGestureStart * cumulativeScale)
                              .clamp(widget.minScale, widget.maxScale);
                        }),
                        onEnd: () => _persist(_bounds!),
                      )
                    : dragOnlyGestureArea(
                        child: widget.child,
                        onDelta: (delta) => setState(() {
                          _position = _clamped(_position! + delta, _bounds!);
                        }),
                        onEnd: () => _persist(_bounds!),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
