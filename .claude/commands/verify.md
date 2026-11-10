---
description: Run the full definition-of-done pipeline (codegen, l10n, format, analyze, test) and summarise.
---

Run in order, stopping to report on the first failure:

1. `dart run build_runner build`
2. `flutter gen-l10n`
3. `dart format --set-exit-if-changed .` (if it fails, run `dart format .` and note which files changed)
4. `flutter analyze`
5. `flutter test`

Then summarise in a short table: step, status, key numbers (issues, tests passed/failed). For failures, give the file, the cause and the proposed fix. Do not edit code unless asked; formatting is the only exception.
