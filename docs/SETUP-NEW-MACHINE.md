# Setup: New Machine

Everything needed to replicate this AI-assisted dev environment from scratch.

---

## Prerequisites

Install these first (in order):

### 1. Core tools
- **Git** — https://git-scm.com/download/win (includes Git Bash, needed for agent-os scripts)
- **Node.js LTS** — https://nodejs.org (or via `winget install OpenJS.NodeJS.LTS`)
- **Go** — `winget install GoLang.Go` (needed for engram)
- **Claude Code** — https://claude.ai/code (the AI coding CLI)

### 2. Verify installs
```powershell
git --version
node --version
go version
claude --version
```

---

## Step 1: Clone agent-os (your fork)

```powershell
git clone https://github.com/joanscure/agent-os.git "$env:USERPROFILE\agent-os"
```

This is your personal fork with custom profiles for React/Node, Angular, and Angular+NestJS.

---

## Step 2: Install engram

```powershell
go install github.com/Gentleman-Programming/engram/cmd/engram@latest
```

The binary installs to `~/go/bin/engram.exe`.

**Add Go binaries to PATH** (if not already):
```powershell
# Run once — adds permanently to user PATH
$gobin = "$env:USERPROFILE\go\bin"
$current = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($current -notlike "*$gobin*") {
    [Environment]::SetEnvironmentVariable("PATH", "$current;$gobin", "User")
}
```

Restart terminal, then verify: `engram --version`

---

## Step 3: Connect engram to Claude Code

```powershell
engram setup claude-code
```

This writes the MCP config to Claude Code's settings so engram starts automatically with every Claude Code session. No manual server startup needed.

Verify it's wired: open Claude Code and look for engram MCP tools (`mem_save`, `mem_search`, etc.).

---

## Step 4: Configure PowerShell profile

Run the setup script from your agent-os fork — it adds the `agent-os-install` / `aoi` shortcuts:

```powershell
& "$env:USERPROFILE\agent-os\scripts\setup-dev-env.ps1"
```

Restart the terminal. Verify:
```powershell
agent-os-install --help   # or just type: aoi
```

---

## Step 5: Verify everything

```powershell
# agent-os profiles available
ls "$env:USERPROFILE\agent-os\profiles"
# → angular, angular-nestjs, react-nodejs, default

# engram working
engram stats

# Go binaries in PATH
engram --version
```

---

## What you now have

| Tool | Purpose |
|---|---|
| `agent-os` | Per-project coding standards + AI planning commands |
| `engram` | Persistent memory across Claude Code sessions |
| `aoi <profile>` | One-command project initialization |
| Claude Code | AI coding assistant (connects to both tools automatically) |

**Next:** See `PROJECT-WORKFLOW.md` to initialize your first project.
