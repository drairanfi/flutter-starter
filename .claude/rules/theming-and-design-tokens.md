# Theming and design tokens

Tokens today: the Material 3 theme in `lib/core/theme/app_theme.dart`
(`ColorScheme.fromSeed`, input/button themes) and the user-selected `ThemeMode`
(`themeModeControllerProvider`). There is **no** spacing/radius token file yet.

- Colors: `Theme.of(context).colorScheme.*` (`primary`, `error`, `surface`, ...). No `Color(0x...)`
  or `Colors.*` in features or shared widgets. Only `AppTheme` defines the seed.
- Typography: `Theme.of(context).textTheme.*` (`headlineMedium`, `bodyLarge`, ...). Do not set raw
  `fontSize` / `fontFamily`.
- Component look (shapes, sizes, borders) goes into a component theme in `AppTheme._build`, not
  repeated per widget. Both light and dark come from the same builder.
- Spacing: existing code uses multiples of 4 (4, 8, 12, 16, 24, 32) as literals with `const SizedBox`
  / `EdgeInsets`. Stay on that scale. If a value repeats across screens, propose a spacing token
  in `core/theme/` before spreading it.
- Never branch on `Brightness` in widgets; the scheme already adapts.
- Use `Icons.*` from Material; give icon-only buttons a localized `tooltip`.
- To add a theme value: edit `AppTheme`, verify light and dark, and update this file.
