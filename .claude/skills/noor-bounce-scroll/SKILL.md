---
name: noor-bounce-scroll
description: Use when applying scroll physics to any scrollable list or page — the "hits a wall and bounces back" overscroll effect at the top/bottom of content.
---

# noor Bounce Scroll

## What's wanted
When scrolling reaches the very top or bottom of content and the user
keeps pulling, it should stretch slightly and spring back — a subtle
rubber-band feel, not a hard, dead stop. Small and natural, not
exaggerated or bouncy-cartoonish.

## Ready implementation
Flutter has this built in — `BouncingScrollPhysics` gives exactly this
effect natively:

```dart
ListView(
  physics: const BouncingScrollPhysics(),
  children: [...],
)
```

Apply this consistently to every scrollable screen (Home, Quran list,
Dua & Dhikr list, Settings, etc.) rather than the default
`ClampingScrollPhysics`, which stops dead with no bounce.

## If a stronger effect is wanted
`BouncingScrollPhysics` alone is subtle by design — that's correct for
this app (per noor-animation-performance, motion should feel
intentional, not gimmicky). Don't layer extra custom overscroll
animation on top unless specifically asked; the built-in physics
already solves this cleanly and performantly.
