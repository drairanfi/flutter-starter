---
name: naming-language
description: Use when naming files, classes, providers, ARB keys or routes, and when the business domain is described in another language (identifiers stay English).
---

Read `.claude/rules/naming-conventions.md`.

1. Everything in code is English: identifiers, comments, docs, commit messages. If the domain vocabulary is Spanish (or other), translate to a stable English term and note it in the plan; keep the original only in ARB values.
2. Files `snake_case.dart`; types `UpperCamelCase`; members `lowerCamelCase`.
3. `FooRepository` (interface), `<Kind>FooRepository` (impl), `FooController` (notifier), `FooPage` (route), `FooFailure`.
4. ARB keys: `lowerCamelCase` with area prefix (`loginTitle`, `errorNetwork`).
5. Booleans read as questions (`isLoading`).
