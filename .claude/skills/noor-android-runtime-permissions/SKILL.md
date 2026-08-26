---
name: noor-android-runtime-permissions
description: Use whenever adding or touching any feature that relies on an Android OS-level capability — notifications, exact alarms, location, sensors. Prevents the class of bug where a feature silently does nothing because a required runtime permission was never declared.
---

# noor Android Runtime Permissions

## The bug that already happened
Local notifications (`.show()` / `.zonedSchedule()`) were silently
doing nothing on Android 13+, with no error anywhere — because
`POST_NOTIFICATIONS` was never declared in the manifest. This wasn't
just the Test Adhan button failing — it likely explained an earlier,
separately-reported "reminder set, nothing fired" complaint too. One
missing permission, multiple symptoms that looked unrelated.

## Rule
Whenever a feature depends on an Android OS-level capability, check
*both* of these before considering it done:
1. The permission is declared in AndroidManifest.xml.
2. Where required (Android 13+ notifications, runtime location, etc.),
   the app actually requests it at runtime — a manifest declaration
   alone isn't always enough.

## Known Android version-gated permissions relevant to this app
- `POST_NOTIFICATIONS` — required Android 13+ (API 33+), or
  notifications silently no-op.
- Exact alarm scheduling — may need `SCHEDULE_EXACT_ALARM` depending
  on the API level targeted; check against the current target SDK.
- Location — already handled, but re-verify if location code changes.

If a feature that clearly "should" work does nothing with no visible
error, check permissions before assuming the bug is in the feature's
own logic.
