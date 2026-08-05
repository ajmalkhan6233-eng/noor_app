// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Centralized haptic feedback. Cubits call this service instead of
// touching `HapticFeedback` directly, so vibration behavior stays
// consistent and testable (mockable) across features.

import 'dart:async';
import 'package:flutter/services.dart';

/// Milestone counts that trigger a heavier confirmation pulse during
/// tasbih (dhikr) counting, per `.clinerules` §6.
const List<int> kTasbihMilestones = [33, 66, 100];

/// Provides haptic feedback for interactive counters.
///
/// Kept dependency-free (no plugins beyond Flutter's own `services.dart`)
/// so it works fully offline and needs no platform channel setup beyond
/// what Flutter ships with.
class HapticService {
  const HapticService();

  /// Light tap feedback — fired on every single tasbih count.
  void tap() {
    HapticFeedback.lightImpact();
  }

  /// Heavier double-pulse feedback for milestone counts (33, 66, 100).
  ///
  /// Fires a medium impact, a brief pause, then a heavy impact so the
  /// user can feel the milestone without looking at the screen.
  Future<void> milestonePulse() async {
    HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    HapticFeedback.heavyImpact();
  }

  /// Convenience: fires the correct feedback for a given new [count].
  Future<void> feedbackForCount(int count) async {
    if (kTasbihMilestones.contains(count)) {
      await milestonePulse();
    } else {
      tap();
    }
  }

  /// Whether [count] lands on a milestone. Exposed so UI can trigger a
  /// visual pulse in sync with the haptic one.
  bool isMilestone(int count) => kTasbihMilestones.contains(count);
}
