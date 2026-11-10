---
description: Implement a Figma design in Flutter using the Figma MCP, mapped to existing tokens and widgets. Usage - /figma-to-flutter <figma_url>
argument-hint: <figma_url>
---

Implement the Figma node `$ARGUMENTS` in Flutter.

1. The Figma MCP server (`figma` in `.mcp.json`, Figma Desktop at `http://127.0.0.1:3845/mcp`) must be running. Fetch the design context, a screenshot and variables for the node. If it is unreachable, say so and stop.
2. Inventory what exists: `lib/shared/widgets/{atoms,molecules,organisms}`, `lib/core/theme/app_theme.dart`. Reuse before creating.
3. Map the design, do not copy generated web/React output:
   - Colors -> `Theme.of(context).colorScheme` roles; text -> `textTheme` roles. No `Color(...)`, no raw font sizes. If a needed token is missing, add it to `AppTheme` (light and dark) and say so.
   - Spacing -> multiples of 4 already used in the code; radii/sizes via component themes.
   - Components -> existing atoms/molecules/organisms; new reusable pieces go to `shared/widgets` at the right level, feature-only pieces to the feature's `presentation/widgets`.
   - Every string -> ARB key in both `app_en.arb` and `app_es.arb`, then `flutter gen-l10n`.
   - Icons -> Material `Icons.*`; localised tooltips on icon buttons.
4. Cover loading/empty/error states and light/dark; responsive width.
5. No business logic in widgets; wire to notifiers.
6. Run `dart format .`, `flutter analyze`, `flutter test`. Add widget tests for new shared widgets.
7. Report: tokens mapped, tokens added, widgets reused/created, deviations from the design.
