// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Watches which of a set of keyed items is topmost in the viewport as
// the user scrolls, and reports it (debounced, so it settles once
// scrolling stops rather than firing on every frame). Used to track
// "last read ayah" without needing a virtualized/indexed list.

import 'dart:async';

import 'package:flutter/material.dart';

class ReadingPositionTracker extends StatefulWidget {
  const ReadingPositionTracker({
    super.key,
    required this.itemKeys,
    required this.onPositionChanged,
    required this.child,
  });

  /// Maps a caller-defined item id to the [GlobalKey] on that item's
  /// widget in the scrollable.
  final Map<int, GlobalKey> itemKeys;
  final ValueChanged<int> onPositionChanged;
  final Widget child;

  @override
  State<ReadingPositionTracker> createState() =>
      _ReadingPositionTrackerState();
}

class _ReadingPositionTrackerState extends State<ReadingPositionTracker> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _schedule() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _reportPosition);
  }

  void _reportPosition() {
    if (!mounted) return;
    final viewport = context.findRenderObject();
    if (viewport is! RenderBox) return;

    int? topmostId;
    var topmostY = double.infinity;
    for (final entry in widget.itemKeys.entries) {
      final box = entry.value.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.attached) continue;
      final position = box.localToGlobal(Offset.zero, ancestor: viewport);
      final visible = position.dy > -box.size.height;
      if (visible && position.dy < topmostY) {
        topmostY = position.dy;
        topmostId = entry.key;
      }
    }
    if (topmostId != null) widget.onPositionChanged(topmostId);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          _reportPosition();
        } else {
          _schedule();
        }
        return false;
      },
      child: widget.child,
    );
  }
}
