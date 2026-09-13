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

class CollapsingScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final largeTitle = this.largeTitle;
    return Scaffold(
      backgroundColor: transparentBody ? Colors.transparent : context.colors.paper,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text(
              title,
              style: largeTitle == null
                  ? null
                  : TextStyle(color: context.colors.gold, fontWeight: FontWeight.w600),
            ),
            backgroundColor: context.colors.paper,
            foregroundColor: context.colors.ink,
            surfaceTintColor: Colors.transparent,
            stretch: true,
            pinned: true,
            actions: actions,
            flexibleSpace: largeTitle == null
                ? null
                : FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
                    title: largeTitle,
                  ),
          ),
          ...slivers,
        ],
      ),
    );
  }
}
