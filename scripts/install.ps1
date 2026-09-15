# Install the workflow into a target project.
# Usage: .\scripts\install.ps1 -Target C:\path\to\project
param([Parameter(Mandatory = $true)][string]$Target)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path $Target)) { throw "Target does not exist: $Target" }
foreach ($f in 'AGENTS.md', 'CLAUDE.md') {
    if (Test-Path (Join-Path $Target $f)) {
        Write-Warning "$f already exists in target and was NOT modified. The skills depend on the Adaptive Depth and Learner Profile sections of this repo's AGENTS.md; merge them into the target's $f by hand."
    }
    else { Copy-Item (Join-Path $root $f) $Target }
}
foreach ($d in '.claude\skills', '.agents\skills') {
    New-Item -ItemType Directory -Force (Join-Path $Target $d) | Out-Null
    Copy-Item -Recurse -Force (Join-Path $root "$d\*") (Join-Path $Target $d)
}
New-Item -ItemType Directory -Force (Join-Path $Target '.dev\tasks') | Out-Null
Write-Host "Installed workflow into $Target"
