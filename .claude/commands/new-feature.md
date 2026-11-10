---
description: Scaffold a full feature (domain, data, presentation, route, l10n, tests). Usage - /new-feature <feature_name>
argument-hint: <feature_name>
---

Create the feature `$ARGUMENTS` (snake_case, English).

1. Read `.claude/knowledge/critical-constraints.md`. If the business domain or requirements for `$ARGUMENTS` are not known, ask for them (one question at a time) before writing code. Check `.claude/plans/` for an existing plan.
2. Reference: `lib/features/auth`.
3. Create under `lib/features/$ARGUMENTS/`:
   - `domain/`: freezed entity, `abstract interface class <Name>Repository`
   - `data/`: implementation (mock or Dio-based, throwing `Failure`) and `<name>_repository_provider.dart` (`@Riverpod(keepAlive: true)`, returns the interface)
   - `presentation/providers/<name>_controller.dart` (`@riverpod` notifier, `AsyncValue.guard`)
   - `presentation/pages/<name>_page.dart` and `presentation/widgets/` as needed (`AppScaffold`, `context.l10n`, theme colors)
4. Add `AppRoutes.<name>` and the `GoRoute` in `lib/core/router/`; update `authRedirect` + its test if the route is public.
5. Add ARB keys to both `app_en.arb` and `app_es.arb`.
6. Tests in `test/features/$ARGUMENTS/` (notifier with mocktail + provider overrides, repository, widget if relevant).
7. Run `dart run build_runner build`, `flutter gen-l10n`, `dart format .`, `flutter analyze`, `flutter test`; fix until green.
8. Summarise files created and any follow-ups. Do not commit.

Follow `.claude/rules/*`; no new dependencies, no cross-feature imports.
