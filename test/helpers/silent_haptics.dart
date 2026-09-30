// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:noor/core/haptics/haptic_service.dart';

/// A HapticService that only counts: plain `test()` runs have no
/// platform binding, so the real HapticFeedback calls would throw.
class SilentHaptics implements HapticService {
  int taps = 0;
  int pulses = 0;

  @override
  void tap() => taps++;

  @override
  Future<void> milestonePulse() async => pulses++;

  @override
  Future<void> feedbackForCount(int count) async {}

  @override
  bool isMilestone(int count) => false;
}
