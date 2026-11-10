import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/app.dart';
import 'package:flutter_template/core/config/app_config.dart';
import 'package:flutter_template/core/config/providers.dart';
import 'package:flutter_template/core/router/app_routes.dart';
import 'package:flutter_template/core/router/auth_redirect.dart';
import 'package:flutter_template/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_template/features/auth/domain/auth_repository.dart';
import 'package:flutter_template/features/auth/domain/user.dart';
import 'package:flutter_template/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository;

void main() {
  group('authRedirect', () {
    String? redirect({
      required String at,
      bool initializing = false,
      bool signedIn = false,
    }) => authRedirect(
      isInitializing: initializing,
      isSignedIn: signedIn,
      location: at,
    );

    test('sends everything to splash while initialising', () {
      expect(redirect(initializing: true, at: '/'), AppRoutes.splash);
      expect(redirect(initializing: true, at: AppRoutes.splash), isNull);
    });

    test('sends signed-out users to login', () {
      expect(redirect(at: AppRoutes.home), AppRoutes.login);
      expect(redirect(at: AppRoutes.settings), AppRoutes.login);
      expect(redirect(at: AppRoutes.login), isNull);
    });

    test('sends signed-in users away from login and splash', () {
      expect(redirect(signedIn: true, at: AppRoutes.login), AppRoutes.home);
      expect(redirect(signedIn: true, at: AppRoutes.splash), AppRoutes.home);
    });

    test('lets signed-in users reach protected pages', () {
      expect(redirect(signedIn: true, at: AppRoutes.home), isNull);
      expect(redirect(signedIn: true, at: AppRoutes.settings), isNull);
    });
  });

  group('router with auth guard', () {
    const user = User(id: '1', email: 'jane@acme.co', name: 'jane');
    late MockAuthRepository repository;

    Future<void> pumpApp(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(
              const AppConfig(
                environment: Environment.dev,
                apiBaseUrl: 'https://test.invalid',
              ),
            ),
            sharedPreferencesProvider.overrideWithValue(prefs),
            authRepositoryProvider.overrideWithValue(repository),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();
    }

    setUp(() {
      repository = MockAuthRepository();
    });

    testWidgets('shows login when there is no session', (tester) async {
      when(() => repository.restoreSession()).thenAnswer((_) async => null);

      await pumpApp(tester);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets('shows home when a session is restored', (tester) async {
      when(() => repository.restoreSession()).thenAnswer((_) async => user);

      await pumpApp(tester);

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('Hello, jane!'), findsOneWidget);
    });

    testWidgets('navigates to home after a successful sign in', (tester) async {
      when(() => repository.restoreSession()).thenAnswer((_) async => null);
      when(
        () => repository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => user);

      await pumpApp(tester);
      await tester.enterText(find.byType(TextFormField).at(0), 'jane@acme.co');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });
  });
}
