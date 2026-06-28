# AI-Assisted Development Workflow

An overview of the toolchain and methodology I use to build software with AI coding agents.

---

## The Problem This Solves

AI coding assistants are powerful but have two critical limitations:

1. **No memory** — every session starts blank; the agent doesn't know what was decided last week
2. **No standards** — without context, the agent writes generic code that may not match the project's conventions

This workflow solves both.

---

## The Toolchain

### Claude Code
AI coding CLI by Anthropic. Used as the primary coding interface — not just autocomplete, but a full agent that can plan, implement, refactor, and review code across the entire codebase.

### Agent OS (`github.com/joanscure/agent-os`)
A system for managing **per-project coding standards** and **AI planning commands**.

- Standards are markdown files stored in `agent-os/standards/` inside each project
- They encode conventions like: how to structure components, how to handle errors, naming rules
- Standards are loaded into the AI's context on demand — so the agent writes code that matches the project, not generic code

**Custom profiles for each stack:**
- `react-nodejs` — React 18 + Node.js layered architecture
- `angular` — Angular 17+ standalone components with signals
- `angular-nestjs` — Angular frontend + NestJS backend (inherits angular standards)

### Engram (`github.com/Gentleman-Programming/engram`)
Persistent memory for AI agents. A local SQLite database exposed to Claude Code via MCP protocol.

- When Claude discovers something important (a bug's root cause, an architecture decision, a project quirk), it saves it to engram
- The next session, Claude searches engram before starting work — it already knows the project context
- No more re-explaining the same things every session

---

## How the Tools Connect

```
┌─────────────────────────────────────────────────────┐
│                   Claude Code                        │
│                                                      │
│  Reads:  agent-os/standards/*.md  (coding rules)    │
│  Reads:  .claude/commands/agent-os/*.md (commands)  │
│  Calls:  engram MCP tools (memory read/write)       │
└─────────────┬───────────────────────┬───────────────┘
              │                       │
              ▼                       ▼
   agent-os/standards/         ~/.engram/engram.db
   (per-project, in repo)      (per-machine, persisted)
```

---

## Workflow by Phase

### Phase 1: Project Setup (~2 minutes)

```powershell
mkdir project && cd project && git init
aoi angular-nestjs         # installs standards + activates AI commands
```

Standards installed are based on official sources:
- Angular: angular.dev/style-guide (official Angular team)
- NestJS: docs.nestjs.com official conventions
- Node.js: goldbergyoni/nodebestpractices (★100k+ community guide)
- React: Airbnb React Style Guide (most widely adopted)

### Phase 2: Feature Planning

Before writing code, enter plan mode and run shape-spec:
```
/plan
/agent-os:shape-spec
```

The agent asks:
- What are we building?
- Do you have mockups or references?
- Which standards apply?

Output: a spec document with a task list, stored in `agent-os/specs/YYYY-MM-DD-feature-name/`. The agent works from this spec instead of improvising.

### Phase 3: Implementation

```
/agent-os:inject-standards
```

Loads the relevant standards into context (e.g., Angular component rules when building a component). The agent now writes code that follows the project conventions.

As work progresses, engram captures:
- Why a certain approach was chosen
- What was tried and didn't work
- Project-specific quirks

### Phase 4: New Session / Next Day

Claude Code starts and engram surfaces relevant prior context:
- "Last session you were working on the auth module. Key decision: JWT with refresh token rotation."
- The agent picks up where you left off without re-explaining the whole system

---

## Why This Matters

**Consistency** — Every AI-generated file follows the same patterns as human-written code in the project, because the standards are explicit and loaded into context.

**Continuity** — Memory persists across sessions. The 10 minutes spent explaining architecture on day 1 doesn't need to be repeated on day 5.

**Portability** — Standards are committed to the project repo. Anyone cloning the repo (or the AI working on it) immediately has the conventions documented.

**Reproducibility** — The setup can be replicated on a new machine in minutes from the fork (`github.com/joanscure/agent-os`).

---

## Standard Slot per Stack

| Profile | Standards included |
|---|---|
| `react-nodejs` | React components, hooks, naming / Node.js structure, error handling, security |
| `angular` | Angular naming, components (OnPush + signals), modules, DI patterns |
| `angular-nestjs` | All angular standards + NestJS modules, controllers, services, DTOs |

---

## Key Principle

> The AI agent is a fast executor, not an architect. You define the standards. The agent applies them consistently at scale.

Standards live in the repo, not in the AI's head. Anyone (human or AI) joining the project can read them.
