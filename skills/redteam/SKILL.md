---
name: redteam
description: Adversarial review of the current diff by one fresh-context reviewer agent (Sonnet). Pass `deep` as the first argument to run it on Opus for high-stakes changes.
argument-hint: "[deep] [base branch or focus]"
---
Run one `reviewer` subagent on the current changes. Arguments: `$ARGUMENTS`

- If the first argument is `deep`, pass `model: "opus"` to the agent; otherwise use its default (Sonnet).
- Pass any remaining argument as the base branch (if it names one) or as the focus area. Give the reviewer the task's goal in one or two sentences so it can judge intent, but not your opinion of the code.

When it returns, check each Blocker yourself against the code. Report the verdict, the blockers you confirmed, and which you dropped and why. When I invoked `/redteam` directly, do not apply fixes until I confirm; when it runs as a step of `/apex`, go straight on to `/apex`'s Resolve step.
