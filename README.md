# claude-setup

A usage-aware Claude Code setup: Opus plans, Sonnet implements, Haiku searches, and one fresh-context reviewer checks the diff.

## What's inside

| File | Purpose |
|---|---|
| `CLAUDE.md` | Global rules: roles and models, triage, verification, two-strike rule |
| `agents/lookup.md` | Read-only search agent (Haiku) |
| `agents/advisor.md` | Escalation-only design advisor (Opus) |
| `agents/executor.md` | Bounded parallel implementer (Sonnet) |
| `agents/reviewer.md` | Adversarial diff reviewer (Sonnet; Opus with `/redteam deep`) |
| `skills/apex` | `/apex <task>`: recon -> plan -> implement -> verify -> review |
| `skills/redteam` | `/redteam [deep] [base or focus]`: one adversarial review |

## Install

Linux / macOS:

```bash
git clone https://github.com/GitStroberi/claude-setup.git && ./claude-setup/install.sh
```

Windows: run the same command in Git Bash. It needs a real Python 3 on PATH as `python3`, `python` or `py`. If the only `python` on PATH is the Microsoft Store stub, install Python from python.org and turn off the `python.exe` / `python3.exe` App execution aliases (Settings → Apps → Advanced app settings → App execution aliases). If no working Python is found, the installer stops before changing anything.

The installer copies the files into `~/.claude` and backs up anything it would overwrite to `~/.claude/backups/`. It also sets `"model": "opusplan"` in `~/.claude/settings.json` and keeps the other keys. Start a new Claude Code session afterwards.

## Notes

- Don't run this next to workflow plugins that impose their own process, such as Superpowers. Their rules conflict with the triage here.
- `/redteam` reads `git diff`. Outside a git repo, name the files to review.
