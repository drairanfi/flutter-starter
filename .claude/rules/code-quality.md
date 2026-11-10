# Code quality

- Lints: `very_good_analysis` (see `analysis_options.yaml`). `flutter analyze` must report zero
  issues. Do not add `// ignore:` without a reason comment; fix the cause first.
- Format with `dart format` (a hook does it after edits). Trailing commas as the formatter wants.
- No `print`; use `developer.log` only in infrastructure (as `LoggingInterceptor`).
- `const` everywhere possible; `final` for locals; avoid `dynamic` and `!` unless guarded.
- Small units: widgets under ~100 lines of `build`, methods that do one thing; extract classes, not
  `_buildX()` helper methods.
- Imports: `package:flutter_template/...` absolute imports (no relative `../`); sorted by the
  formatter/linter.
- Public API of a file is one concept; keep helpers private (`_name`).
- Comments explain why, not what; `///` doc on non-obvious public types (not required on every member).
- Async: `await` or `unawaited(...)` explicitly; check `context.mounted` after awaits that use context.
- Dispose controllers, subscriptions and notifiers you create.
- No dead code, no commented-out code, no TODO without context.
- Generated files are excluded from analysis; never edit them.
