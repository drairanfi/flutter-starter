---
name: riverpod
description: Use when creating or changing Riverpod providers, notifiers, repository providers or AsyncValue handling in this Flutter repo (codegen only).
---

Read `.claude/rules/riverpod.md` and the example `lib/features/auth/presentation/providers/auth_controller.dart`.

Checklist:
1. Annotate with `@riverpod` / `@Riverpod(keepAlive: true)` and add `part '<file>.g.dart';`.
2. Repository provider in `data/`, returns the interface; notifier `FooController` in `presentation/providers/`.
3. `build` only reads (`ref.watch`); mutations are methods using `AsyncValue.guard`.
4. Widgets: `ref.watch` in `build`, `ref.read` in callbacks, `ref.listen` for one-off effects.
5. Run `dart run build_runner build`; test with `ProviderContainer(overrides: [...])`.

Never: `Provider(...)`, `StateProvider`, `StateNotifier`, Dio/storage/`BuildContext` inside a notifier.
