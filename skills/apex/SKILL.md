---
name: apex
description: Explore -> plan (Opus) -> implement (Sonnet) -> verify -> one adversarial review, for a non-trivial task, using the usage-aware roles from the global CLAUDE.md.
argument-hint: "[task description]"
---
Task: $ARGUMENTS

1. **Recon:** if the relevant files are unknown, send one `lookup` agent (or a few in parallel for independent areas) for file:line locations, conventions and test commands. Skip this if you already know where to work.
2. **Plan:** enter plan mode (Opus under `opusplan`) and write a short plan: scope and non-goals, files and changes, edge cases, and the exact check that proves it works. Ask me only if a real design choice is open.
3. **Implement** in this session after leaving plan mode (Sonnet). Use `executor` agents only for pieces that are independent and can run in parallel.
4. **Verify** with the check from the plan. Two-strike rule: after two failed attempts, stop and consult `advisor` with a compact brief.
5. **Review:** run `/redteam`. Use `/redteam deep` only for high-stakes changes (security, data loss, numerical core).
6. **Resolve:** fix confirmed blockers, re-verify, and re-review at most once. Then give me a short summary: what changed, what was checked, what is still open.
