# Setup: New Machine

Everything needed to replicate this AI-assisted dev environment from scratch on Windows.
Primary shell: **CMD** (Command Prompt). Git Bash is required internally but you don't type in it.

---

## Prerequisites — install in this order

| Tool | Why | How |
|---|---|---|
| **Git** | Cloning repos + Git Bash (runs agent-os scripts internally) | https://git-scm.com/download/win |
| **Node.js LTS** | Frontend/backend projects | `winget install OpenJS.NodeJS.LTS` |
| **Go** | Needed to build engram | `winget install GoLang.Go` |
| **Claude Code** | AI coding CLI | https://claude.ai/code |

Verify in CMD after installing:
```cmd
git --version
node --version
go version
claude --version
```

---

## Step 1: Clone your agent-os fork

```cmd
git clone https://github.com/joanscure/agent-os.git %USERPROFILE%\agent-os
```

This installs your personal fork with profiles for React/Node, Angular, and Angular+NestJS.

---

## Step 2: Install engram

```cmd
go install github.com/Gentleman-Programming/engram/cmd/engram@latest
```

The binary installs to `%USERPROFILE%\go\bin\engram.exe`.

Add Go binaries to PATH permanently (run once in CMD):
```cmd
setx PATH "%PATH%;%USERPROFILE%\go\bin"
```

Open a **new** CMD window, then verify:
```cmd
engram --version
```

---

## Step 3: Connect engram to Claude Code

```cmd
engram setup claude-code
```

When it asks about the allowlist, type `y` and press Enter.

This wires engram as an MCP server — Claude Code calls it automatically every session, no manual startup needed.

---

## Step 4: Set up the `aoi` command

Copy the `.bat` files from your fork to `%USERPROFILE%\bin`:

```cmd
mkdir %USERPROFILE%\bin
copy %USERPROFILE%\agent-os\scripts\aoi.bat %USERPROFILE%\bin\aoi.bat
copy %USERPROFILE%\agent-os\scripts\agent-os-install.bat %USERPROFILE%\bin\agent-os-install.bat
```

Add `%USERPROFILE%\bin` to PATH permanently:
```cmd
setx PATH "%PATH%;%USERPROFILE%\bin"
```

Open a **new** CMD window and verify:
```cmd
aoi
```

You should see the agent-os install script run (it will say "not in base installation directory" if you're not inside a project — that's normal).

---

## Step 5: Verify everything

Open a new CMD window and run:

```cmd
rem Check agent-os profiles
dir %USERPROFILE%\agent-os\profiles

rem Check engram
engram --version
engram stats

rem Check aoi shortcut
aoi
```

---

## What you now have

| Tool | Command | Purpose |
|---|---|---|
| agent-os | `aoi <profile>` | Per-project coding standards + AI planning commands |
| engram | automatic | Persistent memory across Claude Code sessions |
| Claude Code | `claude` | AI coding assistant |

**Profiles available:**
- `aoi react-nodejs` — React 18 + Node.js
- `aoi angular` — Angular 17+ standalone
- `aoi angular-nestjs` — Angular frontend + NestJS backend

**Next:** See `PROJECT-WORKFLOW.md` to initialize your first project.
