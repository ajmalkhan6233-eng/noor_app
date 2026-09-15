// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A SliverAppBar with a large title that shrinks into a compact bar
// on scroll, stretch enabled — the shared shape for every primary
// tab screen instead of a plain AppBar.
//
// [largeTitle] (optional) renders a custom widget — e.g. a
// [GlowHeroTitle] — in the expanded flexible space instead of relying
// on the default large-title text style. It's deliberately kept
// separate from [title]: [title] is what appears in the *pinned,
// collapsed* bar (a fixed, compact size), while [largeTitle] only
// lives in the expanded area and fades out via FlexibleSpaceBar's own
// crossfade as the sliver collapses. Reusing [title]'s widget at both
// sizes doesn't work here — a style like [GlowHeroTitle]'s 44px hero
// text is fixed at that size everywhere it's used, so pasting it
// straight into [title] would keep rendering at 44px even once
// collapsed into the ~64dp pinned bar, clipping instead of shrinking.
import 'package:flutter/material.dart';
import '../../../core/constants/app_color_tokens.dart';

class CollapsingScaffold extends StatefulWidget {
  const CollapsingScaffold({
    super.key,
    required this.title,
    required this.slivers,
    this.actions,
    this.transparentBody = false,
    this.largeTitle,
  });

  final String title;
  final List<Widget> slivers;
  final List<Widget>? actions;

  /// When true, the Scaffold body is transparent instead of the
  /// opaque paper background — used on tabs sitting above
  /// HomeDashboard's persistent CosmicBackground layer, so it shows
  /// through instead of being fully covered by each tab's own
  /// Scaffold. The collapsing app bar itself stays opaque either way.
  final bool transparentBody;

  /// Custom expanded-state title widget — see class doc. When null,
  /// behavior is unchanged from before this was added: [title] alone
  /// renders in the default large-app-bar style throughout.
  final Widget? largeTitle;

  @override
  State<CollapsingScaffold> createState() => _CollapsingScaffoldState();
}

class _CollapsingScaffoldState extends State<CollapsingScaffold> {
  // Matches SliverAppBar.large's own default expanded height (152 =
  // kToolbarHeight 56 + this) so switching to a manually-driven
  // crossfade below doesn't change the bar's size from before.
  static const double _expandedExtra = 96;

  final _scrollController = ScrollController();
  double _collapseFraction = 0;

  @override
  void initState() {
    super.initState();
    // Only [largeTitle] screens need the crossfade — the plain-title
    // path below never changes this value, so no listener needed.
    if (widget.largeTitle != null) {
      _scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    final fraction = (_scrollController.offset / _expandedExtra).clamp(0.0, 1.0);
    if (fraction != _collapseFraction) {
      setState(() => _collapseFraction = fraction);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final largeTitle = widget.largeTitle;

    // No largeTitle: unchanged from before this fix — a single title
    // rendered by SliverAppBar.large's own built-in large/small style.
    if (largeTitle == null) {
      return Scaffold(
        backgroundColor: widget.transparentBody ? Colors.transparent : context.colors.paper,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              title: Text(widget.title),
              backgroundColor: context.colors.paper,
              foregroundColor: context.colors.ink,
              surfaceTintColor: Colors.transparent,
              stretch: true,
              pinned: true,
              actions: widget.actions,
            ),
            ...widget.slivers,
          ],
        ),
      );
    }

    // With largeTitle: a custom flexibleSpace bypasses .large's
    // built-in crossfade, leaving the plain `title` always visible
    // underneath largeTitle (the reported overlap). Fixed by driving
    // both titles' opacity from real scroll position instead.
    return Scaffold(
      backgroundColor: widget.transparentBody ? Colors.transparent : context.colors.paper,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Opacity(
              opacity: _collapseFraction,
              child: Text(
                widget.title,
                style: TextStyle(color: context.colors.gold, fontWeight: FontWeight.w600),
              ),
            ),
            expandedHeight: kToolbarHeight + _expandedExtra,
            backgroundColor: context.colors.paper,
            foregroundColor: context.colors.ink,
            surfaceTintColor: Colors.transparent,
            stretch: true,
            pinned: true,
            actions: widget.actions,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              title: Opacity(opacity: 1 - _collapseFraction, child: largeTitle),
            ),
          ),
          ...widget.slivers,
        ],
      ),
    );
  }
}
