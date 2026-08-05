import 'package:flutter/services.dart';

/// Centralizes all tactile feedback so UI widgets and Cubits never
/// call `HapticFeedback` directly (rule 5 in .clinerules).
class HapticService {
  HapticService._();
  static final HapticService instance = HapticService._();

  static const Set<int> _milestones = {33, 66, 100};

  /// Call on every tap increment. Light impact for a normal count,
  /// escalating to a double heavy pulse on milestone counts.
  Future<void> onCount(int newCount) async {
    if (_milestones.contains(newCount)) {
      await _milestonePulse();
    } else {
      await HapticFeedback.lightImpact();
    }
  }

  Future<void> _milestonePulse() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.heavyImpact();
  }

  Future<void> onReset() async {
    await HapticFeedback.mediumImpact();
  }
}
