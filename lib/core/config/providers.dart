import 'package:flutter_template/core/config/app_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'providers.g.dart';

/// Runtime configuration. Overridden in `bootstrap()`.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) =>
    throw UnimplementedError('appConfigProvider must be overridden');

/// Initialised [SharedPreferences]. Overridden in `bootstrap()`.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferencesProvider must be overridden');
