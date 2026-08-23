---
name: noor-file-architecture
description: Use whenever creating a new file, a new feature folder, or deciding where code should live in noor. Also use when a Dart file is approaching or exceeding 150 lines, or when UI code seems to be reaching into data/logic directly.
---

# noor File Architecture

## Structure
```
lib/
  core/                  cross-feature singletons only
    constants/
    database/
    haptics/
    location/
    utils/
  features/<feature>/
    data/                repositories, data sources
    logic/               Cubit/Bloc — the only thing UI talks to
    presentation/         widgets, screens
```

## Rules
- No Dart file exceeds 150 lines. If a file is approaching the limit,
  split it — a widget file into smaller widgets, a cubit into a cubit
  + a helper, etc. Don't wait until you're over to split.
- `presentation/` never imports `data/` directly, and never calls
  `DatabaseHelper` or calculation logic directly. It only talks to a
  Cubit/Bloc in `logic/`.
- `logic/` never contains raw SQL or widget code — it calls into
  `data/` repositories and emits state.
- `core/` holds only things genuinely shared across 2+ features. If
  something is specific to one feature, it belongs in that feature's
  folder, not in core.
- New feature → scaffold all three subfolders (`data/`, `logic/`,
  `presentation/`) even if one starts near-empty.
