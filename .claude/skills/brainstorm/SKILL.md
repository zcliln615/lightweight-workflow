---
name: brainstorm
description: Explore architecture and implementation approaches for a task before any code is written, converging on a recommended design. Invoked explicitly by the user.
---

# /brainstorm

Answer the question: **how might we build this, and which way is best?**

## Inputs

- `.dev/tasks/<task>/requirements.md`. If missing, ask whether to run `/grill` first or
  proceed from the user's description. Do not run `/grill` yourself.
- Relevant existing code: interfaces, data structures, threading, build setup.
- The user's current message, which may narrow the discussion.

## Rules

- No source code changes. Small illustrative snippets in chat are fine.
- Think about alternatives, but only present multiple options when a real trade-off
  exists. If one approach is clearly better, recommend it and say why in a few lines.
- Cover what matters for this task, not a fixed checklist. Typical topics: architecture,
  data flow, threading and ownership, interfaces, error handling, risks, effort.
- Prefer the smallest design that satisfies the requirements and constraints.
- If a requirement gap surfaces, ask the user one focused question, then update
  `requirements.md`. Do not reopen a full grill.
- One topic at a time. Do not produce a wall of text covering everything at once.

## Output

Depth follows Adaptive Depth in AGENTS.md.

**Bounded** tasks: converge on a recommended design and state it compactly. No file.
`/plan` will carry it as the Design Summary.

```
Recommended design
- Approach: ...
- Why: ...
- Files involved: ...
- Risks: ...
```

**Deep** tasks: resolve the decisions below that apply, one at a time, then write
`.dev/tasks/<task>/design.md`. Skip sections that are irrelevant; do not fill a template.

```
# Design: <Task Name>
## Chosen approach
## Component boundaries
## Data and state ownership
## Important interfaces
## Failure behavior
## Concurrency and lifecycle          (if relevant)
## External boundaries                (devices, protocols, if relevant)
## Verification strategy
## Rejected alternatives              (only those seriously considered)
```

## Done Criteria

Brainstorm is done when the chosen approach is stated, every design decision that
`/plan` would otherwise have to invent is settled, and `requirements.md` reflects any
requirement facts discovered along the way. Deep tasks are not done without `design.md`.

## Finish

State the recommended design and any requirement updates made. Then stop.
Do not write `plan.md` and do not start `/plan`.
