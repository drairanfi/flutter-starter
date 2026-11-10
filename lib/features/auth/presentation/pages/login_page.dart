import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/l10n/l10n.dart';
import 'package:flutter_template/core/utils/validators.dart';
import 'package:flutter_template/features/auth/presentation/providers/auth_controller.dart';
import 'package:flutter_template/shared/widgets/atoms/app_button.dart';
import 'package:flutter_template/shared/widgets/molecules/labeled_text_field.dart';
import 'package:flutter_template/shared/widgets/organisms/app_scaffold.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authControllerProvider.notifier)
        .signIn(email: _email.text.trim(), password: _password.text);
  }

  String? _emailError(String? value) {
    final l10n = context.l10n;
    return switch (Validators.email(value)) {
      ValidationError.emailRequired => l10n.validationEmailRequired,
      ValidationError.emailInvalid => l10n.validationEmailInvalid,
      _ => null,
    };
  }

  String? _passwordError(String? value) => Validators.password(value) == null
      ? null
      : context.l10n.validationPasswordRequired;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final auth = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    return AppScaffold(
      title: l10n.signIn,
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(l10n.loginTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(l10n.loginSubtitle, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            LabeledTextField(
              label: l10n.emailLabel,
              controller: _email,
              validator: _emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: l10n.passwordLabel,
              controller: _password,
              validator: _passwordError,
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _submit(),
            ),
            if (auth.hasError) ...[
              const SizedBox(height: 16),
              Text(
                localizeError(auth.error!, l10n),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            AppButton(
              label: l10n.signIn,
              isLoading: auth.isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 16),
            Text(l10n.loginHint, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
