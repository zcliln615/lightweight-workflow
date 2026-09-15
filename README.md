# Lightweight Learning-Oriented Agent Workflow (V2)

Six explicit skills, no router, no automatic chaining. Works with Claude Code and Codex.

```
/grill  →  /brainstorm  →  /plan  →  /execute  →  /verify  or  /explain
```

Each stage runs only when you invoke it. You may skip stages.

## Principles

Explicit over Automatic. Artifacts over Context. Decision Trace over Tool Trace.
Complexity-Proportional Artifacts. Evidence before Claims. No Silent Requirement Changes.
Encode gates, not procedures.

One workflow, two thinking depths: **Bounded** by default, **Deep** when interfaces,
concurrency, external devices, or real trade-offs are involved (see `AGENTS.md`).
`requirements.md` + optional `design.md` form the Spec; `plan.md` is only the execution
map and is refused with `PLAN NOT READY` while the Spec has blocking gaps.

## Layout

```
AGENTS.md                      global rules and Learner Profile (edit the profile as you grow)
CLAUDE.md                      one-line include of AGENTS.md, for Claude Code
.claude/skills/<name>/SKILL.md canonical skills, read by Claude Code
.agents/skills/<name>/SKILL.md generated copy, read by Codex  (do not edit by hand)
scripts/sync-skills.*          regenerate .agents/skills from .claude/skills
scripts/install.*              copy the workflow into a project
```

Both agents read `AGENTS.md`: Codex natively, Claude Code through `CLAUDE.md`.

## Install into a project

```powershell
.\scripts\install.ps1 -Target C:\path\to\project
```

```sh
./scripts/install.sh /path/to/project
```

This copies `AGENTS.md`, `CLAUDE.md`, both skill directories, and creates `.dev/tasks/`.
Existing `AGENTS.md` / `CLAUDE.md` in the target are left untouched.

Cursor: reference `AGENTS.md` from `.cursor/rules` and paste a SKILL.md when invoking a stage.

## Editing skills

Edit only `.claude/skills/<name>/SKILL.md`, then run `scripts/sync-skills.ps1` (or `.sh`)
so the Codex copy stays identical.

## Task artifacts

Skills create `.dev/tasks/<task>/` inside the project that uses the workflow:

```
requirements.md            /grill
design.md                  /brainstorm, Deep tasks
plan.md                    /plan
implementation-trace.md    /execute
verification.md            optional, /verify on request
learning.md                optional, /explain on request
```

Commit `.dev/` in that project if you want the task history kept with the code.
