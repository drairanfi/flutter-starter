# RULES.md - quick reference

Works for Claude Code and OpenCode. Full text: `.claude/knowledge/critical-constraints.md` and `.claude/rules/*`.

| Topic | Rule | Details |
| --- | --- | --- |
| Layers | `presentation -> domain <- data`, all use `core/`; no cross-feature imports | `folder-structure.md` |
| Logic | None in widgets; notifiers call repositories | `riverpod.md` |
| Providers | Codegen only; `watch` in build, `read` in callbacks | `riverpod.md` |
| Models | freezed, immutable, never edit generated files | `models-and-freezed.md` |
| Routes | `AppRoutes` constants, guard is pure `authRedirect` | `routing.md` |
| Errors | Repos throw `Failure`; UI uses `localizeError` | `networking-and-errors.md` |
| Theme | `Theme.of(context)`; no raw colors/sizes | `theming-and-design-tokens.md` |
| Strings | ARB en + es, `context.l10n` | `l10n.md` |
| Forms | `Form` + `Validators` codes + `AppButton(isLoading)` | `forms.md` |
| Widgets | atoms -> molecules -> organisms in `shared/widgets` | `widgets-atomic-design.md` |
| Tests | mocktail + provider overrides; notifiers, guards, mappers | `testing.md` |
| Flavors | `--flavor X -t lib/main_X.dart --dart-define-from-file=config/X.json` | `flavors-and-config.md` |
| Quality | very_good_analysis clean, `const`, no `print` | `code-quality.md` |
| Naming | English identifiers, `snake_case` files | `naming-conventions.md` |
| Secrets | Never read/edit `.env*`, keystores, `google-services.json`, plists | critical constraints |
| Git | Conventional Commits, no AI attribution, commit only when asked | `commit-conventions` skill |

Done = `dart run build_runner build`, `flutter gen-l10n`, `dart format .`, `flutter analyze`, `flutter test` (or `/verify`).
