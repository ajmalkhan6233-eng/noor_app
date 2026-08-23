---
name: noor-monetization-guardrails
description: Use whenever a task touches pricing, purchases, unlocking content, or anything that could be interpreted as "add a paid feature." Enforces the locked monetization model and prevents accidental reintroduction of billing SDKs or network permissions.
---

# noor Monetization Guardrails

## The locked model
noor is a **paid app** — one-time price set on the Play Store listing.
That's it. No in-app purchases, no subscriptions, no ads, no freemium
unlock. Free distribution to individuals happens through Play Console
promo codes, generated and handed out manually — that's a Play Console
action, not an app feature, and never touches the codebase.

## Why this is a hard rule, not a preference
Google Play Billing (the only way to do IAP) requires the INTERNET
permission and live network calls to verify purchases. Adding it would
break noor's core promise of zero network calls — which is the actual
product differentiator, not a nice-to-have.

## What this means in practice
- Never add `in_app_purchase`, Play Billing, or any billing-adjacent
  package to `pubspec.yaml`.
- Never add the INTERNET permission to AndroidManifest.xml for a
  monetization reason. (If it's ever needed for something else
  entirely, that's a separate, explicit architecture decision — flag
  it, don't add it quietly.)
- Never build a "free tier / pro tier" split inside the app. There is
  one version of the app; the price gate is external to it.
- If a future revenue idea comes up (content packs, licensing to other
  communities, etc.) — that's tracked in CLAUDE.md's Deferred section,
  not built without an explicit go-ahead.
