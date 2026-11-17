#!/usr/bin/env bash
# Installs the Opus-led Claude Code setup (global CLAUDE.md, lookup and executor agents) into ~/.claude
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
mkdir -p "$DST/agents" "$DST/backups"
backup() { cp "$DST/$1" "$DST/backups/$(echo "$1" | tr / _).$TS.bak"; }
for f in CLAUDE.md agents/lookup.md agents/executor.md; do
  if [ -e "$DST/$f" ] && ! cmp -s "$SRC/$f" "$DST/$f"; then
    backup "$f"; echo "backed up existing $f"
  fi
  cp "$SRC/$f" "$DST/$f"
done
# Files installed by earlier versions of this setup; /code-review replaces the reviewer and skills.
for f in agents/advisor.md agents/reviewer.md skills/apex/SKILL.md skills/redteam/SKILL.md; do
  if [ -e "$DST/$f" ]; then
    backup "$f"; rm "$DST/$f"; echo "removed old $f (backup in backups/)"
    rmdir "$(dirname "$DST/$f")" 2>/dev/null || true
  fi
done
S="$DST/settings.json"
[ -f "$S" ] || echo '{}' > "$S"
cp "$S" "$DST/backups/settings.json.$TS.bak"
"$PY_BIN" - "$S" <<'PY'
import json,sys; p=sys.argv[1]; d=json.load(open(p)); d["model"]="opus"
json.dump(d,open(p,"w"),indent=2); print("settings.json: model=opus (other keys kept)")
PY
echo "Done. Start a new Claude Code session to pick up the changes."
