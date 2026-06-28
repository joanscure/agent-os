# =============================================================================
# Dev Environment Setup Script
# Sets up agent-os, engram, and PowerShell aliases for Claude Code workflow
# Usage: Run from PowerShell as Administrator on a new machine
# =============================================================================

param(
    [string]$AgentOsRepo = "https://github.com/joanscure/agent-os.git",
    [string]$AgentOsDir  = "$env:USERPROFILE\agent-os"
)

$ErrorActionPreference = "Stop"

function Write-Step { param([string]$msg) Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$msg) Write-Host "    [OK] $msg" -ForegroundColor Green }
function Write-Warn { param([string]$msg) Write-Host "    [!]  $msg" -ForegroundColor Yellow }

# -----------------------------------------------------------------------------
# 1. Clone or update agent-os
# -----------------------------------------------------------------------------
Write-Step "Setting up agent-os..."

if (Test-Path "$AgentOsDir\.git") {
    Write-Warn "agent-os already exists — pulling latest..."
    git -C $AgentOsDir pull
} else {
    git clone $AgentOsRepo $AgentOsDir
}
Write-Ok "agent-os ready at $AgentOsDir"

# -----------------------------------------------------------------------------
# 2. Install engram (Go binary for persistent AI memory)
# -----------------------------------------------------------------------------
Write-Step "Installing engram..."

$engramBin = "$env:USERPROFILE\.engram\bin"
$engramExe = "$engramBin\engram.exe"

if (Test-Path $engramExe) {
    Write-Warn "engram already installed — skipping"
} else {
    # Try go install first (preferred — avoids AV false positives)
    if (Get-Command go -ErrorAction SilentlyContinue) {
        Write-Host "    Go found — building engram from source..."
        go install github.com/Gentleman-Programming/engram/cmd/engram@latest
        Write-Ok "engram installed via go install"
    } else {
        # Download prebuilt binary from latest GitHub release
        Write-Host "    Go not found — downloading prebuilt binary..."
        $releaseUrl = "https://api.github.com/repos/Gentleman-Programming/engram/releases/latest"
        $release = Invoke-RestMethod -Uri $releaseUrl
        $asset = $release.assets | Where-Object { $_.name -like "*windows_amd64*" } | Select-Object -First 1

        if ($null -eq $asset) {
            Write-Warn "Could not find Windows binary in latest release. Install Go and re-run, or download manually from:"
            Write-Host "    https://github.com/Gentleman-Programming/engram/releases" -ForegroundColor Blue
        } else {
            New-Item -ItemType Directory -Force -Path $engramBin | Out-Null
            $zipPath = "$env:TEMP\engram.zip"
            Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath
            Expand-Archive -Path $zipPath -DestinationPath $engramBin -Force
            Remove-Item $zipPath
            Write-Ok "engram binary downloaded to $engramBin"

            # Add to PATH if not already there
            $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
            if ($currentPath -notlike "*$engramBin*") {
                [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$engramBin", "User")
                $env:PATH += ";$engramBin"
                Write-Ok "Added $engramBin to user PATH"
            }
        }
    }
}

# -----------------------------------------------------------------------------
# 3. Set up PowerShell profile with agent-os helpers
# -----------------------------------------------------------------------------
Write-Step "Configuring PowerShell profile..."

$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Force -Path $profileDir | Out-Null }
if (-not (Test-Path $PROFILE))    { New-Item -ItemType File -Path $PROFILE | Out-Null }

$marker = "# agent-os helpers"
$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue

if ($profileContent -notlike "*$marker*") {
    $snippet = @'

# agent-os helpers
function agent-os-install {
    <#
    .SYNOPSIS Install agent-os into the current project directory.
    .EXAMPLE agent-os-install
    .EXAMPLE agent-os-install angular
    .EXAMPLE agent-os-install angular-nestjs
    .EXAMPLE agent-os-install react-nodejs
    #>
    param([string]$Profile = "")
    $script = "$env:USERPROFILE\agent-os\scripts\project-install.sh"
    if ($Profile) {
        bash $script --profile $Profile
    } else {
        bash $script
    }
}
Set-Alias -Name aoi -Value agent-os-install
'@
    Add-Content -Path $PROFILE -Value $snippet
    Write-Ok "agent-os helpers added to PowerShell profile"
} else {
    Write-Warn "agent-os helpers already in profile — skipping"
}

# -----------------------------------------------------------------------------
# 4. Install engram Claude Code plugin
# -----------------------------------------------------------------------------
Write-Step "Installing engram plugin for Claude Code..."

if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "    Run these commands manually in your terminal:"
    Write-Host "    claude plugin marketplace add Gentleman-Programming/engram" -ForegroundColor Yellow
    Write-Host "    claude plugin install engram" -ForegroundColor Yellow
    Write-Host "    (Claude Code must be running to install plugins)"
} else {
    Write-Warn "claude CLI not found — install Claude Code first, then run:"
    Write-Host "    claude plugin marketplace add Gentleman-Programming/engram" -ForegroundColor Yellow
    Write-Host "    claude plugin install engram" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Dev environment setup complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Restart your terminal, then use:" -ForegroundColor White
Write-Host "  agent-os-install                  # default profile (react-nodejs)" -ForegroundColor Cyan
Write-Host "  agent-os-install angular           # Angular project" -ForegroundColor Cyan
Write-Host "  agent-os-install angular-nestjs    # Angular + NestJS project" -ForegroundColor Cyan
Write-Host "  aoi angular                        # short alias" -ForegroundColor Cyan
Write-Host ""
Write-Host "Inside a project, Claude Code slash commands:" -ForegroundColor White
Write-Host "  /agent-os:discover-standards       # extract conventions from codebase" -ForegroundColor Cyan
Write-Host "  /agent-os:inject-standards         # inject standards into context" -ForegroundColor Cyan
Write-Host "  /agent-os:shape-spec               # plan a feature (use in plan mode)" -ForegroundColor Cyan
Write-Host ""
