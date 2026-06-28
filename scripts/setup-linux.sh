#!/usr/bin/env bash
# =============================================================================
# Dev Environment Setup Script — Linux / macOS
# Sets up agent-os, engram, and shell alias for Claude Code workflow
# Usage: bash setup-linux.sh
# =============================================================================

set -e

AGENT_OS_REPO="https://github.com/joanscure/agent-os.git"
AGENT_OS_DIR="$HOME/agent-os"

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'
step()  { echo -e "\n${CYAN}==> $1${NC}"; }
ok()    { echo -e "${GREEN}    [OK] $1${NC}"; }
warn()  { echo -e "${YELLOW}    [!]  $1${NC}"; }

# -----------------------------------------------------------------------------
# 1. Clone or update agent-os
# -----------------------------------------------------------------------------
step "Setting up agent-os..."

if [ -d "$AGENT_OS_DIR/.git" ]; then
    warn "agent-os already exists — pulling latest..."
    git -C "$AGENT_OS_DIR" pull
else
    git clone "$AGENT_OS_REPO" "$AGENT_OS_DIR"
fi
ok "agent-os ready at $AGENT_OS_DIR"

# -----------------------------------------------------------------------------
# 2. Install Go (if missing)
# -----------------------------------------------------------------------------
step "Checking Go..."

if command -v go &>/dev/null; then
    ok "Go already installed: $(go version)"
else
    warn "Go not found. Install it from https://go.dev/dl/ then re-run this script."
    warn "On Ubuntu/Debian: sudo apt install golang-go"
    warn "On macOS: brew install go"
    exit 1
fi

# -----------------------------------------------------------------------------
# 3. Install engram
# -----------------------------------------------------------------------------
step "Installing engram..."

if command -v engram &>/dev/null; then
    warn "engram already installed: $(engram --version 2>/dev/null | head -1)"
else
    go install github.com/Gentleman-Programming/engram/cmd/engram@latest
    ok "engram installed"
fi

# Make sure ~/go/bin is in PATH
GOBIN="$(go env GOPATH)/bin"
if [[ ":$PATH:" != *":$GOBIN:"* ]]; then
    warn "$GOBIN not in PATH — adding to shell config..."

    # Detect shell config file
    if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "$(which zsh)" ]; then
        SHELL_RC="$HOME/.zshrc"
    else
        SHELL_RC="$HOME/.bashrc"
    fi

    echo "" >> "$SHELL_RC"
    echo "# Go binaries" >> "$SHELL_RC"
    echo "export PATH=\"\$PATH:$GOBIN\"" >> "$SHELL_RC"
    export PATH="$PATH:$GOBIN"
    ok "Added $GOBIN to $SHELL_RC"
fi

# -----------------------------------------------------------------------------
# 4. Connect engram to Claude Code
# -----------------------------------------------------------------------------
step "Connecting engram to Claude Code..."

if command -v claude &>/dev/null; then
    echo y | engram setup claude-code || true
    ok "engram wired to Claude Code"
else
    warn "claude CLI not found — install Claude Code first, then run:"
    warn "  echo y | engram setup claude-code"
fi

# -----------------------------------------------------------------------------
# 5. Add aoi alias to shell config
# -----------------------------------------------------------------------------
step "Adding aoi alias..."

# Detect shell config
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "$(which zsh)" ]; then
    SHELL_RC="$HOME/.zshrc"
else
    SHELL_RC="$HOME/.bashrc"
fi

MARKER="# agent-os helpers"
if grep -q "$MARKER" "$SHELL_RC" 2>/dev/null; then
    warn "aoi alias already in $SHELL_RC — skipping"
else
    cat >> "$SHELL_RC" << 'ALIAS'

# agent-os helpers
aoi() {
    if [ -n "$1" ]; then
        bash "$HOME/agent-os/scripts/project-install.sh" --profile "$1"
    else
        bash "$HOME/agent-os/scripts/project-install.sh"
    fi
}
ALIAS
    ok "aoi alias added to $SHELL_RC"
fi

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  Setup complete! Restart your terminal, then use:${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
echo "  aoi react-nodejs       # React + Node.js project"
echo "  aoi react              # React frontend only"
echo "  aoi angular            # Angular project"
echo "  aoi angular-nestjs     # Angular + NestJS project"
echo "  aoi nestjs             # NestJS backend only"
echo "  aoi nodejs             # Node.js backend only"
echo "  aoi vanilla-js         # Vanilla JS project"
echo "  aoi html-css           # HTML/CSS only project"
echo ""
echo "  See docs/SETUP-NEW-MACHINE.md for details."
echo ""
