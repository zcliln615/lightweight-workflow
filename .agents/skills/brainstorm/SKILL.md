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

Converge on a recommended design and state it compactly:

```
Recommended design
- Architecture: ...
- Data flow: ...
- Key interfaces: ...
- Key decisions and why: ...
- Risks: ...
- Rejected alternatives (only if considered seriously): ...
```

No file is required. Only if the design is architecture-heavy and will need to be
understood independently later, offer to write `.dev/tasks/<task>/design.md` with those
same sections. Otherwise `/plan` will carry a Design Summary.

## Finish

State the recommended design and any requirement updates made. Then stop.
Do not write `plan.md` and do not start `/plan`.
