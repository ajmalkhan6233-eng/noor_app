// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/support/support_prompt_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SupportPromptService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = SupportPromptService();
  });

  group('home card dismissal', () {
    test('is not dismissed by default', () async {
      expect(await service.isHomeCardDismissed(), isFalse);
    });

    test('stays dismissed once dismissed', () async {
      await service.dismissHomeCard();
      expect(await service.isHomeCardDismissed(), isTrue);
    });
  });

  group('milestone nudges', () {
    test('an unseen milestone should show', () async {
      expect(await service.shouldShowMilestoneNudge('tasbih_100_complete'), isTrue);
    });

    test('a milestone never shows again once marked shown', () async {
      await service.markMilestoneNudgeShown('tasbih_100_complete');
      expect(await service.shouldShowMilestoneNudge('tasbih_100_complete'), isFalse);
    });

    test('marking one milestone shown does not affect a different key', () async {
      await service.markMilestoneNudgeShown('tasbih_100_complete');
      expect(await service.shouldShowMilestoneNudge('prayer_streak_7'), isTrue);
    });

    test('marking the same milestone shown twice does not duplicate it', () async {
      await service.markMilestoneNudgeShown('tasbih_100_complete');
      await service.markMilestoneNudgeShown('tasbih_100_complete');
      expect(await service.shouldShowMilestoneNudge('tasbih_100_complete'), isFalse);
    });
  });
}
