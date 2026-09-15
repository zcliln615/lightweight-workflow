---
name: grill
description: Clarify a requirement by asking only the questions that materially affect design or implementation, then write requirements.md. Invoked explicitly by the user.
---

# /grill

Answer the question: **what exactly are we building, and how will we know it is done?**

## Inputs

- The user's requirement statement (current message or the task named in the command).
- Existing `.dev/tasks/<task>/requirements.md` if present (resume, do not restart).
- Relevant code only when needed to know what already exists.

## Rules

- Do not discuss implementation approaches. That is `/brainstorm`.
- Ask only questions whose answer would change the design, scope, or acceptance criteria.
  Skip anything you can reasonably infer or that does not matter yet.
- Minimum sufficient questioning, per Adaptive Depth in AGENTS.md:
  - **Bounded**: zero to a few high-impact questions. Batch them when independent.
    Offer a sensible default for each so the user can answer "defaults".
  - **Deep**: resolve one material decision at a time, because later questions often
    depend on earlier answers. Follow dependent branches until the requirement is stable.
  - Escalate to Deep if hidden complexity appears; say so when you do.
- Every acceptance criterion must state how it will be verified and whether the agent can
  verify it in this environment. This is what makes `/verify` mechanical later.

## Ready Criteria

Grill is done only when all of these hold. Otherwise keep going or report what blocks.

- Goal, scope, constraints, non-goals are clear.
- Every ambiguity that would change the design is resolved.
- Every acceptance criterion is observable and has a verification method.
- No blocking open questions remain. Non-blocking ones go under Open Questions.

## Output

Write `.dev/tasks/<task-name>/requirements.md`. Propose a short kebab-case task name if
the user did not give one. Write a draft after the first round and refine it each round.

```md
# <Task Name>

## Goal
One or two sentences.

## Requirements
Numbered, stable, testable statements.

## Constraints
Platform, performance, existing APIs that must not change, dependencies, style.

## Non-goals
What this task deliberately does not do.

## Edge Cases
Failure modes and boundary conditions that the implementation must handle.

## Acceptance Criteria

### AC-01
Requirement: ...
Expected verification: unit test | simulated data | static inspection | hardware test | manual
Environment: host PC | Jetson | ESP32 | ...
Agent-verifiable: Yes | No (reason)

## Open Questions
Remaining ambiguities that do not block design.
```

## Finish

Summarize the requirement in 3 to 5 lines and name the file written. Then stop.
Do not start `/brainstorm` or `/plan`. Mention that they are available if useful.
