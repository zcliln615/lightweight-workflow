---
name: verify
description: Check the implementation against each acceptance criterion in requirements.md and report PASS, FAIL, PARTIAL or NOT VERIFIED with evidence. Invoked explicitly by the user.
---

# /verify

Answer the question: **does the implementation actually satisfy the original requirements?**

## Inputs

- `.dev/tasks/<task>/requirements.md` (required, especially the Acceptance Criteria).
- `.dev/tasks/<task>/implementation-trace.md`, `plan.md`, `design.md` if present.
- Current source code and existing tests.
- The user's current message: it may restrict verification to specific ACs.

## Rules

- Build the matrix from the ACs as written. Use each AC's "Expected verification" as the
  method. Do not invent a different method unless the stated one is impossible; say so.
- Obtain evidence before assigning a result: run the test, execute the simulation, read
  the specific code. Then report what you observed, with numbers where relevant.
- Where the AC is marked Agent-verifiable: No, or the required environment is absent,
  the result is NOT VERIFIED with the reason. Never upgrade "code looks right" to PASS.
- Distinguish clearly: proven, inferred from reading, unable to check.
- You may write small throwaway test or simulation scripts to gather evidence.
  Do not fix product code here. Report failures; fixing is a new `/execute`.

## Results

Only these four values:

- **PASS**: direct evidence that the criterion is met.
- **FAIL**: direct evidence that it is not.
- **PARTIAL**: some aspects proven, others not, or met only under limited conditions.
- **NOT VERIFIED**: no usable evidence in this environment.

## Output

Report in chat:

```
| AC    | Method                | Evidence                          | Result       |
| AC-01 | simulated timestamps  | 1000 pairs, max diff 4.8 ms       | PASS         |
| AC-04 | hardware test         | no Jetson available               | NOT VERIFIED |

Notes: one line per FAIL, PARTIAL or NOT VERIFIED explaining the gap.
Remaining for the user: what only a human or real hardware can check.
```

Write `.dev/tasks/<task>/verification.md` with the same content only if the user asks,
or the task is large enough that the result will be needed later.

## Finish

Give the matrix and an honest one-line overall status. Then stop.
Do not start `/execute` to fix failures and do not start `/explain`.
