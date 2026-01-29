<div align="center">

# 🤖 Strickland AI Agent Starter

### Deploy Your AI Business Agent in Minutes

An open-source template for building autonomous AI business agents that make phone calls, send emails, run outreach campaigns, and remember everything — powered by [Moltbot](https://molt.bot).

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Built by Strickland AI](https://img.shields.io/badge/built%20by-Strickland%20AI-black)](https://stricklandai.com)

[Quickstart](#-60-second-quickstart) · [Architecture](#-architecture) · [Docs](docs/) · [Contributing](CONTRIBUTING.md)

</div>

---

## What This Does

This starter gives you a fully operational AI agent that runs 24/7 as your business operator:

| Capability | Description |
|---|---|
| **📞 Voice Calls** | Inbound/outbound calls via Telnyx with neural TTS voices. Your agent answers the phone, has real conversations, takes notes. |
| **📧 Email** | Reads inbox, drafts responses, sends outreach. Connects to any IMAP provider + API-based sending. |
| **📱 WhatsApp** | Full WhatsApp Business integration. Your agent lives in your pocket. |
| **🧠 Memory** | Daily logs + long-term curated memory. Your agent remembers every conversation, every decision, every follow-up. |
| **👤 Personality** | Define your agent's soul — tone, values, expertise, boundaries. It's not a chatbot. It's *your* operator. |
| **🔄 Heartbeat** | Proactive background checks — email, calendar, follow-ups, weather. Your agent works while you sleep. |
| **📊 Outreach** | Automated campaign sequences with follow-up tracking, lead scoring, and CRM-style pipeline management. |

## 🚀 60-Second Quickstart

```bash
# 1. Clone the repo
git clone https://github.com/stricklandai/agent-starter.git
cd agent-starter

# 2. Run setup
chmod +x scripts/setup.sh
./scripts/setup.sh

# 3. Edit your agent's personality
nano templates/SOUL.md

# 4. Add your API keys to config
cp config/example-config.json config/config.json
nano config/config.json

# 5. Start your agent
moltbot start
```

That's it. Your agent is live.

For the full walkthrough, see [Getting Started](docs/getting-started.md).

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    YOUR AI AGENT                         │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  SOUL.md  │  │  USER.md  │  │ MEMORY.md│              │
│  │ (who am I)│  │ (who do I │  │ (what do │              │
│  │           │  │  serve?)  │  │ I know?) │              │
│  └─────┬─────┘  └─────┬─────┘  └─────┬────┘              │
│        └───────────┬───┘──────────────┘                  │
│                    ▼                                     │
│  ┌─────────────────────────────────────┐                 │
│  │         MOLTBOT GATEWAY             │                 │
│  │   (Agent Loop + LLM Orchestration)  │                 │
│  └──────────┬──────────────────────────┘                 │
│             │                                            │
│  ┌──────────┼──────────────────────────┐                 │
│  │          ▼          ▼          ▼    │                 │
│  │  ┌────────────┐┌────────┐┌────────┐│                 │
│  │  │  Voice Call ││ Email  ││WhatsApp││  ← Channels     │
│  │  │  (Telnyx)  ││ (IMAP) ││ (WA)   ││                 │
│  │  └────────────┘└────────┘└────────┘│                 │
│  └─────────────────────────────────────┘                 │
│                                                          │
│  ┌─────────────────────────────────────┐                 │
│  │         HEARTBEAT ENGINE            │                 │
│  │  Email checks · Calendar · CRM      │  ← Proactive   │
│  │  Follow-ups · Weather · Alerts      │                 │
│  └─────────────────────────────────────┘                 │
│                                                          │
│  ┌─────────────────────────────────────┐                 │
│  │         MEMORY SYSTEM               │                 │
│  │  Daily logs → Long-term memory      │  ← Persistent  │
│  │  memory/YYYY-MM-DD.md + MEMORY.md   │                 │
│  └─────────────────────────────────────┘                 │
└─────────────────────────────────────────────────────────┘
```

## 📁 Repository Structure

```
strickland-agent-starter/
├── README.md                    # You are here
├── LICENSE                      # MIT
├── CONTRIBUTING.md              # How to contribute
├── .gitignore
├── templates/
│   ├── SOUL.md                  # Agent personality template
│   ├── AGENTS.md                # Workspace configuration
│   ├── USER.md                  # Human profile template
│   └── HEARTBEAT.md             # Proactive checks config
├── config/
│   ├── example-config.json      # Moltbot configuration
│   └── config-guide.md          # Every option explained
├── workflows/
│   ├── outreach-automation.md   # Email campaigns & sequences
│   ├── voice-agent-twilio.md    # Phone call setup (Twilio — recommended)
│   ├── voice-agent.md           # Phone call setup (Telnyx — alternative)
│   └── email-integration.md     # Email read/send setup
├── scripts/
│   ├── setup.sh                 # One-command setup
│   └── deploy-voice.sh          # Voice webhook deployment
└── docs/
    ├── getting-started.md       # Full setup walkthrough
    └── architecture.md          # How everything works
```

## 📸 Screenshots

> *Coming soon — screenshots of agent conversations, voice call logs, and outreach dashboards.*

## Why Moltbot?

[Moltbot](https://molt.bot) is the runtime that powers this agent. It handles:

- **LLM orchestration** — Claude, GPT, or any model via API
- **Channel routing** — WhatsApp, voice, email, Discord, Telegram
- **Plugin system** — Voice calls, TTS, browser automation, calendar
- **Cron & heartbeat** — Scheduled tasks and proactive behavior
- **Memory management** — File-based persistence that survives restarts

Think of Moltbot as the operating system. This starter repo is the personality, config, and workflows that make it *your* agent.

## 🔒 Security

AI agents are powerful — and power requires responsibility. Recent security research has highlighted risks with self-hosted AI assistants. **This starter addresses those concerns head-on.**

### The Concerns (and Our Answers)

| Concern | Risk | This Starter's Approach |
|---------|------|------------------------|
| **Exposed admin ports** | Hundreds of instances found publicly accessible | Our config defaults to `localhost` binding only. Never expose port 18860 to the internet without VPN/tunnel + auth. |
| **Plaintext secrets** | API keys in Markdown/JSON files | Use environment variables or encrypted secret stores. Our `.gitignore` excludes all sensitive files. Never commit `config.json`. |
| **Reverse proxy misconfig** | Internet traffic treated as localhost (auto-auth bypass) | Enable `gateway.authToken` immediately. Don't rely on IP-based trust. |
| **Skill library poisoning** | Malicious skills on ClawdHub can execute code | We don't auto-install skills. Review any skill before adding. Pin versions. |
| **Prompt injection** | Malicious messages via WhatsApp/email trigger unintended actions | Configure `exec.security: "allowlist"` to restrict commands. Use `exec.ask: "always"` for destructive ops. |
| **Infostealer targeting** | Malware specifically hunting Moltbot directories | Run your agent in a dedicated VM or container. Don't run on your primary workstation with banking sessions. |

### Security Checklist

Before going live, verify:

```bash
# ✅ Auth token is set (not empty)
grep -q '"authToken":' config/config.json && echo "Auth configured"

# ✅ Gateway binds to localhost only
grep -q '"host": "127.0.0.1"' config/config.json && echo "Localhost only"

# ✅ Exec restricted to allowlist
grep -q '"security": "allowlist"' config/config.json && echo "Exec restricted"

# ✅ No secrets in git
git status --porcelain | grep -v '^\?\?' | grep -E '\.(json|env)$' && echo "WARNING: secrets may be staged"
```

### Deployment Best Practices

1. **Isolate your agent** — Dedicated VM, VPS, or Mac Mini. Not your daily driver.
2. **Use a VPN/tunnel** — If remote access needed, use Tailscale/WireGuard, not port forwarding.
3. **Enable auth immediately** — Set `gateway.authToken` before first boot.
4. **Restrict exec** — Use `allowlist` mode, enumerate safe commands explicitly.
5. **Monitor logs** — Watch for unexpected command execution or outbound connections.
6. **Rotate credentials** — If you suspect exposure, rotate all API keys immediately.
7. **Backup memory** — Your agent's memory is valuable. Backup `memory/` and `MEMORY.md` regularly.

### What We Don't Do

- ❌ Auto-install skills from the internet
- ❌ Store secrets in plaintext by default (use env vars)
- ❌ Expose admin ports publicly
- ❌ Trust "localhost" through reverse proxies without verification
- ❌ Allow unrestricted shell execution

Security is a feature, not an afterthought. For detailed hardening, see [docs/security.md](docs/security.md).

## Use Cases

- **Sales teams** — Automated outreach sequences with AI follow-ups
- **Founders** — A chief of staff that manages your inbox and calendar
- **Agencies** — White-label AI agents for clients
- **Support** — Inbound call handling with memory and escalation
- **Personal** — An assistant that actually knows you

## Built by Strickland AI

[Strickland AI](https://stricklandai.com) builds autonomous AI agents for businesses. This starter is extracted from our production systems — the same architecture that handles real phone calls, real email campaigns, and real revenue.

We open-sourced it because the agent space needs fewer demos and more operators.

**Links:**
- 🌐 [stricklandai.com](https://stricklandai.com)
- 🤖 [molt.bot](https://molt.bot) — The Moltbot runtime
- 🐦 [@staboratory](https://x.com/staboratory)

## License

MIT — do whatever you want with it. See [LICENSE](LICENSE).

---

<div align="center">

**Built by operators, for operators.**

[⭐ Star this repo](https://github.com/stricklandai/agent-starter) if you ship an agent with it.

</div>
