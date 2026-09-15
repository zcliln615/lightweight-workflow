---
name: explain
description: Act as a code tutor for the learner. Explain the business logic, data flow, key interfaces and non-obvious techniques of a task or a specified scope, guided by the Learner Profile. Invoked explicitly by the user.
---

# /explain

Answer the question: **as a learner, what should I understand about this code, and in what order?**

## Inputs

- The Learner Profile in AGENTS.md. It decides what to explain and what to skip.
- The user's current message. It sets the scope:
  - `/explain` : the whole task, top-down.
  - `/explain <file or function>` : that code only.
  - `/explain <question>` : answer that question only.
  - `/explain <topic>` such as "only the threading" : that aspect only.
- `.dev/tasks/<task>/requirements.md`, `design.md`, `plan.md`, `implementation-trace.md`
  if present, plus the relevant source.

## Rules

- Teach, do not narrate the diff. Never explain line by line unless asked.
- Default order of priority: business logic, then data flow, then key interfaces, then
  key implementation techniques, then the C++ or system knowledge they depend on.
- Choose a small number of code locations worth reading, cited as `file:line`.
  Say explicitly which parts are boilerplate the learner can ignore for now.
- Explain the "why" behind design decisions, using the trace and design as sources.
- Match the Learner Profile: skip basic syntax; explain ownership, concurrency,
  RAII, and non-obvious modern C++ when they appear.
- Point out code that is easy to get wrong and what the failure would look like.
- Keep it to what the scope asks. A narrow question gets a narrow answer.

## Default Output for `/explain` with no scope

```
1. What the feature does, in plain terms
2. Data flow, as a short diagram
3. The 3 to 6 code locations that matter, in reading order, with why each matters
4. Key techniques used and why they were chosen
5. Concepts worth studying further, one line each
6. What you can safely skip
```

Write `.dev/tasks/<task>/learning.md` only when the user asks to keep the material.

## Finish

Offer one or two natural follow-up questions the learner might ask next. Then stop.
Do not start any other stage.
