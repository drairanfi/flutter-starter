import 'package:flutter/material.dart';
import 'package:flutter_template/core/config/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

const _themeModeKey = 'theme_mode';

/// Holds the current [ThemeMode] and persists it in SharedPreferences.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() {
    final stored = ref
        .watch(sharedPreferencesProvider)
        .getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref
        .read(sharedPreferencesProvider)
        .setString(_themeModeKey, mode.name);
  }
}
