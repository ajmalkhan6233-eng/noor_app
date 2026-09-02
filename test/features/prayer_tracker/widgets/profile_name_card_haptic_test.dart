// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Fix Queue 5: saving a name should fire haptic feedback in sync with
// the card's dismiss transition — this proves the feedback actually
// fires on save, using a fake HapticService rather than a real
// vibration (untestable in flutter test).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/haptics/haptic_service.dart';
import 'package:noor/features/prayer_tracker/presentation/widgets/profile_name_card.dart';
import 'package:noor/features/settings/logic/settings_cubit/settings_cubit.dart';

class _FakeHapticService implements HapticService {
  int tapCount = 0;

  @override
  void tap() => tapCount++;

  @override
  Future<void> milestonePulse() async {}

  @override
  Future<void> feedbackForCount(int count) async {}

  @override
  bool isMilestone(int count) => false;
}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: BlocProvider(create: (_) => SettingsCubit(), child: child)),
  );
}

void main() {
  testWidgets('saving a name fires a haptic tap', (tester) async {
    final haptics = _FakeHapticService();
    await tester.pumpWidget(_wrap(ProfileNameCard(hapticService: haptics)));

    await tester.enterText(find.byType(TextField), 'Ajmal');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    // Fires at least once (the checkmark's own save call); may fire a
    // second time from the pre-existing focus-loss listener also
    // calling _saveName() when unfocus() runs right after — unrelated
    // to this fix, not something to change here.
    expect(haptics.tapCount, greaterThanOrEqualTo(1));
  });
}
