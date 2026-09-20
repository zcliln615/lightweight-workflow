#!/usr/bin/env sh
# Install the workflow into a target project.
# Usage: ./scripts/install.sh /path/to/project
set -e
[ -n "$1" ] && [ -d "$1" ] || { echo "usage: $0 <project-dir>"; exit 1; }
root="$(cd "$(dirname "$0")/.." && pwd)"
for f in AGENTS.md CLAUDE.md; do
  if [ -e "$1/$f" ]; then
    echo "WARNING: $f already exists in target and was NOT modified."
    echo "         The skills depend on the Task Directory, Active Task, Scope Guard, Adaptive Depth"
    echo "         and Learner Profile sections of this repo's AGENTS.md; merge them into the target's $f"
    echo "         before use, or the workflow is only half installed."
  else cp "$root/$f" "$1/"; fi
done
mkdir -p "$1/.claude/skills" "$1/.agents/skills" "$1/.dev/tasks"
cp -R "$root/.claude/skills/." "$1/.claude/skills/"
cp -R "$root/.agents/skills/." "$1/.agents/skills/"
grep -qx '.dev/active-task' "$1/.gitignore" 2>/dev/null || printf '\n# Per-checkout workflow pointer\n.dev/active-task\n' >> "$1/.gitignore"
echo "Installed workflow into $1"
