# Project Workflow

How to start and work on a project with agent-os + engram + Claude Code.

---

## Starting a new project

### 1. Create the project and open Claude Code

```powershell
mkdir my-project
cd my-project
git init
claude   # opens Claude Code in this directory
```

### 2. Initialize agent-os with the right profile

From a terminal inside the project directory:

```powershell
aoi react-nodejs      # React + Node.js project
aoi angular           # Angular project
aoi angular-nestjs    # Angular frontend + NestJS backend
```

What this does:
- Creates `agent-os/standards/` with the official coding standards for your stack
- Creates `.claude/commands/agent-os/` which activates the slash commands in Claude Code

### 3. Check what was installed

```
agent-os/
  standards/
    react/            # (react-nodejs profile)
      components.md
      hooks.md
      naming.md
    nodejs/
      structure.md
      error-handling.md
      security.md
    index.yml         # index of all standards
.claude/
  commands/
    agent-os/         # slash commands now active in Claude Code
```

### 4. (Optional) Add product context

Create `agent-os/product/` to give Claude Code project-specific context:

```
agent-os/product/
  mission.md          # what this app does, who it's for
  tech-stack.md       # your specific versions and choices
  roadmap.md          # current priorities
```

These files are read automatically by `/agent-os:shape-spec`.

---

## Daily workflow inside Claude Code

### Starting a feature

**Option A — Full planning mode:**
```
/plan
/agent-os:shape-spec
```
Claude will ask you what you're building, pull relevant standards, and produce a spec with tasks before writing any code.

**Option B — Quick task:**
```
/agent-os:inject-standards
```
Injects the relevant standards into context, then describe what you want.

### Discovering standards from existing code

If the project already has conventions you want to document:
```
/agent-os:discover-standards
```
Claude analyzes the codebase, finds patterns, and writes them as standard files.

### Updating the standards index

After adding or editing standard files manually:
```
/agent-os:index-standards
```

---

## Engram: persistent memory

Engram runs automatically in the background — Claude Code calls it via MCP.

**What it saves automatically:**
- Architecture decisions
- Bug solutions and their root causes
- Patterns discovered during development
- Project-specific conventions

**Commands inside Claude Code (via MCP tools):**
- `mem_save` — Claude calls this when it finds something worth remembering
- `mem_search` — Claude searches memory when starting a new task
- `mem_context` — pulls recent context from previous sessions

**Check your memories:**
```powershell
engram search "authentication"    # search specific topic
engram tui                        # visual browser
engram stats                      # overview of all projects
```

**Sync memories across machines (git-based):**
```powershell
# Export from this machine
engram sync --project my-project

# Import on another machine (after cloning the repo)
engram sync --import
```

---

## Committing the agent-os folder

Commit `agent-os/standards/` and `.claude/` to your project repo.
This means any team member (or future you) gets the same standards and commands.

```
.gitignore additions (optional):
agent-os/specs/          # spec files are working docs, often not committed
```

---

## Workflow summary

```
New project
  └─ aoi <profile>                    → installs standards + commands

Planning a feature
  └─ /plan → /agent-os:shape-spec     → spec doc + task list

Implementing
  └─ /agent-os:inject-standards       → loads relevant standards into context
  └─ code with Claude                 → engram saves decisions automatically

Next session
  └─ engram surfaces prior context    → Claude resumes with memory intact
```
