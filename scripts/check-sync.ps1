# Fail if .agents/skills (Codex copy) differs from .claude/skills (canonical).
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$bad = 0
foreach ($d in Get-ChildItem -Directory (Join-Path $root '.claude\skills')) {
    $a = Join-Path $d.FullName 'SKILL.md'
    $b = Join-Path $root ".agents\skills\$($d.Name)\SKILL.md"
    if (-not (Test-Path $b) -or (Get-FileHash $a).Hash -ne (Get-FileHash $b).Hash) {
        Write-Host "OUT OF SYNC: $($d.Name)"; $bad = 1
    }
}
if ($bad) { Write-Error "Run scripts/sync-skills.ps1"; exit 1 }
Write-Host "skills in sync"
