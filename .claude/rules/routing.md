# Routing (go_router)

- Paths are constants in `lib/core/router/app_routes.dart` (`AppRoutes`). No string literals elsewhere.
- Routes are declared in `lib/core/router/app_router.dart` (`appRouterProvider`, keepAlive).
  Add the page import and a `GoRoute(path: AppRoutes.x, builder: (_, _) => const XPage())`.
- Navigate with `context.go(AppRoutes.x)` (replace stack) or `context.push(AppRoutes.x)` (stack).
- Auth guard: pure function `authRedirect` (`core/router/auth_redirect.dart`) called from
  `redirect`. The router listens to `authControllerProvider` and bumps a `ValueNotifier` given
  to `refreshListenable`. Keep redirect logic pure and unit-tested; never navigate from a notifier.
- Splash (`AppRoutes.splash`) is shown while the session is restoring.
- A new public (unauthenticated) route must be added to `authRedirect` and its test
  (`test/core/router/auth_redirect_test.dart`), otherwise the guard sends users to login.
- Path or query parameters: parse in the route builder, pass typed values to the page. Add a
  path helper next to the constant if needed (e.g. `static String detail(String id) => '/items/$id';`).
- Dispose what you create (`ref.onDispose(router.dispose)`).
