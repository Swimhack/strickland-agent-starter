# Configuration Guide

A line-by-line explanation of `example-config.json`. Copy it to `config.json` and fill in your values.

## Gateway

```json
"gateway": {
  "port": 3456,        // Port the Moltbot gateway listens on
  "host": "0.0.0.0",   // Bind address (0.0.0.0 = all interfaces)
  "auth": {
    "token": "..."     // Shared secret for authenticating API requests to the gateway
  }
}
```

Generate a secure token: `openssl rand -hex 32`

## Agent

```json
"agent": {
  "name": "agent",                              // Agent identifier
  "model": "anthropic/claude-sonnet-4-20250514",     // Default LLM for conversations
  "defaultModel": "anthropic/claude-sonnet-4-20250514", // Fallback model
  "thinkingModel": "anthropic/claude-opus-4-5", // Model for complex reasoning tasks
  "workspace": "./workspace",                    // Path to agent workspace (where SOUL.md etc. live)
  "contextFiles": ["AGENTS.md", "TOOLS.md"],     // Files loaded into context every session
  "maxTokens": 8192,                             // Max response tokens
  "temperature": 0.7                             // Creativity (0.0 = deterministic, 1.0 = creative)
}
```

**Model choice:** Sonnet is the best balance of speed/cost/quality for daily work. Use Opus for complex analysis via `thinkingModel`.

## Channels

### WhatsApp

```json
"whatsapp": {
  "enabled": true,
  "provider": "whatsapp-web",          // Uses WhatsApp Web protocol
  "sessionPath": "./data/whatsapp-session", // QR code session persistence
  "allowedNumbers": ["..."],           // Phone numbers allowed to chat (E.164 format)
  "defaultTarget": "..."              // Where proactive messages go
}
```

On first run, you'll scan a QR code to link your WhatsApp. The session persists in `sessionPath`.

## Plugins

### Voice Call (Telnyx)

```json
"voice-call": {
  "provider": "telnyx",
  "apiKey": "...",                     // From Telnyx portal → API Keys
  "connectionId": "...",              // Telnyx SIP connection ID
  "phoneNumber": "+1...",            // Your Telnyx number
  "webhookUrl": "https://...",       // Public URL for call events (use ngrok for dev)
  "tts": {                           // Text-to-speech for the agent's voice
    "provider": "elevenlabs",
    "apiKey": "...",
    "voiceId": "...",                // Clone your voice or pick from ElevenLabs library
    "model": "eleven_turbo_v2_5"     // Lowest latency model
  },
  "stt": {                           // Speech-to-text for understanding callers
    "provider": "deepgram",
    "apiKey": "...",
    "model": "nova-2"               // Best accuracy/speed balance
  },
  "conversation": {
    "mode": "conversation",          // "conversation" for back-and-forth, "notify" for one-way
    "maxDurationSeconds": 600,       // 10-minute call limit
    "silenceTimeoutMs": 2000,        // How long to wait before assuming caller is done speaking
    "greeting": "..."               // First thing the agent says when answering
  }
}
```

See [Voice Agent Workflow](../workflows/voice-agent.md) for full setup.

### TTS (Text-to-Speech)

```json
"tts": {
  "provider": "elevenlabs",
  "apiKey": "...",
  "voiceId": "...",
  "model": "eleven_turbo_v2_5"      // Use turbo for real-time, multilingual_v2 for quality
}
```

Used for sending voice messages on WhatsApp and other channels.

### Email

```json
"email": {
  "imap": {                          // For READING emails
    "host": "imap.provider.com",
    "port": 993,                     // Standard IMAPS port
    "user": "you@domain.com",
    "password": "..."               // App password, not your login password
  },
  "send": {                          // For SENDING emails
    "method": "api",                 // "api" or "smtp" (api recommended — SMTP ports often blocked on VPS)
    "provider": "...",
    "apiKey": "...",
    "fromAddress": "you@domain.com",
    "fromName": "Your Name"
  }
}
```

See [Email Integration Workflow](../workflows/email-integration.md) for provider-specific setup.

### Browser

```json
"browser": {
  "enabled": true,
  "headless": true                   // true for servers, false for local debugging
}
```

Gives the agent web browsing capability for research, form filling, etc.

### Calendar

```json
"calendar": {
  "provider": "google",
  "credentialsPath": "...",          // Google OAuth credentials JSON
  "calendarId": "..."               // Usually your email address
}
```

## Cron Jobs

```json
"cron": {
  "heartbeat": {
    "schedule": "*/30 * * * *",      // Every 30 minutes (cron syntax)
    "prompt": "...",                  // What to tell the agent each heartbeat
    "channel": "whatsapp"            // Where to send output
  },
  "morning-briefing": {
    "schedule": "0 8 * * 1-5",       // 8am, Monday-Friday
    "prompt": "...",
    "channel": "whatsapp",
    "model": "..."                   // Override model for this job
  }
}
```

**Cron syntax:** `minute hour day-of-month month day-of-week`
- `*/30 * * * *` = every 30 minutes
- `0 8 * * 1-5` = 8:00am weekdays
- `0 9 * * 1` = 9:00am Mondays

## LLM Providers

```json
"llm": {
  "anthropic": { "apiKey": "..." },  // Get from console.anthropic.com
  "openai": { "apiKey": "..." }      // Get from platform.openai.com (optional)
}
```

You need at least one provider. Anthropic is recommended for the best agent behavior.

## Security

```json
"security": {
  "allowedUsers": ["..."],           // User IDs that can interact with the agent
  "rateLimiting": {
    "maxRequestsPerMinute": 30,      // Prevent runaway loops
    "maxTokensPerHour": 500000       // Cost control
  }
}
```

Always set rate limits in production. A misconfigured heartbeat can burn through API credits fast.
