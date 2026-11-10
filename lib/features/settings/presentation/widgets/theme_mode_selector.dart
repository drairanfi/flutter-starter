import 'package:flutter/material.dart';
import 'package:flutter_template/core/l10n/l10n.dart';

/// Segmented control for choosing the [ThemeMode].
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ThemeMode selected;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem)),
        ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight)),
        ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
      ],
      selected: {selected},
      onSelectionChanged: (set) => onChanged(set.first),
    );
  }
}
