import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/l10n/l10n.dart';
import 'package:flutter_template/core/theme/theme_mode_controller.dart';
import 'package:flutter_template/features/auth/presentation/providers/auth_controller.dart';
import 'package:flutter_template/features/settings/presentation/widgets/theme_mode_selector.dart';
import 'package:flutter_template/shared/widgets/atoms/app_button.dart';
import 'package:flutter_template/shared/widgets/organisms/app_scaffold.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mode = ref.watch(themeModeControllerProvider);

    return AppScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        children: [
          Text(
            l10n.themeModeLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ThemeModeSelector(
            selected: mode,
            onChanged: ref
                .read(themeModeControllerProvider.notifier)
                .setThemeMode,
          ),
          const SizedBox(height: 32),
          AppButton(
            label: l10n.signOut,
            variant: AppButtonVariant.outlined,
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}
