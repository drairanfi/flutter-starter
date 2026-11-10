import 'package:flutter/material.dart';
import 'package:flutter_template/core/router/app_routes.dart';
import 'package:flutter_template/core/router/auth_redirect.dart';
import 'package:flutter_template/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_template/features/auth/presentation/providers/auth_controller.dart';
import 'package:flutter_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_template/features/settings/presentation/pages/settings_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// App router with an auth guard driven by [authControllerProvider].
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Bumped whenever the auth state changes so go_router re-runs `redirect`.
  final refresh = ValueNotifier<int>(0);
  ref
    ..onDispose(refresh.dispose)
    ..listen(authControllerProvider, (_, _) => refresh.value++);

  final router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      return authRedirect(
        isInitializing: auth.isLoading && !auth.hasValue && !auth.hasError,
        isSignedIn: auth.value != null,
        location: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsPage(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
