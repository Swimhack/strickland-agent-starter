#!/bin/bash
# Strickland AI Agent - Start Script

set -e

CONFIG_FILE="${CONFIG_FILE:-config/config.json}"
WORKSPACE="${WORKSPACE:-./workspace}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Starting Strickland AI Agent...${NC}"

# Check for config
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}Config not found at $CONFIG_FILE${NC}"
    echo "Copy the example config first:"
    echo "  cp config/example-config.json config/config.json"
    exit 1
fi

# Check for required env vars (warn if missing)
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Warning: ANTHROPIC_API_KEY not set${NC}"
fi

# Start the agent runtime
# Uses clawdbot under the hood (install via: npm install -g clawdbot)
if command -v clawdbot &> /dev/null; then
    exec clawdbot start --config "$CONFIG_FILE" --workspace "$WORKSPACE"
elif command -v moltbot &> /dev/null; then
    exec moltbot start --config "$CONFIG_FILE" --workspace "$WORKSPACE"
else
    echo -e "${YELLOW}Agent runtime not found.${NC}"
    echo ""
    echo "Install the runtime:"
    echo "  npm install -g clawdbot"
    echo ""
    echo "Then run this script again."
    exit 1
fi
