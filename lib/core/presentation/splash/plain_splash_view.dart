// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reduced-motion fallback: just the NOOR wordmark, calm and still,
// with no animation beyond the parent's fade — a dissolve has no
// meaningful "settled" instant to jump to. The Arabic Bismillah moved
// out of the splash sequence entirely (2026-09-05, direct request) —
// it now leads the "Assalamu Alaikum" greeting on Home instead (see
// hero_card.dart).

import 'package:flutter/material.dart';

import '../widgets/noor_splash_wordmark.dart';

class PlainSplashView extends StatelessWidget {
  const PlainSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: NoorSplashWordmark(fontSize: 32));
  }
}
