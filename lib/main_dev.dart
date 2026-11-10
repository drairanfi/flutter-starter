import 'package:flutter_template/core/config/app_config.dart';
import 'package:flutter_template/core/config/bootstrap.dart';

Future<void> main() =>
    bootstrap(AppConfig.fromEnvironment(defaultEnvironment: Environment.dev));
