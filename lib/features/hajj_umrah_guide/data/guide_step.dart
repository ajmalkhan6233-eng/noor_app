// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Plain data holder for one instructional step or day of the Hajj/Umrah
// guide. All `title`/`body` text in this feature's *.dart data files is
// factual, plainly-written English prose describing what to do and
// when — never a religious pronouncement, never Arabic/Tamil/Sinhala.

class GuideStep {
  const GuideStep({required this.title, required this.body});

  /// Short heading, e.g. "1. Ihram" or "9th Dhul Hijjah".
  final String title;

  /// One or more sentences describing the step in plain English.
  final String body;
}
