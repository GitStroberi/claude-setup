# Global working rules

## Roles and models (usage-aware)
- Main session runs `opusplan`: Opus while in plan mode (the Advisor), Sonnet otherwise (the Executor). Plan non-trivial changes in plan mode, then leave it to implement.
- Explorer = `lookup` agent (Haiku). Delegate multi-file sweeps to it; do small lookups with known targets inline. Ask for file:line and short facts, never file dumps.
- `advisor` agent (Opus) is escalation only: after two failed attempts, or for a design decision with real trade-offs that comes up mid-implementation. Send a compact brief (goal, what was tried, exact error, relevant file:line), not the conversation. At most one or two calls per task.
- `executor` agent (Sonnet) only for independent chunks that can run in parallel; otherwise implement in the main session, since a handoff loses detail.
- Review: one `reviewer` agent (Sonnet, fresh context) via `/redteam`; `/redteam deep` uses Opus. One reviewer per diff, never a fan-out. Check each blocker against the code before fixing; drop any without a concrete failure scenario.

## Triage
- Small and clear (1-2 files): do it directly, no agents.
- Larger: plan mode -> implement -> verify -> `/redteam`. `/apex` runs this end to end.

## Verification and loop control
- Not done until checked by a test, build, typecheck or repro; report failures with their output.
- Never weaken or delete tests to make them pass.
- Two-strike rule: if an approach fails verification twice, stop editing, re-examine the root cause, or consult `advisor`.

## Usage hygiene
- One session per task; `/clear` or start fresh between unrelated tasks. Long sessions re-send the whole context every turn.
