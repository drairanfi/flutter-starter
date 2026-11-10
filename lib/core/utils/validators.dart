/// Pure form validators. They return an error *code* so the UI can localise.
enum ValidationError { emailRequired, emailInvalid, passwordRequired }

abstract final class Validators {
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static ValidationError? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return ValidationError.emailRequired;
    if (!_email.hasMatch(v)) return ValidationError.emailInvalid;
    return null;
  }

  static ValidationError? password(String? value) =>
      (value == null || value.isEmpty)
      ? ValidationError.passwordRequired
      : null;
}
