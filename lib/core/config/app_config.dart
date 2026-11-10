import 'package:flutter/foundation.dart';

/// Deployment environments supported by the template.
enum Environment {
  dev,
  staging,
  prod;

  /// Parses [value] (case-insensitive), returning [fallback] when it is empty
  /// or unknown.
  static Environment parse(String value, {required Environment fallback}) {
    for (final env in values) {
      if (env.name == value.toLowerCase()) return env;
    }
    return fallback;
  }
}

/// Immutable runtime configuration.
///
/// Values come from `--dart-define-from-file=config/<env>.json` (see README).
/// Never put secrets in these files: they are compiled into the binary.
@immutable
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableLogging = false,
  });

  /// Reads compile-time defines. Each entrypoint passes its own
  /// [defaultEnvironment] so `flutter run -t lib/main_dev.dart` works even
  /// without a define file.
  factory AppConfig.fromEnvironment({required Environment defaultEnvironment}) {
    const env = String.fromEnvironment('ENV');
    const baseUrl = String.fromEnvironment('API_BASE_URL');
    const logging = bool.fromEnvironment('ENABLE_LOGGING');

    final environment = Environment.parse(env, fallback: defaultEnvironment);
    return AppConfig(
      environment: environment,
      apiBaseUrl: baseUrl.isEmpty ? _defaultBaseUrl(environment) : baseUrl,
      // Compile-time constant: may legitimately equal the default.
      // ignore: avoid_redundant_argument_values
      enableLogging: logging,
    );
  }

  final Environment environment;
  final String apiBaseUrl;

  /// Extra opt-in logging flag. HTTP logging is additionally restricted to
  /// debug builds regardless of this value.
  final bool enableLogging;

  bool get isProd => environment == Environment.prod;

  static String _defaultBaseUrl(Environment env) => switch (env) {
    Environment.dev => 'https://api.dev.example.com',
    Environment.staging => 'https://api.staging.example.com',
    Environment.prod => 'https://api.example.com',
  };

  @override
  String toString() =>
      'AppConfig(environment: ${environment.name}, apiBaseUrl: $apiBaseUrl)';
}
