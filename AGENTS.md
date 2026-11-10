# AGENTS.md

Entry point for AI coding agents (Claude Code, OpenCode, others) and humans.
Flutter template: Riverpod 3 (codegen), freezed, go_router, dio, Screaming + Clean
feature-first architecture, native flavors `dev` / `staging` / `prod`.
Human docs: `README.md`. Quick card: `RULES.md`.

## Read first

`.claude/knowledge/critical-constraints.md` (hard rules). Then `architecture.md`, `tech-stack.md`
(same folder) and only the `.claude/rules/*` files relevant to the task.

## Clarify before building

If the business domain or requirements are missing or ambiguous, STOP and ask (one question at a
time; use the `grill-me` skill). Do not invent entities, screens or API contracts.

## Commands

```sh
flutter pub get
dart run build_runner build          # codegen (watch: build_runner watch)
flutter gen-l10n
dart format .
flutter analyze                      # zero issues
flutter test
flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=config/dev.json
```

Flavors: always pass `--flavor <env> -t lib/main_<env>.dart --dart-define-from-file=config/<env>.json`
for the same env (details in `.claude/rules/flavors-and-config.md` and README). Base ids are single
constants (`baseApplicationId` in `android/app/build.gradle.kts`, `APP_BUNDLE_ID_BASE` in
`ios/Flutter/Base.xcconfig`); do not hand-edit bundle ids in `project.pbxproj`.

## Harness map

| Kind | Name | Purpose |
| --- | --- | --- |
| Agent | `feature-architect` | Plans a feature, writes `.claude/plans/<feature>.md` |
| Agent | `flutter-builder` | Implements following the plan and rules |
| Agent | `code-reviewer` | Read-only audit against the rules |
| Agent | `doc-gardener` | Syncs README / AGENTS.md / rules with the code |
| Agent | `ux-ui-designer` | Material 3, tokens, accessibility guidance |
| Command | `/new-feature <name>` | Scaffold a full feature |
| Command | `/figma-to-flutter <url>` | Figma MCP to tokens + existing widgets |
| Command | `/verify` | Codegen, l10n, format, analyze, test |
| Skill | `riverpod`, `freezed-models`, `go-router`, `flutter-widgets`, `flutter-testing` | Task checklists |
| Skill | `commit-conventions`, `naming-language`, `grill-me` | Process and language |
| Rules | `.claude/rules/*.md` | folder-structure, naming-conventions, riverpod, models-and-freezed, routing, networking-and-errors, theming-and-design-tokens, l10n, forms, widgets-atomic-design, testing, flavors-and-config, code-quality |
| Knowledge | `.claude/knowledge/*.md` | critical-constraints, architecture, tech-stack |

## Workflow

1. Architect writes a plan to `.claude/plans/` (needs clear requirements).
2. Builder implements the plan, then runs the verify pipeline.
3. Reviewer audits the diff against the rules; fix blockers.
4. Never commit or push unless the user asks. Commits are Conventional Commits, no AI attribution.

## Pre-work checklist

- [ ] Requirements and business domain are clear
- [ ] Read critical constraints and the relevant rules
- [ ] Looked at the closest existing feature (`lib/features/auth`) before writing new code

## Pre-finish checklist

- [ ] `dart run build_runner build` and `flutter gen-l10n` ran
- [ ] `dart format --set-exit-if-changed .` clean
- [ ] `flutter analyze` zero issues; `flutter test` green
- [ ] Tests added for notifiers, guards, mappers, shared widgets
- [ ] ARB keys in en and es; no hard-coded strings or colors
- [ ] No generated, secret or unrelated files changed

## Tool notes

- `.claude/` is the single source of truth. Claude Code reads it directly; `CLAUDE.md` just imports
  this file. OpenCode reads `AGENTS.md`, `opencode.json` (instructions, MCP, permissions),
  `.claude/skills` natively, `.opencode/commands` (symlink to `.claude/commands`) and
  `.opencode/agents` (generated: `sh scripts/sync_opencode_agents.sh` after editing `.claude/agents`).
- MCP: Dart/Flutter MCP server (`dart mcp-server`) and Figma Desktop (`http://127.0.0.1:3845/mcp`),
  declared in `.mcp.json` (Claude Code) and `opencode.json` (OpenCode).
- Claude Code formats `.dart` after edits via `.claude/hooks/format-dart.sh`; OpenCode uses its built-in `dart` formatter.
