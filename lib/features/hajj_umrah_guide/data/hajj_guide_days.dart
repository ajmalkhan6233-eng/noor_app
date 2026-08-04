// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Hajj, day by day (8th-13th Dhul Hijjah). Plain factual English
// instructions written for this app; not a substitute for guidance
// from a scholar or Hajj group (see the persistent notice every guide
// screen carries). The Tawaf al-Ifadah and Sa'i mentioned on the 10th
// follow the same rules described in the Umrah guide and implemented
// in `pilgrimage/data/tawaf_reminders.dart` / `sai_direction.dart`.

import 'guide_step.dart';

const List<GuideStep> hajjGuideDays = [
  GuideStep(
    title: '8th Dhul Hijjah',
    body:
        'Enter ihram (if not already in ihram) and proceed to Mina, '
        'spending the day and night there ahead of the standing at '
        'Arafat the next day.',
  ),
  GuideStep(
    title: '9th Dhul Hijjah — Day of Arafat',
    body:
        'Depart for Arafat. Stand (wuquf) within the boundaries of '
        'Arafat from after sunrise until sunset — the central rite of '
        'Hajj. After sunset, move to Muzdalifah and spend the night '
        'there, collecting pebbles for the stoning of the Jamarat over '
        'the following days.',
  ),
  GuideStep(
    title: '10th Dhul Hijjah — Eid al-Adha',
    body:
        'Stone Jamarat al-Aqaba with seven pebbles, one at a time. Have '
        'an animal sacrificed (or arrange for one). Have the head shaved '
        '(halq) or trimmed (taqsir) for men, or a small amount of hair '
        'trimmed (taqsir) for women. Then perform Tawaf al-Ifadah — '
        'seven anti-clockwise circuits around the Kaaba, Kaaba on the '
        'left shoulder — followed by Sa\'i: seven passages between Safa '
        'and Marwah, starting at Safa and ending at Marwah on the '
        'seventh pass, the same rules as in Umrah.',
  ),
  GuideStep(
    title: '11th-13th Dhul Hijjah — Days of Tashreeq',
    body:
        'Remain in Mina. Each day, after Dhuhr, stone all three Jamarat '
        'in order: small (al-Sughra), medium (al-Wusta), then large '
        '(al-Aqaba) — seven pebbles at each, one at a time.',
  ),
];
