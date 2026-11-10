import 'package:flutter_template/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_template/features/auth/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

/// Session state: `AsyncData(null)` = signed out, `AsyncData(user)` = in.
///
/// While `build` restores the session the state is `AsyncLoading` without a
/// value; the router treats that as "initialising". Later `signIn` calls keep
/// the previous value so the UI does not flicker back to a splash screen.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<User?> build() => ref.watch(authRepositoryProvider).restoreSession();

  Future<void> signIn({required String email, required String password}) async {
    final repository = ref.read(authRepositoryProvider);
    // Riverpod keeps the previous value while loading/erroring.
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.signIn(email: email, password: password),
    );
    state = result;
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}
