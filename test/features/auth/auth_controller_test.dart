import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/error/failure.dart';
import 'package:flutter_template/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_template/features/auth/domain/auth_repository.dart';
import 'package:flutter_template/features/auth/domain/user.dart';
import 'package:flutter_template/features/auth/presentation/providers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository;

void main() {
  const user = User(id: '1', email: 'a@b.co', name: 'a');
  late MockAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockAuthRepository();
    when(() => repository.restoreSession()).thenAnswer((_) async => null);
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  test('starts signed out when there is no persisted session', () async {
    final result = await container.read(authControllerProvider.future);

    expect(result, isNull);
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('restores a persisted session on build', () async {
    when(() => repository.restoreSession()).thenAnswer((_) async => user);

    expect(await container.read(authControllerProvider.future), user);
  });

  test('signIn success exposes the user', () async {
    when(() => repository.signIn(email: 'a@b.co', password: 'secret'))
        .thenAnswer((_) async => user);
    await container.read(authControllerProvider.future);

    await container
        .read(authControllerProvider.notifier)
        .signIn(email: 'a@b.co', password: 'secret');

    final state = container.read(authControllerProvider);
    expect(state.hasError, isFalse);
    expect(state.value, user);
  });

  test('signIn failure surfaces the Failure and stays signed out', () async {
    when(
      () => repository.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const InvalidCredentialsFailure());
    await container.read(authControllerProvider.future);

    await container
        .read(authControllerProvider.notifier)
        .signIn(email: 'a@b.co', password: 'wrong');

    final state = container.read(authControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error, isA<InvalidCredentialsFailure>());
    expect(state.value, isNull);
  });

  test('signIn goes through a loading state', () async {
    when(
      () => repository.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => user);
    await container.read(authControllerProvider.future);

    final states = <bool>[];
    container.listen(
      authControllerProvider,
      (_, next) => states.add(next.isLoading),
    );
    await container
        .read(authControllerProvider.notifier)
        .signIn(email: 'a@b.co', password: 'x');

    expect(states, [true, false]);
  });

  test('signOut clears the session', () async {
    when(() => repository.restoreSession()).thenAnswer((_) async => user);
    when(() => repository.signOut()).thenAnswer((_) async {});
    await container.read(authControllerProvider.future);

    await container.read(authControllerProvider.notifier).signOut();

    verify(() => repository.signOut()).called(1);
    expect(container.read(authControllerProvider).value, isNull);
  });
}
