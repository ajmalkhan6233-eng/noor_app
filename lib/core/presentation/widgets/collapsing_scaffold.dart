// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A SliverAppBar with a large title that shrinks into a compact bar
// on scroll, stretch enabled — the shared shape for every primary
// tab screen instead of a plain AppBar.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CollapsingScaffold extends StatelessWidget {
  const CollapsingScaffold({
    super.key,
    required this.title,
    required this.slivers,
    this.actions,
  });

  final String title;
  final List<Widget> slivers;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text(title),
            backgroundColor: AppColors.paper,
            foregroundColor: AppColors.ink,
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
