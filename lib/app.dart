import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/l10n/generated/app_localizations.dart';
import 'package:flutter_template/core/router/app_router.dart';
import 'package:flutter_template/core/theme/app_theme.dart';
import 'package:flutter_template/core/theme/theme_mode_controller.dart';

/// Root widget.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeControllerProvider),
      routerConfig: ref.watch(appRouterProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
