---
name: plan
description: Turn an agreed design into a concrete, step-by-step implementation plan written to plan.md. Invoked explicitly by the user.
---

# /plan

Answer the question: **now that we know how, what exactly will be done, in what order?**

## Inputs

- `.dev/tasks/<task>/requirements.md` (required; if missing, ask how to proceed).
- `.dev/tasks/<task>/design.md` if present, or the design agreed in this conversation,
  or the user's current message for a simple task that skipped `/brainstorm`.
- Relevant code, enough to name real files and functions.

## Rules

- Steps must be small enough that each can be built and checked independently.
  A step that touches more than a few files is probably two steps.
- Name actual files and functions. Do not write "update the relevant modules".
- Every step lists its development check: build, a specific test, or a manual run.
- Include a Design Summary of 5 to 15 lines. Write a separate `design.md` only when the
  design has several non-obvious decisions or trade-offs that need their own explanation.
- Do not restate requirements. Reference them by AC id where relevant.
- Do not plan work outside the requirements. Put temptations under Out of Scope.

## Output

Write `.dev/tasks/<task>/plan.md`:

```md
# Plan: <Task Name>

## Goal
One sentence, linking to requirements.md.

## Design Summary
Architecture, data flow, key decisions. Or: "See design.md."

## Scope
## Out of Scope

## Steps

### Step 1: <title>
Files: ...
Change: what to add or modify, concretely.
Check: build | test name | manual command.
Covers: AC-xx

### Step 2: ...

## Expected Files
New and modified files, one line each.

## Development Checks
Build command, test command, lint if any.

## Risks
Where this could go wrong and what to watch for during /execute.
```

## Finish

Report the number of steps and the file written. Then stop.
Do not begin implementation. `/execute` is the user's decision.
