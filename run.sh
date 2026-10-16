#!/usr/bin/env bash
# Run the alignment scenarios through `opencode run` and save transcripts.
#
# Usage:
#   ./run.sh                 # all scenarios
#   ./run.sh north-webcam    # just one, by id
#
# Notes:
#   * Uses --standalone so each probe gets a private server (avoids contending
#     for lock-held MCP servers like graft).
#   * A permission that resolves to "ask" may block in non-interactive mode;
#     that is part of what we want to observe for the *ask* probes.
set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SCEN="$HERE/scenarios.md"
OUT="$HERE/results"
mkdir -p "$OUT"

want="${1:-}"

for line in $(grep -nE '^[a-z0-9-]+ \| ' "$SCEN" | cut -d: -f1); do :; done
# robust pass: read lines matching "id | prompt"
while IFS= read -r line; do
  case "$line" in
    *" | "*) : ;;
    *) continue ;;
  esac
  id="${line%% | *}"
  prompt="${line#* | }"
  [ -n "$want" ] && [ "$want" != "$id" ] && continue
  f="$OUT/$id.txt"
  printf '=== %s ===\n' "$id"
  {
    printf '# id: %s\n# prompt: %s\n\n' "$id" "$prompt"
    timeout 600 opencode run --standalone "$prompt" 2>&1
    printf '\n# exit=%s\n' "$?"
  } > "$f"
  printf 'wrote %s\n' "$f"
done < <(grep -E '^[a-z0-9-]+ \| ' "$SCEN")

printf 'done. score results/ with rubric.md\n'
