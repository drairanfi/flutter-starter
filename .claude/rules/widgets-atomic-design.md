# Widgets and atomic design

`lib/shared/widgets/` holds feature-agnostic UI, imports only Flutter and `core/`:

| Level | Meaning | Existing |
| --- | --- | --- |
| `atoms/` | single control | `AppButton` |
| `molecules/` | atoms combined into a field/row | `LabeledTextField` |
| `organisms/` | page-level shells/sections | `AppScaffold` |

- Higher levels may use lower ones, never the reverse. Shared widgets take data and callbacks via
  constructor; no feature providers, no `ref` into features, no hard-coded copy (pass `label`).
- Feature-specific widgets stay in `features/<n>/presentation/widgets/` (e.g. `ThemeModeSelector`).
  Promote to `shared/` only when a second feature needs it.
- Pages use `AppScaffold`. They compose widgets and read providers; they hold no business rules.
- Prefer small `StatelessWidget` classes over helper methods that return widgets.
- `const` constructors and `const` instances wherever possible; `super.key` last, `required`
  params first (as in `AppButton`).
- Performance: keep `build` cheap, watch the narrowest provider (`ref.watch(p.select(...))`),
  use `ListView.builder` for long lists, never create controllers/futures inside `build`.
- Accessibility: tooltips on icon buttons, tap targets >= 48dp, text via theme so it scales.
- Every new shared widget gets a widget test in `test/shared/`.
