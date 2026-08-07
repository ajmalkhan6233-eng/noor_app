// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Umrah, step by step. Plain factual English instructions written for
// this app; not a substitute for guidance from a scholar or Hajj
// group (see the persistent notice every guide screen carries). The
// Tawaf step's Ramal/Idtiba rules and the Sa'i step's direction rule
// are described here only in general terms — the exact per-circuit
// logic lives once, in `pilgrimage/data/tawaf_reminders.dart` and
// `pilgrimage/data/sai_direction.dart`, and this screen quotes the
// same wording via the shared localisation keys those widgets use, so
// the two never drift apart.
//
// Per CLAUDE.md rule 7, Hajj/Umrah rite descriptions are never
// authored or paraphrased by the assistant in any language — only the
// short step titles are localised (structural labels, not rite
// substance); the body text stays English-only until a verified
// Tamil/Sinhala source exists. GuideStepCard shows a plain note when
// the active locale isn't English, rather than silently looking
// half-translated.

import '../../../l10n/generated/app_localizations.dart';
import 'guide_step.dart';

List<GuideStep> umrahGuideSteps(AppLocalizations l10n) => [
  GuideStep(
    title: l10n.umrahStep1Title,
    body:
        'Perform ghusl (a full ritual bath) if possible, then put on the '
        'ihram garments before reaching, or exactly at, the meeqat — the '
        'designated boundary point pilgrims must not pass without being '
        'in ihram. Men wear two unstitched white sheets; women wear '
        'ordinary modest clothing that covers the body, leaving the face '
        'and hands uncovered.',
  ),
  GuideStep(
    title: l10n.umrahStep2Title,
    body:
        'At or before the meeqat, make the niyyah (intention) to perform '
        'Umrah. This formally begins the state of ihram, after which '
        'certain everyday actions (such as cutting hair or nails) are '
        'paused until ihram ends at step 8.',
  ),
  GuideStep(
    title: l10n.umrahStep3Title,
    body:
        'From the moment ihram begins, recite the Talbiyah repeatedly — '
        'while walking, riding, or resting — continuing until the Kaaba '
        'comes into view on arrival at Masjid al-Haram.',
  ),
  GuideStep(
    title: l10n.umrahStep4Title,
    body:
        'Perform seven anti-clockwise circuits (tawaf) around the Kaaba, '
        'starting from the corner with the Black Stone, keeping the '
        'Kaaba on your left shoulder throughout each circuit.',
  ),
  GuideStep(
    title: l10n.umrahStep5Title,
    body:
        'After the seventh circuit, pray two rak\'ah at or near Maqam '
        'Ibrahim if possible. If that spot is crowded, this prayer may '
        'be offered anywhere else within Masjid al-Haram.',
  ),
  GuideStep(
    title: l10n.umrahStep6Title,
    body: 'Drink Zamzam water, available from dispensers around the mosque.',
  ),
  GuideStep(
    title: l10n.umrahStep7Title,
    body:
        'Perform Sa\'i: seven passages between the hills of Safa and '
        'Marwah, beginning at Safa and ending at Marwah on the seventh '
        'pass. The pilgrimage tracker\'s Sa\'i step (Home > Hajj & Umrah) '
        'shows the exact walking direction for each pass.',
  ),
  GuideStep(
    title: l10n.umrahStep8Title,
    body:
        'Exit ihram: men have the head fully shaved (halq) or, if '
        'preferred, the hair trimmed (taqsir); women have a small amount '
        'of hair trimmed (taqsir) — women do not shave. This completes '
        'the Umrah.',
  ),
];
