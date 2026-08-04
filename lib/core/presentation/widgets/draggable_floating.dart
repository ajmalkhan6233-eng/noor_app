// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Wraps [child] so the user can pick it up and drag it anywhere
// within its parent's bounds with a finger — not fixed in place.
// Position is session-only (resets to [initialAlignment] next time
// the screen opens), matching how a floating mini-player or a movable
// on-screen control behaves.

import 'package:flutter/material.dart';

class DraggableFloating extends StatefulWidget {
  const DraggableFloating({
    super.key,
    required this.child,
    required this.size,
    this.initialAlignment = Alignment.center,
  });

  final Widget child;
  final Size size;
  final Alignment initialAlignment;

  @override
  State<DraggableFloating> createState() => _DraggableFloatingState();
}

class _DraggableFloatingState extends State<DraggableFloating> {
  Offset? _position;

  Offset _clamped(Offset offset, Size bounds) {
    return Offset(
      offset.dx.clamp(0, (bounds.width - widget.size.width).clamp(0, double.infinity)),
      offset.dy.clamp(0, (bounds.height - widget.size.height).clamp(0, double.infinity)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounds = Size(constraints.maxWidth, constraints.maxHeight);
        _position ??= _clamped(
          Offset(
            (bounds.width - widget.size.width) / 2 +
                widget.initialAlignment.x * (bounds.width - widget.size.width) / 2,
            (bounds.height - widget.size.height) / 2 +
                widget.initialAlignment.y * (bounds.height - widget.size.height) / 2,
          ),
          bounds,
        );
        return Stack(
          children: [
            Positioned(
              left: _position!.dx,
              top: _position!.dy,
              child: GestureDetector(
                onPanUpdate: (details) => setState(() {
                  _position = _clamped(_position! + details.delta, bounds);
                }),
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}
