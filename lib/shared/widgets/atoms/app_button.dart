import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined }

/// Full-width Material 3 button with a built-in loading state.
///
/// While [isLoading] is true the button is disabled and shows a spinner.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final callback = isLoading ? null : onPressed;
    final child = isLoading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);

    return switch (variant) {
      AppButtonVariant.filled => FilledButton(
        onPressed: callback,
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: callback,
        child: child,
      ),
    };
  }
}
