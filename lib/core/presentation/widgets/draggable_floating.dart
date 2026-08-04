// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Wraps [child] so the user can pick it up and drag it anywhere
// within its parent's bounds with a finger — not fixed in place. When
// [widgetKey] is given, the dropped position is persisted (encrypted
// local DB) and restored next launch; when [snapToNearestEdge] is
// true, releasing animates the widget to the closer horizontal edge.

import 'package:flutter/material.dart';

import '../../database/widget_position_repository.dart';
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
  });

  final Widget child;
  final Size size;

  /// Persistence key. `null` means position is session-only.
  final String? widgetKey;
  final Alignment initialAlignment;
  final bool snapToNearestEdge;
  final DraggablePositionController? controller;

  @override
  State<DraggableFloating> createState() => _DraggableFloatingState();
}

class _DraggableFloatingState extends State<DraggableFloating> {
  final _repository = WidgetPositionRepository();
  Offset? _position;
  Size? _bounds;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleReset);
    final key = widget.widgetKey;
    if (key != null) {
      _repository.load(key).then((saved) {
        if (saved != null && mounted) setState(() => _position = saved);
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleReset);
    super.dispose();
  }

  void _handleReset() {
    setState(() => _position = null);
    final key = widget.widgetKey;
    if (key != null) _repository.clear(key);
  }

  Offset _defaultPosition(Size bounds) => Offset(
    (bounds.width - widget.size.width) / 2 +
        widget.initialAlignment.x * (bounds.width - widget.size.width) / 2,
    (bounds.height - widget.size.height) / 2 +
        widget.initialAlignment.y * (bounds.height - widget.size.height) / 2,
  );

  Offset _clamped(Offset offset, Size bounds) => Offset(
    offset.dx.clamp(0, (bounds.width - widget.size.width).clamp(0, double.infinity)),
    offset.dy.clamp(0, (bounds.height - widget.size.height).clamp(0, double.infinity)),
  );

  void _onDragEnd(Size bounds) {
    var next = _position!;
    if (widget.snapToNearestEdge) {
      final snapLeft = next.dx + widget.size.width / 2 < bounds.width / 2;
      next = Offset(
        snapLeft ? 0 : bounds.width - widget.size.width,
        next.dy,
      );
    }
    setState(() => _position = _clamped(next, bounds));
    final key = widget.widgetKey;
    if (key != null) _repository.save(key, _position!);
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
              child: GestureDetector(
                onPanUpdate: (details) => setState(() {
                  _position = _clamped(_position! + details.delta, bounds);
                }),
                onPanEnd: (_) => _onDragEnd(_bounds!),
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}
