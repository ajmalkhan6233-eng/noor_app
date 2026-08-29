// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Locked decision (2026-08-29): no payment system, no feature locks —
// everything free, always. Monetization is entirely the existing
// Support the Developer screen (WhatsApp/email handoff, no in-app
// payment, no INTERNET permission). This service only remembers two
// dismissal states so the two touchpoints below never nag: the home
// card, once dismissed, is gone for good; a milestone nudge shows
// once per milestone key, ever.

import 'package:shared_preferences/shared_preferences.dart';

class SupportPromptService {
  static const _dismissedKey = 'support_card_dismissed';
  static const _shownMilestonesKey = 'support_milestones_shown';

  Future<bool> isHomeCardDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dismissedKey) ?? false;
  }

  Future<void> dismissHomeCard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dismissedKey, true);
  }

  Future<bool> shouldShowMilestoneNudge(String milestoneKey) async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getStringList(_shownMilestonesKey) ?? [];
    return !shown.contains(milestoneKey);
  }

  Future<void> markMilestoneNudgeShown(String milestoneKey) async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getStringList(_shownMilestonesKey) ?? [];
    if (!shown.contains(milestoneKey)) {
      shown.add(milestoneKey);
      await prefs.setStringList(_shownMilestonesKey, shown);
    }
  }
}
