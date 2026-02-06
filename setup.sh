#!/bin/bash

# Strickland Agent Starter - Automated Setup
# Installs and configures your personal AI agent in minutes

set -e

echo "🤖 Strickland Agent Starter Setup"
echo "=================================="
echo ""

# Check prerequisites
check_prerequisites() {
    echo "📋 Checking prerequisites..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        echo "❌ Node.js not found. Installing..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        echo "❌ Node.js 18+ required. Please upgrade."
        exit 1
    fi
    
    echo "✅ Node.js $(node -v) found"
    
    # Check pnpm or npm
    if ! command -v pnpm &> /dev/null; then
        echo "📦 Installing pnpm..."
        npm install -g pnpm
    fi
    
    echo "✅ pnpm $(pnpm -v) found"
}

# Collect user information
collect_user_info() {
    echo ""
    echo "📝 Let's set up your agent..."
    echo ""
    
    read -p "What's your name? " USER_NAME
    read -p "What should we call you? (nickname) " USER_NICKNAME
    read -p "Your timezone (e.g., America/Chicago): " USER_TIMEZONE
    read -p "Your email: " USER_EMAIL
    read -p "Your phone (optional): " USER_PHONE
    
    echo ""
    echo "🎨 Agent Personality"
    echo "1) Professional & Efficient (default)"
    echo "2) Friendly & Casual"
    echo "3) Direct & No-Nonsense"
    echo "4) Custom (edit later)"
    read -p "Choose personality [1-4]: " PERSONALITY_CHOICE
    
    case $PERSONALITY_CHOICE in
        2) PERSONALITY="friendly" ;;
        3) PERSONALITY="direct" ;;
        4) PERSONALITY="custom" ;;
        *) PERSONALITY="professional" ;;
    esac
}

# Choose messaging platform
choose_messaging() {
    echo ""
    echo "💬 Messaging Platform"
    echo "1) Telegram (recommended)"
    echo "2) Discord"
    echo "3) Signal"
    echo "4) WhatsApp"
    echo "5) Skip (configure later)"
    read -p "Choose platform [1-5]: " MSG_CHOICE
    
    case $MSG_CHOICE in
        1)
            MSG_PLATFORM="telegram"
            echo ""
            echo "🔑 Get your Telegram bot token:"
            echo "   1. Message @BotFather on Telegram"
            echo "   2. Send: /newbot"
            echo "   3. Follow prompts"
            echo "   4. Copy the token"
            echo ""
            read -p "Telegram Bot Token: " TELEGRAM_TOKEN
            read -p "Your Telegram User ID: " TELEGRAM_USER_ID
            ;;
        2)
            MSG_PLATFORM="discord"
            read -p "Discord Bot Token: " DISCORD_TOKEN
            ;;
        3)
            MSG_PLATFORM="signal"
            read -p "Signal Phone Number: " SIGNAL_NUMBER
            ;;
        4)
            MSG_PLATFORM="whatsapp"
            read -p "WhatsApp Business API Key: " WHATSAPP_KEY
            ;;
        *)
            MSG_PLATFORM="none"
            ;;
    esac
}

# Choose AI provider
choose_ai_provider() {
    echo ""
    echo "🧠 AI Provider"
    echo "1) Anthropic Claude (recommended)"
    echo "2) OpenAI GPT-4"
    echo "3) Local (Ollama)"
    echo "4) Configure later"
    read -p "Choose AI provider [1-4]: " AI_CHOICE
    
    case $AI_CHOICE in
        1)
            AI_PROVIDER="anthropic"
            read -p "Anthropic API Key: " AI_API_KEY
            AI_MODEL="anthropic/claude-sonnet-4"
            ;;
        2)
            AI_PROVIDER="openai"
            read -p "OpenAI API Key: " AI_API_KEY
            AI_MODEL="openai/gpt-4"
            ;;
        3)
            AI_PROVIDER="ollama"
            AI_API_KEY="none"
            AI_MODEL="ollama/llama3:8b"
            echo "ℹ️  Make sure Ollama is running: ollama serve"
            ;;
        *)
            AI_PROVIDER="none"
            AI_API_KEY="configure-later"
            AI_MODEL="none"
            ;;
    esac
}

# Optional integrations
configure_integrations() {
    echo ""
    echo "🔌 Optional Integrations"
    echo ""
    
    read -p "Enable AI Voice Calling? (y/n): " VOICE_ENABLED
    if [ "$VOICE_ENABLED" = "y" ]; then
        read -p "Vapi.ai API Key: " VAPI_KEY
    else
        VAPI_KEY=""
    fi
    
    read -p "Enable Email Campaigns? (y/n): " EMAIL_ENABLED
    if [ "$EMAIL_ENABLED" = "y" ]; then
        read -p "SendGrid API Key: " SENDGRID_KEY
    else
        SENDGRID_KEY=""
    fi
    
    read -p "Enable SMS Messaging? (y/n): " SMS_ENABLED
    if [ "$SMS_ENABLED" = "y" ]; then
        read -p "Twilio Account SID: " TWILIO_SID
        read -p "Twilio Auth Token: " TWILIO_TOKEN
    else
        TWILIO_SID=""
        TWILIO_TOKEN=""
    fi
}

# Install OpenClaw
install_openclaw() {
    echo ""
    echo "📦 Installing OpenClaw..."
    
    if command -v openclaw &> /dev/null; then
        echo "✅ OpenClaw already installed"
    else
        pnpm add -g openclaw
        echo "✅ OpenClaw installed"
    fi
}

