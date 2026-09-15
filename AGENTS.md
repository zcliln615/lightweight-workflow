# Development Workflow

This project uses a lightweight, explicit, learning-oriented workflow.
Six skills exist: `/grill`, `/brainstorm`, `/plan`, `/execute`, `/verify`, `/explain`.

## Principles

1. **Explicit over Automatic.** A stage runs only when the user invokes it. Never start
   another stage on your own. Never treat an ordinary question as the start of a workflow.
2. **Artifacts over Context.** Persistent facts live in `.dev/tasks/<task>/`. Skills read
   artifacts plus the current user message. Never rely on "what was said 30 messages ago".
3. **Decision Trace over Tool Trace.** Record what changed, why, and the evidence.
   Never record shell commands, file reads, or reasoning steps.
4. **Complexity-Proportional Artifacts.** Produce only the files the task needs.
   A small fix needs `requirements.md` + `plan.md` + `implementation-trace.md`.

## Discipline

- **Evidence before Claims.** A passing build is not a verified requirement. Say
  "build passed", not "feature works", unless you have direct evidence.
- **No Silent Requirement Changes.** If reality conflicts with `requirements.md`, stop
  and ask. Implementation-level deviations may continue but must be recorded in the trace.
- **Encode gates, not procedures.** Skills state what must exist before moving on and
  what must never be crossed. They do not script how to think.

## Adaptive Depth

One workflow, two thinking depths. Default to **Bounded**: minimal questions, compact
design, few plan steps. Switch to **Deep** when any of these appear, regardless of line
count:

- new or changed public interfaces or data protocols
- responsibility changes across several modules
- concurrency, object lifetime, state machines
- persistence, migration, compatibility
- external devices or networks (cameras, Jetson, ESP32, sockets)
- performance or real-time constraints
- more than one approach with a real trade-off
- mistakes that would be hard to detect or hard to undo

Deep tasks resolve one material decision at a time and usually produce `design.md`.
If hidden complexity surfaces mid-stage, say so and escalate to Deep.

## Spec

`requirements.md` (what we promise) plus optional `design.md` (how the system works)
together form the Spec. `plan.md` is only the execution map for that Spec. There is no
separate `spec.md`.

## Task Directory

```
.dev/tasks/<task-name>/
  requirements.md            written by /grill, refined by /brainstorm
  design.md                  written by /brainstorm for Deep tasks, rarely otherwise
  plan.md                    written by /plan
  implementation-trace.md    maintained by /execute
  verification.md            optional, written by /verify on request
  learning.md                optional, written by /explain on request
```

Task resolution order, used by every skill:
1. Task named in the command (`/verify camera-sync`).
2. Task clearly established earlier in this conversation.
3. Exactly one plausible directory under `.dev/tasks/`.
4. Otherwise ask. Never guess by modification time.

Always state which task you are operating on in the first line of your reply.

## Learner Profile

The developer is learning modern C++ and software engineering, working mainly on
C/C++, embedded (ESP32, Jetson), OpenCV and computer vision projects.

Comfortable with: basic C/C++, common STL containers, OpenCV fundamentals, basic CMake.

Currently learning: RAII and ownership, smart pointers, concurrency, software
architecture, reading and reviewing code.

When explaining: prioritize business logic and design intent, explain non-obvious modern
C++ constructs, skip basic syntax unless asked, and point to a small number of code
locations worth studying.

## Out of Scope for This Workflow

No skill router, no automatic chaining, no mandatory TDD, worktrees, subagents, or code
review. These may be added later as optional capabilities, never as infrastructure.
