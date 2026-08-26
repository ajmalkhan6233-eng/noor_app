---
name: noor-build-and-deploy
description: Use whenever building, launching, or relaunching the app on a device, or when a build/analyze command seems stuck or hung. Covers a confirmed environment limitation and process-cleanup discipline.
---

# noor Build & Deploy

## Confirmed limitation — don't retry this
Instant hot reload (and `flutter attach` to an already-running app) does
not work in this environment: the tools available have no real
terminal (no PTY), and Flutter's interactive keystroke listener
requires one. This was tested twice (FIFO stdin, and attach) and both
hit hard environment walls, not fixable with workarounds.

**Use `flutter build` + `adb install -r` for every change, Dart or
native.** It's slower (~1 minute per cycle) but reliable. Don't spend
time re-attempting hot reload — that's a settled, confirmed dead end.

## Process hygiene
Killing a `flutter run` process can leave stale locks behind (Gradle
daemon locks, Dart analysis server locks) that cause the *next*
command to hang silently. If a build or `flutter analyze` seems stuck
with no output for an unusually long time after a process was killed,
check for and clear leftover lock files before assuming something
else is wrong.

Also: killing the host-side `flutter run` process does not necessarily
kill the Android app itself — it may keep running on the device with
its debug VM service gone. If relaunching seems to "do nothing," check
whether the old instance is still in the foreground rather than
assuming the relaunch failed.
