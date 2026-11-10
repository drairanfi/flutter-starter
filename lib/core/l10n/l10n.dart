import 'package:flutter/widgets.dart';
import 'package:flutter_template/core/error/failure.dart';
import 'package:flutter_template/core/l10n/generated/app_localizations.dart';

export 'package:flutter_template/core/l10n/generated/app_localizations.dart';

/// Convenient access: `context.l10n.signIn`.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Maps a [Failure] to a user-facing, localised message.
extension FailureL10n on Failure {
  String localize(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.errorNetwork,
    TimeoutFailure() => l10n.errorTimeout,
    UnauthorizedFailure() => l10n.errorUnauthorized,
    InvalidCredentialsFailure() => l10n.errorInvalidCredentials,
    NotFoundFailure() => l10n.errorNotFound,
    ServerFailure() => l10n.errorServer,
    UnknownFailure() => l10n.errorGeneric,
  };
}

/// Localises any error object, falling back to the generic message.
String localizeError(Object error, AppLocalizations l10n) =>
    error is Failure ? error.localize(l10n) : l10n.errorGeneric;
