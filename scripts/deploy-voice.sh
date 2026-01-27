#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Voice Agent Deployment Script
# Sets up ngrok tunnel + configures Telnyx webhook
# ============================================================

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

GATEWAY_PORT="${GATEWAY_PORT:-3456}"
NGROK_PORT="${NGROK_PORT:-$GATEWAY_PORT}"
VOICE_PATH="/voice/webhook"

echo ""
echo -e "${BOLD}📞 Voice Agent Deployment${NC}"
echo ""

# ── Check prerequisites ───────────────────────────────────

if ! command -v ngrok &> /dev/null; then
    echo -e "${RED}ngrok not found.${NC}"
    echo "Install: https://ngrok.com/download"
    echo "  brew install ngrok    (macOS)"
    echo "  snap install ngrok    (Linux)"
    exit 1
fi

echo -e "${GREEN}✓${NC} ngrok found"

# ── Check if ngrok is already running ─────────────────────

if curl -s http://localhost:4040/api/tunnels &> /dev/null; then
    echo -e "${YELLOW}ngrok is already running.${NC}"
    TUNNEL_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | head -1 | cut -d'"' -f4)
    if [ -n "$TUNNEL_URL" ]; then
        echo -e "  Existing tunnel: ${GREEN}$TUNNEL_URL${NC}"
        WEBHOOK_URL="${TUNNEL_URL}${VOICE_PATH}"
        echo -e "  Webhook URL: ${GREEN}$WEBHOOK_URL${NC}"
    fi
else
    # Start ngrok
    echo "Starting ngrok tunnel on port $NGROK_PORT..."
    ngrok http "$NGROK_PORT" --log=stdout > /tmp/ngrok-voice.log 2>&1 &
    NGROK_PID=$!
    echo "  ngrok PID: $NGROK_PID"

    # Wait for tunnel to establish
    echo -n "  Waiting for tunnel"
    for i in {1..15}; do
        if curl -s http://localhost:4040/api/tunnels &> /dev/null; then
            echo ""
            break
        fi
        echo -n "."
        sleep 1
    done

    TUNNEL_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | head -1 | cut -d'"' -f4)

    if [ -z "$TUNNEL_URL" ]; then
        echo ""
        echo -e "${RED}Failed to get tunnel URL. Check ngrok auth and logs.${NC}"
        echo "  Logs: /tmp/ngrok-voice.log"
        exit 1
    fi

    WEBHOOK_URL="${TUNNEL_URL}${VOICE_PATH}"
    echo -e "  ${GREEN}✓${NC} Tunnel: $TUNNEL_URL"
    echo -e "  ${GREEN}✓${NC} Webhook: $WEBHOOK_URL"
fi

# ── Update config ──────────────────────────────────────────

CONFIG_FILE="config/config.json"
if [ -f "$CONFIG_FILE" ]; then
    if command -v jq &> /dev/null; then
        # Use jq if available
        TMP=$(mktemp)
        jq --arg url "$WEBHOOK_URL" '.plugins."voice-call".webhookUrl = $url' "$CONFIG_FILE" > "$TMP" && mv "$TMP" "$CONFIG_FILE"
        echo -e "  ${GREEN}✓${NC} Updated webhookUrl in config.json"
    else
        # Fallback to sed
        sed -i "s|\"webhookUrl\":.*|\"webhookUrl\": \"$WEBHOOK_URL\",|" "$CONFIG_FILE"
        echo -e "  ${GREEN}✓${NC} Updated webhookUrl in config.json (via sed)"
    fi
else
    echo -e "  ${YELLOW}~${NC} config.json not found — set webhookUrl manually: $WEBHOOK_URL"
fi

# ── Summary ────────────────────────────────────────────────

echo ""
echo -e "${GREEN}${BOLD}✅ Voice agent ready!${NC}"
echo ""
echo "Webhook URL: $WEBHOOK_URL"
echo ""
echo "Next steps:"
echo "  1. Set this webhook URL in your Telnyx SIP Connection settings"
echo "     Telnyx Portal → SIP Connections → Your Connection → Webhooks"
echo "  2. Ensure your Moltbot gateway is running on port $GATEWAY_PORT"
echo "  3. Test: call your Telnyx phone number"
echo ""
echo -e "${YELLOW}Note: ngrok URLs change on restart. For production, use a static domain.${NC}"
echo ""
