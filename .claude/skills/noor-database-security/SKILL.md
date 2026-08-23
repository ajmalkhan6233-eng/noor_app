---
name: noor-database-security
description: Use whenever writing SQL, touching DatabaseHelper, adding a new table/repository, or working on release-readiness items related to the local database. Covers the encrypted SQLite setup and the outstanding Keystore passphrase blocker.
---

# noor Database & Security

## Setup
`lib/core/database/database_helper.dart` owns the single encrypted
SQLite connection via `sqflite_sqlcipher`. Feature repositories call
into it — never open a second connection, never bypass it.

## Rules
- All queries parameterized. No string-concatenated SQL, ever.
- Each feature repository owns its own `CREATE TABLE` statements,
  wired into `DatabaseHelper._onCreate`.
- Zero network sync of any table, ever — this database never leaves
  the device.

## Release blocker — do not ship without fixing this
`DatabaseHelper._passphrase()` currently returns a hardcoded
placeholder string. Before any release build:
1. Source the passphrase from Android Keystore (e.g. via
   `flutter_secure_storage` backed by Keystore, or an equivalent
   Keystore-backed approach).
2. Confirm the passphrase is generated per-install, not hardcoded or
   shared across installs.
3. Remove the placeholder and the TODO comment once done.

## Anti-cloning note
Google's standard anti-piracy check (Play Integrity API) requires a
network call, which conflicts with noor's zero-network architecture.
Baseline protection instead: R8/ProGuard code obfuscation on release
builds (works fully offline). This won't stop a determined actor, and
that's an accepted trade-off given the app's privacy-first design —
don't try to bolt on a network-based integrity check to compensate.
