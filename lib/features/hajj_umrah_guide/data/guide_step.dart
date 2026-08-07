// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Plain data holder for one instructional step or day of the Hajj/Umrah
// guide. `body` text in this feature's *.dart data files is factual,
// plainly-written English prose describing what to do and when — kept
// English-only per CLAUDE.md rule 7 until a verified Tamil/Sinhala
// source exists (see GuideStepCard's locale note). `title` may be a
// localised short structural label (e.g. umrah_guide_steps.dart).

class GuideStep {
  const GuideStep({required this.title, required this.body});

  /// Short heading, e.g. "1. Ihram" or "9th Dhul Hijjah".
  final String title;

  /// One or more sentences describing the step in plain English.
  final String body;
}
