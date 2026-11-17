# claude-setup

A small Claude Code setup: Opus runs the session and makes the decisions, Sonnet implements well-scoped chunks, Haiku does wide searches, and the built-in `/code-review` checks changes.

It follows the points most guidance agrees on (Anthropic's best practices, the Claude Code team's own workflow, practitioner reports). Verify every change, plan non-trivial work, and keep context clean. Use subagents only for searching, independent work and review. Keep instructions short.

## What's inside

| File | Purpose |
|---|---|
| `CLAUDE.md` | Global rules: workflow, verification, delegation, review, context (about 20 lines) |
| `agents/lookup.md` | Read-only find-and-report agent (Haiku) |
| `agents/executor.md` | Implements one well-specified, independent or bulky chunk (Sonnet) |
| `install.sh` | Copies the files into `~/.claude` and sets the model to Opus |

## Install

Linux / macOS:

```bash
git clone https://github.com/GitStroberi/claude-setup.git && ./claude-setup/install.sh
```

Windows: run the same command in Git Bash. It needs a real Python 3 on PATH as `python3`, `python` or `py`. If the only `python` on PATH is the Microsoft Store stub, install Python from python.org and turn off the `python.exe` / `python3.exe` App execution aliases (Settings → Apps → Advanced app settings → App execution aliases). If no working Python is found, the installer stops before changing anything.

The installer:
- copies the files into `~/.claude`, backing up anything it would overwrite to `~/.claude/backups/`;
- removes files left by earlier versions of this setup (`advisor` and `reviewer` agents, `/apex` and `/redteam` skills), after backing them up;
- sets `"model": "opus"` in `~/.claude/settings.json` and keeps the other keys.

Start a new Claude Code session afterwards. To update, `git pull` and run `./install.sh` again.

## Per-project checks (optional)

Rules that must always hold belong in hooks, not in `CLAUDE.md`. Test and lint commands differ per project, so this setup doesn't install a global hook. To make Claude run a project's fast checks before it finishes, add a Stop hook to that project's `.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "npm run lint && npm test --silent || { echo 'Checks failed; fix them before finishing.' >&2; exit 2; }" }
        ]
      }
    ]
  }
}
```

Exit code 2 sends the message back to Claude and keeps it working. Replace the command with the project's own checks and keep them fast, because the hook runs every time Claude stops. Check the Claude Code hooks documentation for the current input fields, such as the flag that prevents a hook from looping.

## Notes

- Don't run this alongside workflow plugins that impose their own process, such as Superpowers. Their rules conflict with the ones here.
- `/code-review` runs at `low` or `medium` by default. Its `max` and `ultra` levels start many reviewer agents, so use them only when you need them.
