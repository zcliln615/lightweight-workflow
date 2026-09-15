#!/usr/bin/env sh
# Sync skills from the canonical .claude/skills/ into .agents/skills/ (Codex).
set -e
root="$(cd "$(dirname "$0")/.." && pwd)"
rm -rf "$root/.agents/skills"
mkdir -p "$root/.agents/skills"
for d in "$root"/.claude/skills/*/; do
  name="$(basename "$d")"
  mkdir -p "$root/.agents/skills/$name"
  cp "$d/SKILL.md" "$root/.agents/skills/$name/"
  echo "synced $name"
done
