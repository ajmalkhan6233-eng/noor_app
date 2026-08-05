# noor (نور) — UI/UX & Design System

**Status:** Reconstructed from project history, 5 August 2026.
**Important:** the palette below is the one that actually shipped in build
18. It supersedes the dark emerald palette from early scaffolding — see the
note at the bottom about a regression this introduced.

---

## 1. History — why the palette changed

The original scaffold used a dark emerald/gold palette. After comparing
against Athan, the direction was rejected outright:

> This design for ugly designs, you know, background is black and green...
> take it away.

Direction was reset to a light theme modeled on Athan and a set of
reference sites, delivered in build 18.

## 2. Shipped palette (current, correct)

| Token | Hex | Use |
|---|---|---|
| `paper` | `#F2EFE7` | Background |
| `card` | `#FFFFFF` | Card surfaces |
| `ink` | `#16211C` | Primary text |
| `sage` | `#6E7B72` | Secondary text |
| `hairline` | `#E3DFD4` | Borders, 1px |
| `emerald` | `#14603C` | Accent, active states |
| `gold` | `#B8912F` | Reserved for the Allah calligraphy only |

Rules that came with this palette:
- Cards: white on cream, 1px hairline border, soft shadow, 20px radius.
- `surfaceTintColor: Colors.transparent` set everywhere, so Material 3
  doesn't auto-tint surfaces green.
- Nothing dark green may remain on any screen.

## 3. Typography

- **Cormorant** — display type (headers, prayer name).
- **Inter** — body text.
- **Amiri** — Arabic text, including the Allah calligraphy.
- **Noto Sans Tamil** / **Noto Sans Sinhala** — bundled for trilingual
  support.
- All fonts bundled as SIL OFL assets — no network font loading.

## 4. The Allah calligraphy mark

الله in Amiri, gold (`#B8912F`), embossed: light highlight offset
up-left, soft dark shadow offset down-right, so it reads as raised from the
paper. Centred in the header of every main screen. Two hard constraints:
never overlaps content, never sits in a tappable area.

## 5. Navigation & layout

- Bottom nav: Home, Prayer Times, Quran, Azkar, More.
- Home dashboard: location + Hijri date in the header, Allah calligraphy
  centred, next-prayer card with a circular countdown ring in emerald,
  quick-actions row (Tasbih, Qibla, Calendar, Zakat), today's prayers with
  the current one marked, notification toggles live on the dashboard (not
  buried in Settings).
- Draggable elements: qibla compass, settings gear, tasbih counter — all
  remember their last position.

## 6. Motion

Staggered entrances, viewport-triggered list reveals, tab cross-fades, tap
scale-down, an "astrolabe sweep" transition motif, iOS-style bouncy scroll
and shrinking large title. **Reduced-motion is respected** — all of the
above degrades gracefully when the OS accessibility setting is on.

## 6.5 The splash already has this energy

Before reaching for a new library or a new AI, note: **the app already has
a cosmic particle/energy splash screen**, shipped and working — Bismillah
against an expanding galaxy, light travelling toward the viewer, a
breathing "nur" core, slow field rotation, per-star twinkle, word-by-word
reveal, on a deep emerald radial gradient (never black). It's config-driven
via `splash_config.dart` with a single `cosmicEnabled` switch. This is the
same visual language as the "MEMORY" book-igniting-into-particles reference
clips (glowing core, particles trailing outward along light paths, warm
gold against cool cyan/blue) — just already built natively in Flutter, not
Three.js. Extending that same particle system to other screens (e.g. a
milestone burst on the Tasbih counter, an ignition moment on the prayer
countdown ring) is a matter of reusing this existing code, not starting
over.

## 7. Native "cosmic/glass" accent layer

A separate design reference (Master Design & Token Efficiency Directive)
specified a Big Bang / glassmorphism aesthetic using Three.js, Framer
Motion, and a cyan/gold/obsidian palette. Those specific libraries don't
exist in Flutter, so the intent — depth, glow, tactile feedback, spring
physics — is implemented natively instead, layered on top of the palette
above rather than replacing it:

- **Glass panels:** `BackdropFilter` + `ImageFilter.blur`.
- **Glow:** `BoxShadow` with the `gold` token at low opacity, intensifying
  on milestone states (e.g. Tasbih counts of 33/66/100).
- **Spring/tactile feedback:** native `AnimationController` scale-down on
  tap, not a physics library.
- Used currently on the Tasbih counter button; available as a pattern for
  other interactive elements (qibla dial, prayer countdown ring).

## 8. ⚠ Known regression

The `update_core_architecture.yml` payload generated earlier in this
session wrote `app_colors.dart` using the **old dark emerald values**
(`0xFF0A1912` background, `0xFFD4AF37` gold), not the shipped light palette
in section 2. If that workflow ran, `app_colors.dart` currently does not
match the rest of the app. This needs to be corrected — see the Claude Code
prompt in 08_CLOUD_DEVELOPER_MASTER_PROMPT.md, which fixes it.
