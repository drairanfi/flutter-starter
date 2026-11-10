import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/app.dart';
import 'package:flutter_template/core/config/app_config.dart';
import 'package:flutter_template/core/config/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared startup path used by every flavor entrypoint.
Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const App(),
    ),
  );
}
