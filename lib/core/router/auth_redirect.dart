import 'package:flutter_template/core/router/app_routes.dart';

/// Pure redirect rules for the auth guard (easy to unit test).
///
/// * While the session is being restored -> `/splash`.
/// * Signed out and not on `/login` -> `/login`.
/// * Signed in and on `/login` or `/splash` -> `/`.
/// * Otherwise no redirect (`null`).
String? authRedirect({
  required bool isInitializing,
  required bool isSignedIn,
  required String location,
}) {
  if (isInitializing) {
    return location == AppRoutes.splash ? null : AppRoutes.splash;
  }
  if (!isSignedIn) {
    return location == AppRoutes.login ? null : AppRoutes.login;
  }
  if (location == AppRoutes.login || location == AppRoutes.splash) {
    return AppRoutes.home;
  }
  return null;
}
