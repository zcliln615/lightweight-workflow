---
name: grill
description: Clarify a requirement by asking only the questions that materially affect design or implementation, then write requirements.md. Invoked explicitly by the user.
---

# /grill

Answer the question: **what exactly are we building, and how will we know it is done?**

## Entry

Classify the command argument by its first whitespace-separated token, before anything
else:

1. Empty: refine the active task (AGENTS.md Task resolution). None active: ask the user
   to state the requirement with `/grill new ...`.
2. First token exactly matches an existing `.dev/tasks/` directory name: operate on that
   task; the rest is new input (an extension or clarification). Write `.dev/active-task`.
3. First token is `new`: the rest is the requirement statement for a new task. Run the
   Boundary Round below. Write nothing until the user confirms.
4. Anything else: input for the active task, as in 1.

## Boundary Round (`new` only)

Check, from artifacts only:
- Overlap: does the statement fall inside an existing task's Requirements? Say so and
  ask whether to create anyway or extend that task. Does an existing Non-goals contain a
  pointer such as "separate task: udp-protocol"? Reuse that name.
- Split: more than one independently verifiable deliverable? Propose one line per task
  with name and boundary; the user picks one. The others become Out pointers in the
  chosen task's Non-goals only; never create their directories.

Then propose and wait:

```
Task: <name> (proposed)
Goal: one sentence
In: ...
Out: ...
Overlap: (only if any)
Questions: (first round, each with a default)
```

"ok" or "defaults" accepts everything; the user may edit any line. The user owns the
boundary; you only surface evidence. After confirmation: create the directory, write
`.dev/active-task`, write the requirements.md draft with Goal and Non-goals from the
boundary, and reply with `Task: <name> (created)`.

## Naming

- kebab-case ASCII, 2 to 4 words, even when the requirement is written in Chinese.
- Name the subject that changes: component, capability, protocol. Not the symptom, not
  the stage. A verb prefix only when the verb is the point (`fix-`, `migrate-`).
- If the best name matches an existing directory, say so: the request may belong there.
  Never append a suffix to disambiguate.
- Frozen once `plan.md` exists. Before that, rename on request by moving the directory
  and updating `.dev/active-task`.

## Inputs

- The requirement statement from the Entry rules above.
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

Write `.dev/tasks/<task-name>/requirements.md`. Write a draft after the first round
(for `new`, after the Boundary Round is confirmed) and refine it each round.

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
