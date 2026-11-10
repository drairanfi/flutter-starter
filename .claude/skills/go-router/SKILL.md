---
name: go-router
description: Use when adding or changing routes, navigation or the auth redirect guard (go_router) in this Flutter repo.
---

Read `.claude/rules/routing.md`; code: `lib/core/router/`.

1. Add the path constant to `AppRoutes` (`app_routes.dart`).
2. Register `GoRoute(path: AppRoutes.x, builder: (_, _) => const XPage())` in `app_router.dart`.
3. Navigate with `context.go` / `context.push` and `AppRoutes` only.
4. Public route? Update `authRedirect` and `test/core/router/auth_redirect_test.dart`.
5. Keep redirect logic pure; never navigate from a notifier.
