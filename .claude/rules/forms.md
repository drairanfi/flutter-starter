# Forms

Pattern (see `lib/features/auth/presentation/pages/login_page.dart`):

- `ConsumerStatefulWidget` with `GlobalKey<FormState>` and one `TextEditingController` per field,
  all disposed in `dispose()`.
- Fields: `LabeledTextField` (`shared/widgets/molecules`), wrapped in a `Form`.
- Validation: pure functions in `core/utils/validators.dart` returning a `ValidationError` code
  (null = valid). The page maps codes to ARB strings. Add new codes to the enum and map them.
- Submit:

```dart
Future<void> _submit() async {
  if (!(_formKey.currentState?.validate() ?? false)) return;
  await ref.read(fooControllerProvider.notifier).save(name: _name.text.trim());
}
```

- Business validation and the request live in the notifier/repository, not in the widget.
- Loading: bind `AppButton(isLoading: state.isLoading)`; it disables itself. Errors:
  `state.hasError` -> `localizeError(state.error!, l10n)`.
- Set `keyboardType`, `textInputAction`, `autofillHints`; `onFieldSubmitted` triggers submit.
- Never keep form values in a provider unless another screen needs them.
