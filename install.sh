#!/usr/bin/env bash
# Installs the usage-aware Advisor/Executor/Explorer setup into ~/.claude
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
DST="$HOME/.claude"; TS=$(date +%Y%m%d-%H%M%S)
# Find a working Python before touching anything. On Windows, python3/python may be the
# Microsoft Store stub, which exits non-zero instead of running code.
PY_BIN=""
for c in python3 python py; do
  if "$c" -c "import json" >/dev/null 2>&1; then PY_BIN=$c; break; fi
done
if [ -z "$PY_BIN" ]; then
  echo "error: no working Python 3 found (tried python3, python, py); nothing was changed." >&2
  echo "On Windows, install Python from python.org and disable the Store app execution aliases." >&2
  exit 1
fi
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
"$PY_BIN" - "$S" <<'PY'
import json,sys; p=sys.argv[1]; d=json.load(open(p)); d["model"]="opusplan"
json.dump(d,open(p,"w"),indent=2); print("settings.json: model=opusplan (other keys kept)")
PY
echo "Done. Start a new Claude Code session; /apex and /redteam should appear."
