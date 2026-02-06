# Changelog

All notable changes to Strickland Agent Starter will be documented in this file.

## [2.0.0] - 2026-02-06

### 🎉 Complete Rewrite - Voice-First Agent Framework

This is a **complete architectural rewrite** transforming Strickland Agent Starter from a generic framework into a production-ready, voice-enabled AI agent platform.

### ✨ What's New

#### Core Features
- **📞 AI Voice Calling Skill** - Complete Vapi.ai integration for outbound voice agents
- **🚀 One-Command Setup** - Automated `setup.sh` script handles entire installation
- **📦 Production Ready** - Turnkey deployment with systemd service support
- **🎨 Commercial Product** - Professional documentation and commercial licensing ($499)

#### New Structure
```
strickland-agent-starter/
├── README.md              # Complete product documentation (8.8K)
├── setup.sh               # Automated installation script (9.9K)
├── package.json           # NPM manifest with proper dependencies
├── workspace-template/    # Agent workspace templates
│   └── AGENTS.md         # Operating manual
├── skills/
│   └── voice-calling/    # Vapi voice agent skill
│       ├── SKILL.md      # Complete voice calling documentation
│       └── scripts/
│           └── make-call.js  # Voice calling implementation
├── .gitignore
└── LICENSE
```

### 🔥 Breaking Changes

**Complete structural overhaul from v1.x:**

#### Removed (v1.x → v2.0)
- ❌ `config/` directory - Now handled by OpenClaw Gateway
- ❌ `docs/` directory - Consolidated into README and SKILL docs
- ❌ `scripts/deploy-voice.sh` - Replaced by `setup.sh`
- ❌ `templates/HEARTBEAT.md` - Moved to workspace management
- ❌ `workflows/` directory - Replaced by skills system
- ❌ Generic setup scripts - Replaced by production `setup.sh`

#### Added (v2.0)
- ✅ `setup.sh` - Complete automated installation
- ✅ `skills/voice-calling/` - Full Vapi integration with docs
- ✅ `workspace-template/` - Clean workspace structure
- ✅ `package.json` - Proper NPM package definition
- ✅ Commercial licensing and pricing documentation

### 📖 Documentation

#### New Documentation
- **README.md** - Complete product documentation:
  - Feature overview with use cases
  - Quick start guide (5 minutes to running agent)
  - Commercial licensing and pricing
  - Comparison with alternatives (ChatGPT, Zapier, etc.)
  - Production deployment guides
  - Roadmap and future features

- **skills/voice-calling/SKILL.md** - Complete voice agent guide:
  - Vapi.ai setup and configuration
  - Creating custom AI personas
  - Making outbound calls
  - Call tracking and analytics
  - Pricing and compliance
  - Troubleshooting

### 🎯 Migration Guide

**Migrating from v1.x:**

This is a complete rewrite. We recommend:

1. **Archive your v1.x installation**
   ```bash
   cd your-v1-installation
   git checkout v1-archive  # Old version preserved
   ```

2. **Fresh v2.0 installation**
   ```bash
   git clone https://github.com/Swimhack/strickland-agent-starter.git
   cd strickland-agent-starter
   ./setup.sh
   ```

3. **Migrate your data**
   - Copy `workspace/SOUL.md` (agent personality)
   - Copy `workspace/USER.md` (your information)
   - Copy `workspace/MEMORY.md` (long-term memory)
   - Copy `workspace/memory/` logs (historical context)

4. **Configure integrations**
   - Add API keys via `setup.sh` prompts or edit `~/.openclaw/openclaw.json`
   - Voice calling requires Vapi.ai API key

### 🛡️ Security

- ✅ No hardcoded API keys (user-provided via setup or config)
- ✅ Improved `.gitignore` to prevent credential leaks
- ✅ Clean separation of code and secrets

### 📊 Product Positioning

**v1.x:** Generic AI agent framework  
**v2.0:** Commercial voice-enabled AI agent platform

**New Value Propositions:**
- "Like JARVIS, but yours to own"
- Voice calling as first-class feature
- Production-ready with professional support
- Commercial licensing for business use

### 🎨 Technical Improvements

- **Simplified Dependencies** - Only OpenClaw core required
- **Better Error Handling** - Setup script validates prerequisites
- **Automated Installation** - One command from clone to running agent
- **Systemd Integration** - Production service management
- **Docker Support** - Container deployment documented

### 🚀 Getting Started

```bash
git clone https://github.com/Swimhack/strickland-agent-starter.git
cd strickland-agent-starter
./setup.sh
```

### 📝 License

- **Personal Use:** MIT License (free, open source)
- **Commercial Use:** $499 one-time license required

---

## [1.x] - Legacy Version

Previous releases are archived in the `v1-archive` branch.

**v1.x Features:**
- Basic agent framework
- Generic workflow documentation
- Multiple integration examples

**Migration:** See v2.0.0 migration guide above.

---

## Version History

- **v2.0.0** (2026-02-06) - Complete rewrite with voice calling
- **v1.x** (2026-01-xx) - Original framework (archived)

---

**For support:** support@stricklandtechnology.net  
**For updates:** https://github.com/Swimhack/strickland-agent-starter
