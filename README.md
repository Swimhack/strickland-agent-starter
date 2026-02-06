# 🤖 Strickland Agent Starter

**Your personal AI agent - like JARVIS, but yours to own.**

Built on OpenClaw. Runs on your own infrastructure. 100% private.

---

## 🎯 What Is This?

**Strickland Agent Starter** is a turnkey AI agent framework that gives you a personal assistant like JARVIS from Iron Man. It runs on your own server, connects to your accounts, and helps you with everything from emails to calendars to business automation.

**Think of it as:**
- Your personal AI assistant that never sleeps
- Proactive (checks things for you, reminds you, takes action)
- Private (your data never leaves your server)
- Extensible (add skills and integrations easily)

---

## ✨ Features

### Core Capabilities
- 🧠 **Persistent Memory** - Remembers conversations, decisions, context
- 💬 **Multi-Platform Messaging** - Telegram, Discord, Signal, WhatsApp
- 📧 **Email Management** - Read, send, organize (Gmail, Outlook, Zoho)
- 📅 **Calendar Integration** - Track events, set reminders
- 🌐 **Web Research** - Search, fetch content, monitor sites
- 📝 **File Management** - Read, write, organize your documents
- ⚡ **Automation** - Cron jobs, webhooks, background tasks

### Advanced Features (New!)
- 📞 **AI Voice Calling** - Make and receive calls with custom AI personas
- 💼 **Sales Outreach** - Automated voice/email/SMS campaigns (optional)
- 🎙️ **Custom Voice Agents** - Create AI agents with any personality
- 📊 **CRM Integration** - Track leads and touchpoints
- 🤖 **Sub-Agents** - Spawn background tasks with isolated context

---

## 🚀 Quick Start

### Prerequisites
- Ubuntu/Debian VPS (4GB+ RAM recommended)
- Node.js 18+
- Basic command line knowledge

### Installation

```bash
# Clone the starter
git clone https://github.com/stricklandtechnology/agent-starter.git
cd agent-starter

# Run setup script
./setup.sh

# Follow prompts to configure:
# - Your name and timezone
# - Messaging platform (Telegram/Discord/etc.)
# - AI provider (OpenAI, Anthropic, local)
# - Optional integrations (email, calendar, voice)
```

**That's it!** Your agent is running.

---

## 📦 What's Included

### Core Files
```
agent-starter/
├── workspace/              # Your agent's workspace
│   ├── AGENTS.md          # How your agent operates
│   ├── SOUL.md            # Your agent's personality
│   ├── USER.md            # About you
│   ├── MEMORY.md          # Long-term memory
│   ├── HEARTBEAT.md       # Proactive tasks
│   └── memory/            # Daily logs
├── skills/                # Extensible skills
│   ├── voice-calling/     # AI voice agent skill
│   ├── email-outreach/    # Email campaign skill
│   ├── weather/           # Weather reports
│   └── tmux/              # Terminal control
├── config/
│   └── openclaw.json      # Agent configuration
└── setup.sh               # One-click setup
```

### Pre-Built Skills
- **Voice Calling** (Vapi.ai integration)
- **Email Campaigns** (SendGrid/Postmark)
- **SMS Messaging** (Twilio)
- **Weather** (wttr.in)
- **Terminal Control** (tmux)
- **Web Research** (Brave Search)

---

## 🎨 Customization

### Change Your Agent's Personality

Edit `workspace/SOUL.md`:

```markdown
# SOUL.md - Who You Are

Be direct and efficient. Skip the fluff.
When you don't know something, say so.
Be proactive - anticipate what I need.
```

### Add Your Context

Edit `workspace/USER.md`:

```markdown
# USER.md - About Your Human

- **Name:** Your Name
- **Timezone:** America/Chicago
- **Work:** What you do
- **Preferences:** How you like to communicate
```

### Configure Integrations

Edit `config/openclaw.json`:

```json
{
  "model": "anthropic/claude-sonnet-4",
  "skills": ["voice-calling", "email-outreach"],
  "integrations": {
    "telegram": { "enabled": true, "token": "YOUR_TOKEN" },
    "vapi": { "enabled": true, "apiKey": "YOUR_KEY" }
  }
}
```

---

## 🔌 Optional Add-Ons

### Voice Calling Setup

1. Get Vapi.ai API key: https://vapi.ai
2. Add to config:
```json
{
  "integrations": {
    "vapi": {
      "enabled": true,
      "apiKey": "YOUR_VAPI_KEY"
    }
  }
}
```
3. Tell your agent: *"Create a voice agent named Sarah"*

### Email Campaigns

1. Get SendGrid API key: https://sendgrid.com
2. Add to config:
```json
{
  "integrations": {
    "sendgrid": {
      "enabled": true,
      "apiKey": "YOUR_KEY",
      "fromEmail": "you@yourdomain.com"
    }
  }
}
```
3. Tell your agent: *"Send an email campaign to my lead list"*

### Business Automation (Outreach Engine)

