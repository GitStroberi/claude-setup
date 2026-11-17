# Global working rules

## Workflow
- Small and clear (1-2 files, obvious change): do it directly.
- Non-trivial: explore, plan (plan mode when there are design choices), implement, verify, review. Ask me only when a real design choice is open.
- Not done until checked by a test, build, typecheck or repro; report failures with their output. If there is no way to check the change, say so.
- Never weaken or delete tests to make them pass.
- Two-strike rule: if an approach fails verification twice, stop editing and re-examine the root cause before trying again.

## Delegation
- `lookup` (Haiku): wide find-and-report searches across many files or unknown locations. Do lookups with known targets inline. It locates; you interpret.
- `executor` (Sonnet): only for well-specified chunks that are independent of each other (can run in parallel) or bulky and mechanical, where the spec is much shorter than the code. Implement sequential, subtle or small changes yourself, since a handoff loses context. Never let two agents edit the same file.
- Review: before finishing a non-trivial change, run `/code-review low` (`medium` for risky changes); higher levels only when I ask. Check each finding against the code and drop any without a concrete failure scenario.

## Context
- One task per session; `/clear` between unrelated tasks.
