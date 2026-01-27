# Getting Started

A complete walkthrough from zero to a running AI business agent.

## Prerequisites

| Tool | Required | Purpose |
|------|----------|---------|
| **Node.js** ≥ 18 | Yes | Runtime for Moltbot |
| **npm** | Yes | Package management |
| **git** | Yes | Version control |
| **Moltbot** | Yes | Agent runtime ([molt.bot](https://molt.bot)) |
| **Anthropic API key** | Yes | LLM provider (Claude) |
| **ngrok** | For voice | Tunneling for webhook development |

### Install Moltbot

```bash
npm install -g moltbot
# or
npx moltbot --help
```

Visit [molt.bot](https://molt.bot) for detailed installation instructions.

### Get an Anthropic API Key

1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Create an account and add billing
3. Generate an API key
4. Keep it handy — you'll need it during setup

## Installation

### 1. Clone the Starter

```bash
git clone https://github.com/stricklandai/agent-starter.git
cd agent-starter
```

### 2. Run Setup

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

This will:
- Check that Node.js, npm, and git are installed
- Create the workspace directory structure
- Copy templates (SOUL.md, AGENTS.md, USER.md, HEARTBEAT.md) into your workspace
- Create a config.json from the example
- Optionally prompt for API keys

### 3. Define Your Agent

Edit `workspace/SOUL.md` — this is the most important file. It defines:
- Your agent's name and role
- Personality and communication style
- Expertise and boundaries
- Voice and phone behavior

Take your time here. A well-defined SOUL.md is the difference between a generic chatbot and an agent that actually feels like a team member.

### 4. Define Yourself

Edit `workspace/USER.md` with:
- Your name, role, company
- Communication preferences
- Current priorities
- Key contacts
- Schedule preferences

This helps your agent make better decisions about what matters and how to represent you.

### 5. Configure API Keys

Edit `config/config.json` and replace all `YOUR_*_HERE` placeholders with real values.

At minimum, you need:
- `llm.anthropic.apiKey` — your Anthropic API key

For full functionality, also set up:
- WhatsApp (phone number)
- Voice (Telnyx + ElevenLabs + Deepgram)
- Email (IMAP + sending method)

See [config-guide.md](../config/config-guide.md) for every option explained.

### 6. Start Your Agent

```bash
moltbot start
```

For WhatsApp, you'll be prompted to scan a QR code on first run. Open WhatsApp on your phone → Settings → Linked Devices → Link a Device → Scan the QR code.

## First Conversation

Once your agent is running, send it a message on WhatsApp:

> "Hey, what can you do?"

It should respond based on its SOUL.md personality, explaining its capabilities.

Try:
- "What's on my calendar today?"
- "Draft an email to [contact] about [topic]"
- "Remind me to follow up with [person] on Thursday"
- "Call [phone number] and [purpose]" (if voice is configured)

## Testing the Heartbeat

The heartbeat runs every 30 minutes by default. To test immediately:

```bash
moltbot eval "Read HEARTBEAT.md and run all checks. Report findings."
```

This triggers a one-off heartbeat check so you can see what your agent does proactively.

## Adding Voice (Optional)

If you want your agent to make and receive phone calls:

1. Follow the [Voice Agent Workflow](../workflows/voice-agent.md)
2. Run the deployment script:
   ```bash
   chmod +x scripts/deploy-voice.sh
   ./scripts/deploy-voice.sh
   ```
3. Test by calling your Telnyx number

## Adding Email (Optional)

To let your agent read and send emails:

1. Follow the [Email Integration Workflow](../workflows/email-integration.md)
2. Install Himalaya for IMAP access
3. Configure your email provider's API for sending
4. Add email checks to HEARTBEAT.md

## Setting Up Outreach (Optional)

For automated outreach campaigns:

1. Follow the [Outreach Automation Workflow](../workflows/outreach-automation.md)
2. Create your lead list and templates
3. Configure the outreach cron job
4. Monitor weekly reports

## Directory Structure After Setup

```
agent-starter/
├── config/
│   ├── config.json              ← Your live config (gitignored)
│   ├── example-config.json      ← Template
│   └── config-guide.md
├── workspace/
│   ├── SOUL.md                  ← Agent personality
│   ├── AGENTS.md                ← Workspace behavior
│   ├── USER.md                  ← Your profile
│   ├── HEARTBEAT.md             ← Proactive checks
│   ├── TOOLS.md                 ← Environment notes
│   ├── MEMORY.md                ← Long-term memory (auto-populated)
│   ├── memory/                  ← Daily logs (auto-populated)
│   └── data/                    ← Runtime data (sessions, etc.)
├── workflows/                   ← Setup guides
├── scripts/                     ← Automation scripts
└── docs/                        ← Documentation
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Agent doesn't respond | Check `moltbot status`, verify API key is set |
| WhatsApp QR won't scan | Delete `data/whatsapp-session/` and restart |
| Agent forgets things | Check that `memory/` directory exists and is writable |
| Heartbeat not firing | Verify cron config in config.json, check timezone |
| Voice calls fail | Run `deploy-voice.sh`, check ngrok is running |

## Next Steps

- **Customize SOUL.md** until your agent sounds exactly right
- **Set up email** for inbox monitoring and outreach
- **Add voice** for phone call capability
- **Build outreach sequences** for automated campaigns
- **Read the [architecture docs](architecture.md)** to understand what's happening under the hood
