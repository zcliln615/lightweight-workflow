# Sync skills from the canonical .claude/skills/ into .agents/skills/ (Codex).
# Run after editing any SKILL.md.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$src = Join-Path $root '.claude\skills'
$dst = Join-Path $root '.agents\skills'
if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
New-Item -ItemType Directory -Force $dst | Out-Null
Get-ChildItem -Directory $src | ForEach-Object {
    $target = Join-Path $dst $_.Name
    New-Item -ItemType Directory -Force $target | Out-Null
    Copy-Item (Join-Path $_.FullName 'SKILL.md') $target
    Write-Host "synced $($_.Name)"
}
