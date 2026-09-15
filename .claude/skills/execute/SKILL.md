---
name: execute
description: Implement the steps in plan.md, run development checks, and maintain a short decision-level implementation trace. Invoked explicitly by the user.
---

# /execute

Answer the question: **build it as planned, and leave a readable record.**

## Inputs

- `.dev/tasks/<task>/plan.md` (required). Without it, ask whether to proceed from a
  user-provided plan or run `/plan` first. Do not run `/plan` yourself.
- `.dev/tasks/<task>/requirements.md`, `design.md` if present.
- `.dev/tasks/<task>/implementation-trace.md` if present (resume from the last step done).
- The user's current message: it may restrict execution to specific steps.

## Rules

- Follow the plan step by step. After each step, run its development check and fix
  compile or test failures before moving on.
- You may search, read, create and modify files, build, lint, run unit tests, and debug.
- A passing build or test is a development check, not requirement verification.
  Never claim a requirement is satisfied. Say what was checked.
- Do not refactor or improve code outside the plan's scope, even if tempting.
- For large codebases, delegate broad searches to a subagent and keep only conclusions.

## Plan Deviations

**Implementation-level** (different helper, file layout, minor API shape): continue,
and record it in the trace with the reason.

**Requirement- or constraint-level** (a requirement cannot be met, a constraint must be
broken, the architecture must change): STOP. Report:

```
PLAN DEVIATION
Planned: ...
Found: ...
Why it matters: ...
Options: ...
```

Wait for the user's decision. Never edit `requirements.md` yourself during execute.

## Implementation Trace

Maintain `.dev/tasks/<task>/implementation-trace.md`. One entry per meaningful change,
not per file or per command. Each entry at most about 10 lines; a normal task has
under 10 entries. This file is the learner's substitute for reading the raw diff.

```md
## 1. <What changed, as a short title>
Changed: one or two sentences.
Reason: why this way.
Files: path, path
Check: build passed | test_x passed | not yet checked
Deviation: (only if any)
```

Never record: shell commands, files read, searches, or your reasoning process.

## Finish

Report: steps completed, checks run and their results, deviations, and files touched.
State clearly that requirements are not yet verified. Then stop.
Do not run `/verify` or `/explain`. Mention that both are available.