Want full multi-tenant SaaS capabilities?

**Option 1:** DIY (for developers)
- Deploy Strickland Outreach Engine yourself
- Connect via API
- Full control, but more setup

**Option 2:** Hosted (coming soon)
- We host and manage everything
- $99/month add-on to your agent
- Zero setup, just enable and go

---

## 💰 Pricing

**Strickland Agent Starter:**
- **Personal Use:** FREE (open source, self-hosted)
- **Commercial License:** $499 one-time (if reselling/white-label)

**Optional Add-Ons:**
- **Hosted Outreach Engine:** $99/month (multi-tenant sales automation)
- **Priority Support:** $49/month
- **Custom Skills:** $299 one-time per skill

---

## 🛡️ Privacy & Security

**Your Data, Your Server:**
- ✅ Runs on your own VPS (we never see your data)
- ✅ API keys stored locally (encrypted)
- ✅ Open source (audit the code yourself)
- ✅ No telemetry, no tracking, no backdoors

**API Keys You Control:**
- Vapi.ai (voice calling)
- SendGrid/Postmark (email)
- Twilio (SMS)
- Anthropic/OpenAI (AI models)

**We never store your API keys or personal data.**

---

## 📖 Documentation

- **Getting Started:** `docs/quickstart.md`
- **Configuration:** `docs/configuration.md`
- **Skills Guide:** `docs/skills.md`
- **API Reference:** `docs/api.md`
- **Troubleshooting:** `docs/troubleshooting.md`

---

## 🤝 Community

- **Discord:** https://discord.gg/strickland-tech
- **GitHub:** https://github.com/stricklandtechnology/agent-starter
- **Docs:** https://docs.stricklandtechnology.net
- **Email:** support@stricklandtechnology.net

---

## 🚀 Use Cases

### Personal Assistant
- Check emails, calendar, weather
- Set reminders and take notes
- Research topics and summarize content
- Automate daily tasks

### Business Automation
- Make AI voice calls to leads
- Send personalized email campaigns
- Track conversations in CRM
- Generate reports and insights

### Developer Productivity
- Control terminal sessions
- Deploy code automatically
- Monitor servers and services
- Run tests and CI/CD pipelines

### Content Creation
- Research and compile information
- Draft emails and documents
- Generate social media posts
- Summarize articles and videos

---

## 🔧 Advanced

### Create Custom Skills

```bash
cd skills
mkdir my-skill
cd my-skill
touch SKILL.md script.js
```

**SKILL.md:**
```markdown
# My Custom Skill

**Description:** What this skill does

**Usage:** How to invoke it

**Requirements:** APIs or dependencies needed
```

**script.js:**
```javascript
#!/usr/bin/env node
// Your skill logic here
console.log('Skill executed!');
```

### Deploy to Production

```bash
# Install as systemd service
sudo cp agent-starter.service /etc/systemd/system/
sudo systemctl enable agent-starter
sudo systemctl start agent-starter

# Monitor logs
sudo journalctl -u agent-starter -f
```

### Scale with Docker

```bash
# Build container
docker build -t strickland-agent .

# Run
docker run -d \
  -v ./workspace:/app/workspace \
  -v ./config:/app/config \
  --name my-agent \
  strickland-agent
```

---

## 📊 Comparison

**vs. ChatGPT:**
- ✅ Persistent memory
- ✅ Proactive (not reactive)
- ✅ Connects to your accounts
- ✅ 100% private (your server)

**vs. Custom AI Agent:**
- ✅ Turnkey (no coding required)
- ✅ Pre-built skills included
- ✅ Production-ready
- ✅ Community support

**vs. Zapier/n8n:**
- ✅ Conversational interface
- ✅ AI-powered decision making
- ✅ Multi-channel (not just workflows)
- ✅ Learning and adaptation

---

## 🎯 Roadmap

**v1.0 (Current):**
- ✅ Core agent framework
- ✅ Multi-platform messaging
- ✅ Memory and context
- ✅ Basic skills (weather, web, files)

**v1.5 (Next Month):**
- ⏳ Voice calling skill (Vapi integration)
- ⏳ Email campaign skill
- ⏳ CRM integration skill
- ⏳ One-click deploy to Fly.io

**v2.0 (Q2 2026):**
- 📋 Visual skill builder (no-code)
- 📋 Mobile app (iOS/Android)
- 📋 Team collaboration (multi-user)
- 📋 Marketplace (buy/sell skills)

---

## 📝 License

**MIT License** (for personal use)

**Commercial License Required** for:
- Reselling as a service
- White-labeling
- Including in paid products

Contact: licensing@stricklandtechnology.net

---

## 🙏 Credits

Built by **Strickland Technology**  
Powered by **OpenClaw**  
Inspired by **JARVIS** (Iron Man)

---

**Turn your server into your personal AI assistant. Get started in 5 minutes.**

```bash
curl -sSL https://get.stricklandagent.com | bash
```

🚀 **Let's go.**
