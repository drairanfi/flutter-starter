import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/providers.dart';
import 'package:flutter_template/core/l10n/l10n.dart';
import 'package:flutter_template/core/router/app_routes.dart';
import 'package:flutter_template/features/auth/presentation/providers/auth_controller.dart';
import 'package:flutter_template/shared/widgets/organisms/app_scaffold.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(authControllerProvider).value;
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    return AppScaffold(
      title: l10n.homeTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: l10n.settingsTitle,
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.homeWelcome(user?.name ?? ''),
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(l10n.homeEnvironment(config.environment.name)),
        ],
      ),
    );
  }
}
