// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A SliverAppBar with a large title that shrinks into a compact bar
// on scroll, stretch enabled — the shared shape for every primary
// tab screen instead of a plain AppBar.

import 'package:flutter/material.dart';
import '../../../core/constants/app_color_tokens.dart';


class CollapsingScaffold extends StatelessWidget {
  const CollapsingScaffold({
    super.key,
    required this.title,
    required this.slivers,
    this.actions,
    this.transparentBody = false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: transparentBody ? Colors.transparent : context.colors.paper,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text(title),
            backgroundColor: context.colors.paper,
            foregroundColor: context.colors.ink,
            surfaceTintColor: Colors.transparent,
            stretch: true,
            pinned: true,
            actions: actions,
          ),
          ...slivers,
        ],
      ),
    );
  }
}
