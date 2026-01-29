#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Strickland AI Agent Starter — Setup Script
# Sets up workspace, copies templates, and prompts for API keys
# ============================================================

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${BOLD}🤖 Strickland AI Agent Starter${NC}"
echo -e "   Setting up your AI business agent"
echo ""

# ── Prerequisites ──────────────────────────────────────────

check_prereq() {
    if command -v "$1" &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $1 found ($(command -v "$1"))"
        return 0
    else
        echo -e "  ${RED}✗${NC} $1 not found"
        return 1
    fi
}

echo -e "${BOLD}Checking prerequisites...${NC}"
MISSING=0
check_prereq "node" || MISSING=1
check_prereq "npm" || MISSING=1
check_prereq "git" || MISSING=1

# Check for agent-cli (optional but recommended)
if command -v agent-cli &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} agent-cli found"
elif command -v agent-cli &> /dev/null; then
    echo -e "  ${YELLOW}~${NC} agent-cli found (agent-cli alias)"
else
    echo -e "  ${YELLOW}~${NC} agent-cli not found — install from https://stricklandai.com"
fi

if [ "$MISSING" -eq 1 ]; then
    echo ""
    echo -e "${RED}Missing required tools. Please install them and re-run.${NC}"
    echo "  Node.js: https://nodejs.org"
    exit 1
fi

echo ""

# ── Workspace Setup ────────────────────────────────────────

WORKSPACE="./workspace"

echo -e "${BOLD}Creating workspace structure...${NC}"

mkdir -p "$WORKSPACE/memory/outreach"
mkdir -p "$WORKSPACE/data"
echo -e "  ${GREEN}✓${NC} Created $WORKSPACE/"
echo -e "  ${GREEN}✓${NC} Created $WORKSPACE/memory/"
echo -e "  ${GREEN}✓${NC} Created $WORKSPACE/data/"

# ── Copy Templates ─────────────────────────────────────────

echo ""
echo -e "${BOLD}Copying templates to workspace...${NC}"

for template in templates/*.md; do
    filename=$(basename "$template")
    if [ ! -f "$WORKSPACE/$filename" ]; then
        cp "$template" "$WORKSPACE/$filename"
        echo -e "  ${GREEN}✓${NC} Copied $filename"
    else
        echo -e "  ${YELLOW}~${NC} $filename already exists, skipping"
    fi
done

# ── Config Setup ───────────────────────────────────────────

echo ""
echo -e "${BOLD}Setting up configuration...${NC}"

if [ ! -f "config/config.json" ]; then
    cp config/example-config.json config/config.json
    echo -e "  ${GREEN}✓${NC} Created config/config.json from example"
else
    echo -e "  ${YELLOW}~${NC} config/config.json already exists, skipping"
fi

# ── API Keys ───────────────────────────────────────────────

echo ""
echo -e "${BOLD}API Key Configuration${NC}"
echo "You can set these now or edit config/config.json later."
echo ""

read -p "Configure API keys now? (y/N): " CONFIGURE_KEYS

if [[ "$CONFIGURE_KEYS" =~ ^[Yy]$ ]]; then
    echo ""

    read -p "Anthropic API Key (from console.anthropic.com): " ANTHROPIC_KEY
    if [ -n "$ANTHROPIC_KEY" ]; then
        sed -i "s/YOUR_ANTHROPIC_API_KEY_HERE/$ANTHROPIC_KEY/g" config/config.json
        echo -e "  ${GREEN}✓${NC} Anthropic key set"
    fi

    read -p "ElevenLabs API Key (from elevenlabs.io): " ELEVEN_KEY
    if [ -n "$ELEVEN_KEY" ]; then
        sed -i "s/YOUR_ELEVENLABS_API_KEY_HERE/$ELEVEN_KEY/g" config/config.json
        echo -e "  ${GREEN}✓${NC} ElevenLabs key set"
    fi

    read -p "Telnyx API Key (from telnyx.com, optional): " TELNYX_KEY
    if [ -n "$TELNYX_KEY" ]; then
        sed -i "s/YOUR_TELNYX_API_KEY_HERE/$TELNYX_KEY/g" config/config.json
        echo -e "  ${GREEN}✓${NC} Telnyx key set"
    fi

    read -p "Deepgram API Key (from deepgram.com, optional): " DEEPGRAM_KEY
    if [ -n "$DEEPGRAM_KEY" ]; then
        sed -i "s/YOUR_DEEPGRAM_API_KEY_HERE/$DEEPGRAM_KEY/g" config/config.json
        echo -e "  ${GREEN}✓${NC} Deepgram key set"
    fi
fi

# ── Create TOOLS.md ────────────────────────────────────────

if [ ! -f "$WORKSPACE/TOOLS.md" ]; then
    cat > "$WORKSPACE/TOOLS.md" << 'EOF'
# TOOLS.md — Local Notes

Environment-specific configuration for your agent.
Add camera names, SSH hosts, voice preferences, etc.

## Email

**Reading:**
- CLI: `himalaya`
- Commands: `himalaya envelope list`, `himalaya message read <id>`

**Sending:**
- Configure your send method in config.json
- See workflows/email-integration.md for setup

## Voice

- Preferred voice: (set your ElevenLabs voice ID in config)
- Default greeting: (customize in config.json voice-call section)

## Notes

Add your own environment-specific notes here.
EOF
    echo -e "  ${GREEN}✓${NC} Created TOOLS.md"
fi

# ── Initialize Memory ──────────────────────────────────────

if [ ! -f "$WORKSPACE/MEMORY.md" ]; then
    cat > "$WORKSPACE/MEMORY.md" << 'EOF'
# MEMORY.md — Long-Term Memory

This file stores curated long-term memories. The agent updates it
during heartbeats with insights worth keeping.

## Key Facts

(Agent will populate this over time)

## Lessons Learned

(Agent will populate this over time)

## Important Contacts

(Agent will populate this over time)
EOF
    echo -e "  ${GREEN}✓${NC} Created MEMORY.md"
fi

# ── Done ───────────────────────────────────────────────────

echo ""
echo -e "${GREEN}${BOLD}✅ Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit workspace/SOUL.md — define your agent's personality"
echo "  2. Edit workspace/USER.md — tell the agent about yourself"
echo "  3. Edit config/config.json — add remaining API keys"
echo "  4. Run: agent-cli start"
echo ""
echo "Guides:"
echo "  • Full walkthrough:  docs/getting-started.md"
echo "  • Config reference:  config/config-guide.md"
echo "  • Voice setup:       workflows/voice-agent.md"
echo "  • Email setup:       workflows/email-integration.md"
echo ""
echo -e "${BOLD}Built by Strickland AI — stricklandai.com${NC}"
echo ""