# Create workspace structure
create_workspace() {
    echo ""
    echo "📁 Creating workspace..."
    
    WORKSPACE_DIR="$HOME/.openclaw/workspace"
    mkdir -p "$WORKSPACE_DIR"
    mkdir -p "$WORKSPACE_DIR/memory"
    mkdir -p "$WORKSPACE_DIR/scripts"
    mkdir -p "$WORKSPACE_DIR/agents"
    
    # Copy template files
    cp -r ./workspace-template/* "$WORKSPACE_DIR/" 2>/dev/null || true
    
    echo "✅ Workspace created at $WORKSPACE_DIR"
}

# Generate configuration
generate_config() {
    echo ""
    echo "⚙️  Generating configuration..."
    
    CONFIG_DIR="$HOME/.openclaw"
    mkdir -p "$CONFIG_DIR"
    
    cat > "$CONFIG_DIR/openclaw.json" <<EOF
{
  "version": "1.0.0",
  "model": "$AI_MODEL",
  "thinking": "low",
  "channels": {
    "$MSG_PLATFORM": {
      "enabled": true,
      "token": "$TELEGRAM_TOKEN",
      "allowedUsers": ["$TELEGRAM_USER_ID"]
    }
  },
  "integrations": {
    "vapi": {
      "enabled": $([ -n "$VAPI_KEY" ] && echo "true" || echo "false"),
      "apiKey": "$VAPI_KEY"
    },
    "sendgrid": {
      "enabled": $([ -n "$SENDGRID_KEY" ] && echo "true" || echo "false"),
      "apiKey": "$SENDGRID_KEY"
    },
    "twilio": {
      "enabled": $([ -n "$TWILIO_SID" ] && echo "true" || echo "false"),
      "accountSid": "$TWILIO_SID",
      "authToken": "$TWILIO_TOKEN"
    }
  },
  "workspace": "$WORKSPACE_DIR",
  "memory": {
    "enabled": true,
    "searchProvider": "local"
  }
}
EOF
    
    echo "✅ Configuration saved to $CONFIG_DIR/openclaw.json"
}

# Customize workspace files
customize_workspace() {
    echo ""
    echo "✏️  Customizing workspace..."
    
    WORKSPACE_DIR="$HOME/.openclaw/workspace"
    
    # USER.md
    cat > "$WORKSPACE_DIR/USER.md" <<EOF
# USER.md - About Your Human

- **Name:** $USER_NAME
- **What to call them:** $USER_NICKNAME
- **Timezone:** $USER_TIMEZONE
- **Email:** $USER_EMAIL
- **Phone:** $USER_PHONE

## Context

*Add information about yourself here - your work, preferences, habits, etc.*

---

The more you share, the better your agent can help you.
EOF
    
    # SOUL.md (personality)
    case $PERSONALITY in
        friendly)
            SOUL_CONTENT="Be warm and friendly. Use casual language. Emoji are okay. Make jokes when appropriate."
            ;;
        direct)
            SOUL_CONTENT="Be direct and efficient. No fluff, no filler. Get to the point. Action over words."
            ;;
        custom)
            SOUL_CONTENT="*Edit this file to define your agent's personality*"
            ;;
        *)
            SOUL_CONTENT="Be professional and helpful. Skip unnecessary pleasantries. Be proactive and anticipate needs."
            ;;
    esac
    
    cat > "$WORKSPACE_DIR/SOUL.md" <<EOF
# SOUL.md - Who You Are

$SOUL_CONTENT

## Core Truths

- Be genuinely helpful, not performatively helpful
- Have opinions when appropriate
- Be resourceful before asking
- Remember you're trusted with personal access

## Boundaries

- Private things stay private
- Ask before external actions (emails, posts, etc.)
- Be careful in group chats (you're a participant, not their voice)

---

*This is your personality. Update it as you learn who you want to be.*
EOF
    
    echo "✅ Workspace customized"
}

# Create systemd service
create_service() {
    echo ""
    read -p "Create systemd service (run agent 24/7)? (y/n): " CREATE_SERVICE
    
    if [ "$CREATE_SERVICE" != "y" ]; then
        echo "⏭️  Skipped service creation"
        return
    fi
    
    sudo tee /etc/systemd/system/openclaw-agent.service > /dev/null <<EOF
[Unit]
Description=Strickland Agent (OpenClaw)
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME/.openclaw
ExecStart=$(which openclaw) gateway start
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
    
    sudo systemctl daemon-reload
    sudo systemctl enable openclaw-agent
    sudo systemctl start openclaw-agent
    
    echo "✅ Service created and started"
    echo "   Status: sudo systemctl status openclaw-agent"
    echo "   Logs: sudo journalctl -u openclaw-agent -f"
}

# Main setup flow
main() {
    clear
    
    check_prerequisites
    collect_user_info
    choose_messaging
    choose_ai_provider
    configure_integrations
    install_openclaw
    create_workspace
    generate_config
    customize_workspace
    create_service
    
    echo ""
    echo "🎉 Setup Complete!"
    echo "=================="
    echo ""
    echo "Your agent is ready!"
    echo ""
    echo "📁 Workspace: $HOME/.openclaw/workspace"
    echo "⚙️  Config: $HOME/.openclaw/openclaw.json"
    echo ""
    echo "🚀 Start your agent:"
    echo "   openclaw gateway start"
    echo ""
    echo "📖 Documentation:"
    echo "   https://docs.stricklandtechnology.net"
    echo ""
    echo "💬 Support:"
    echo "   Discord: https://discord.gg/strickland-tech"
    echo "   Email: support@stricklandtechnology.net"
    echo ""
}

main
