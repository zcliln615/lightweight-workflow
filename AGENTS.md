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
.dev/active-task             one line, the task unnamed work binds to (see Active Task)
.dev/tasks/<task-name>/
  requirements.md            written by /grill, refined by /brainstorm
  design.md                  written by /brainstorm for Deep tasks, rarely otherwise
  plan.md                    written by /plan
  implementation-trace.md    maintained by /execute
  verification.md            optional, written by /verify on request
  learning.md                optional, written by /explain on request
```

## Active Task

`.dev/active-task` holds one line: the name of the task that all unnamed work binds to.
It is per checkout, not per conversation; parallel conversations on one checkout must
name their task explicitly. Do not commit it.

Only explicit user action writes this file:
- `/grill new <requirement>`: after the user confirms the proposed name, the task is
  created and becomes active.
- Any stage invoked with an existing task name (`/verify camera-sync`) switches to it.
- A direct instruction such as "switch to udp-protocol" switches to it.

Nothing else writes it. Mentioning a task in prose, or reading its artifacts, never switches.

Task resolution, used by every skill and by any reply that edits code or artifacts.
Never use conversation history for this.
1. Task named in the command.
2. `.dev/active-task`, if that directory exists.
3. Exactly one directory under `.dev/tasks/`: adopt it and write `.dev/active-task`.
4. Otherwise list the tasks and ask. Never guess by modification time.

Every reply that edits code or artifacts starts with `Task: <name>`, adding
`(switched from <old>)` on the reply that switched, or `Task: none` when unbound.
Pure questions and discussion need no task and no first line.

## Scope Guard

Reading code, reading any task's artifacts, and discussion are free. Before writing
code or artifacts, classify the request against the active task:

- **IN**: covered by `requirements.md`. Proceed. An unplanned but in-scope edit gets one
  trace entry marked `Unplanned`.
- **EXTENSION**: needs a new or changed requirement or AC. Stop with SCOPE CHECK.
- **BOUNDARY**: matches another existing task, or hits this task's Non-goals or the
  plan's Out of Scope. Stop with SCOPE CHECK.

```
SCOPE CHECK
Task: camera-sync
Request: ...
Why: Non-goals says "..." | would change AC-02 | matches task udp-protocol
Options: 1. extend this task (requirements.md updated first)
         2. new task: /grill new <description>
         3. discuss only, write nothing
```

The guard proposes; it never writes `.dev/active-task` and never creates a task.

## Learner Profile

The developer has partial C++11 knowledge, basic STM32 embedded experience,
basic Linux/Jetson development experience, OpenCV fundamentals, and experience
training MMPose models mainly through dataset/config adaptation rather than model modification.

Currently developing deeper understanding of modern C++, ownership/lifetime, concurrency,
software architecture, Linux/Jetson engineering, and computer-vision/model internals.

When explaining, prioritize business logic, data flow, design intent, ownership/lifetime,
and non-obvious implementation choices. Skip basic syntax unless needed and point to
a small number of high-value code locations to study.

## Out of Scope for This Workflow

No skill router, no automatic chaining, no mandatory TDD, worktrees, subagents, or code
review. These may be added later as optional capabilities, never as infrastructure.

No task stack, session id, task status field, stage pointer, or automatic task closing.
`.dev/active-task` stays one line; stage progress is derived from the artifacts.
