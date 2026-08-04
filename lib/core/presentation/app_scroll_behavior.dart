// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// BouncingScrollPhysics everywhere — lists overscroll and spring back
// like iOS, on every platform, without touching each screen's list.

import 'package:flutter/material.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}
