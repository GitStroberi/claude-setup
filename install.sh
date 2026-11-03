#!/usr/bin/env bash
# Installs the usage-aware Advisor/Executor/Explorer setup into ~/.claude
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
DST="$HOME/.claude"; TS=$(date +%Y%m%d-%H%M%S)
mkdir -p "$DST/agents" "$DST/skills/apex" "$DST/skills/redteam" "$DST/backups"
for f in CLAUDE.md agents/lookup.md agents/advisor.md agents/executor.md agents/reviewer.md skills/apex/SKILL.md skills/redteam/SKILL.md; do
  if [ -e "$DST/$f" ] && ! cmp -s "$SRC/$f" "$DST/$f"; then
    cp "$DST/$f" "$DST/backups/$(echo "$f" | tr / _).$TS.bak"; echo "backed up existing $f"
  fi
  cp "$SRC/$f" "$DST/$f"
done
S="$DST/settings.json"
[ -f "$S" ] || echo '{}' > "$S"
cp "$S" "$DST/backups/settings.json.$TS.bak"
# On Windows (Git Bash) python3 may be missing or the Microsoft Store stub; fall back to python.
PY_BIN=python3; "$PY_BIN" -c "" 2>/dev/null || PY_BIN=python
"$PY_BIN" - "$S" <<'PY'
import json,sys; p=sys.argv[1]; d=json.load(open(p)); d["model"]="opusplan"
json.dump(d,open(p,"w"),indent=2); print("settings.json: model=opusplan (other keys kept)")
PY
echo "Done. Start a new Claude Code session; /apex and /redteam should appear."
