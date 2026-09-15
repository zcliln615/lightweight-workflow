#!/usr/bin/env sh
# Fail if .agents/skills (Codex copy) differs from .claude/skills (canonical).
set -e
root="$(cd "$(dirname "$0")/.." && pwd)"
if diff -r "$root/.claude/skills" "$root/.agents/skills"; then
  echo "skills in sync"
else
  echo "ERROR: .agents/skills is out of sync. Run scripts/sync-skills.sh" >&2
  exit 1
fi
