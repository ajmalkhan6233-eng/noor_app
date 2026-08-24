// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown on Home and the Prayer Times tab while [PrayerState.result]
// is still null AND location is actively resolving (GPS lookup in
// flight on first launch) — replaces a blank/stuck-looking screen
// with a shape that reads as "prayer times are on the way", not
// "nothing is here" or "you need to do something". When location
// isn't resolving and there's still no result, callers should fall
// back to their own "set a location" prompt instead of this.

import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/skeleton_box.dart';

class PrayerLoadingSkeleton extends StatelessWidget {
  const PrayerLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading prayer times',
      child: AppCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: SkeletonBox(width: 160, height: 20)),
            const SizedBox(height: 20),
            for (var i = 0; i < 5; i++) ...[
              Row(
                children: [
                  SkeletonBox(width: 90 + (i.isEven ? 0 : 20)),
                  const Spacer(),
                  const SkeletonBox(width: 56),
                ],
              ),
              if (i < 4) const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}
