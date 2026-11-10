---
name: flutter-widgets
description: Use when building or refactoring Flutter widgets, pages or shared UI (atomic design, const, performance, theme tokens) in this repo.
---

Read `.claude/rules/widgets-atomic-design.md` and `theming-and-design-tokens.md`.

1. Reuse first: `AppButton` (atom), `LabeledTextField` (molecule), `AppScaffold` (organism).
2. Shared widgets take data and callbacks only; no feature imports, no copy baked in.
3. Colors and text from `Theme.of(context)`; strings from `context.l10n`.
4. Small `StatelessWidget` classes, `const` constructors, narrow `ref.watch(p.select(...))`, `ListView.builder` for lists.
5. States: loading, error (`localizeError`), empty, data. Tooltips on icon buttons.
6. Add a widget test in `test/shared/` for new shared widgets.
