// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Screen and list entrance: each child fades in and rises 16px,
// staggered 60ms apart, all driven off one AnimationController via
// Interval curves — not independent timers per child.

import 'package:flutter/material.dart';

import 'motion.dart';

class StaggeredFadeIn extends StatefulWidget {
  const StaggeredFadeIn({
    super.key,
    required this.children,
    this.itemDuration = Motion.duration,
    this.stagger = Motion.stagger,
    this.maxStaggerItems = 12,
  });

  final List<Widget> children;
  final Duration itemDuration;
  final Duration stagger;

  /// Caps how many leading items get a distinct delay — long lists
  /// (114 surahs) shouldn't make the last row wait seconds to appear.
  final int maxStaggerItems;

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;

  int get _staggerCount =>
      widget.children.length.clamp(0, widget.maxStaggerItems);

  @override
  void initState() {
    super.initState();
    final totalMs =
        widget.itemDuration.inMilliseconds +
        widget.stagger.inMilliseconds * (_staggerCount - 1).clamp(0, 1 << 30);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs == 0 ? 1 : totalMs),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (var i = 0; i < widget.children.length; i++) _item(i)],
    );
  }

  Widget _item(int index) {
    final totalMs = _controller.duration!.inMilliseconds;
    final delayIndex = index.clamp(0, widget.maxStaggerItems - 1);
    final startMs = widget.stagger.inMilliseconds * delayIndex;
    final endMs = (startMs + widget.itemDuration.inMilliseconds).clamp(
      0,
      totalMs,
    );
    final begin = (startMs / totalMs).clamp(0.0, 1.0);
    final end = (endMs / totalMs).clamp(begin, 1.0);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: Motion.curve),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, (1 - animation.value) * Motion.riseDistance),
          child: child,
        ),
      ),
      child: widget.children[index],
    );
  }
}
