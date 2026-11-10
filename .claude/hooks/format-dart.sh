#!/bin/sh
# PostToolUse hook: formats the edited .dart file with `dart format`.
# Reads the hook JSON from stdin. Never blocks: always exits 0.

input=$(cat 2>/dev/null) || input=""
[ -n "$input" ] || exit 0

if command -v jq >/dev/null 2>&1; then
  file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || file=""
else
  file=$(printf '%s' "$input" |
    sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' |
    head -n 1)
fi
[ -n "$file" ] || exit 0

case "$file" in
  *.dart) ;;
  *) exit 0 ;;
esac

root=${CLAUDE_PROJECT_DIR:-$(pwd)}
root=$(cd "$root" 2>/dev/null && pwd -P) || exit 0

case "$file" in
  /*) ;;
  *) file="$root/$file" ;;
esac

# Only files inside the project; refuse path traversal.
case "$file" in
  *"/../"*) exit 0 ;;
  "$root"/*) ;;
  *) exit 0 ;;
esac

# Skip generated code.
case "$file" in
  *.g.dart | *.freezed.dart | */lib/core/l10n/generated/*) exit 0 ;;
esac

[ -f "$file" ] || exit 0
command -v dart >/dev/null 2>&1 || exit 0

(cd "$root" && dart format "$file" >/dev/null 2>&1) || true
exit 0
