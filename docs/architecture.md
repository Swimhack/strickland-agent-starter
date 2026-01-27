# Architecture

How the AI agent system works under the hood.

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        MOLTBOT                               │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │                    GATEWAY                              │  │
│  │  HTTP server · WebSocket · Plugin loader · Auth         │  │
│  └──────────┬─────────────────────────────────────────────┘  │
│             │                                                │
│  ┌──────────▼─────────────────────────────────────────────┐  │
│  │                  AGENT LOOP                             │  │
│  │                                                         │  │
│  │  1. Receive message (from any channel)                  │  │
│  │  2. Load context (SOUL.md, USER.md, memory, tools)      │  │
│  │  3. Send to LLM with full context                       │  │
│  │  4. Parse response (text + tool calls)                  │  │
│  │  5. Execute tool calls                                  │  │
│  │  6. Return response to channel                          │  │
│  │  7. Log to memory                                       │  │
│  └──────────┬─────────────────────────────────────────────┘  │
│             │                                                │
│  ┌──────────▼─────────────────────────────────────────────┐  │
│  │               CHANNELS & PLUGINS                        │  │
│  │                                                         │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────────┐ │  │
│  │  │ WhatsApp │ │  Voice   │ │  Email   │ │  Discord  │ │  │
│  │  │          │ │ (Telnyx) │ │  (IMAP)  │ │           │ │  │
│  │  └──────────┘ └──────────┘ └──────────┘ └───────────┘ │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────────┐ │  │
│  │  │   TTS    │ │ Browser  │ │ Calendar │ │   Cron    │ │  │
│  │  │(Eleven)  │ │(Chromium)│ │ (Google) │ │(Scheduler)│ │  │
│  │  └──────────┘ └──────────┘ └──────────┘ └───────────┘ │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │                  WORKSPACE (Files)                      │  │
│  │                                                         │  │
│  │  SOUL.md · USER.md · AGENTS.md · TOOLS.md               │  │
│  │  MEMORY.md · memory/ · HEARTBEAT.md                     │  │
│  └────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Core Concepts

### The Gateway

The Moltbot gateway is a long-running process that:
- Listens for incoming messages across all channels
- Manages plugin lifecycle (voice, TTS, browser, etc.)
- Routes messages to the agent loop
- Handles authentication and rate limiting
- Runs cron jobs on schedule

Think of it as the operating system kernel. It's always running, managing resources, and dispatching work.

### The Agent Loop

Every interaction follows the same cycle:

```
Message In → Load Context → LLM Call → Tool Execution → Response Out → Log
```

1. **Message arrives** from any channel (WhatsApp text, phone call audio, cron trigger)
2. **Context is assembled**: SOUL.md, USER.md, recent memory, conversation history, available tools
3. **LLM processes** the full context and generates a response, potentially with tool calls
4. **Tools execute**: read files, send emails, make API calls, browse the web
5. **Response returns** to the originating channel
6. **Memory logs** the interaction for future context

The agent loop is stateless between sessions. All persistence is file-based.

### The Memory System

Memory operates on two tiers:

**Tier 1: Daily Logs** (`memory/YYYY-MM-DD.md`)
- Raw notes from each day's interactions
- Created automatically by the agent
- Contains: conversations, decisions, action items, observations
- Ephemeral — older files can be archived or deleted

**Tier 2: Long-Term Memory** (`MEMORY.md`)
- Curated insights distilled from daily logs
- Updated during heartbeats
- Contains: key facts, lessons learned, important contacts, patterns
- Persistent — this is the agent's "real" memory

```
Daily interactions → Daily logs → Heartbeat review → Long-term memory
```

This mirrors how human memory works: you experience things (daily logs), sleep on them (heartbeat), and important stuff sticks (MEMORY.md).

### The Voice Pipeline

For phone calls, the pipeline adds real-time audio processing:

```
Phone Call ──► Telnyx (SIP) ──► Moltbot Gateway
                                      │
                    ┌─────────────────┤
                    ▼                 ▼
              Deepgram STT      Agent Loop
              (audio→text)    (think + respond)
                    │                 │
                    └────────►────────┘
                                      │
                                      ▼
                               ElevenLabs TTS
                              (text→audio)
                                      │
                                      ▼
                               Telnyx (SIP) ──► Phone Call
```

**Latency budget** for natural conversation:
- STT: ~200ms (Deepgram Nova-2)
- LLM: ~500-1500ms (Claude Sonnet)
- TTS: ~200ms (ElevenLabs Turbo)
- Network: ~100ms
- **Total: ~1-2 seconds** (acceptable for phone conversation)

### Channels

Channels are input/output adapters. Each channel:
- Receives messages in its native format
- Normalizes them for the agent loop
- Delivers responses back in the right format

| Channel | Input | Output | Bidirectional |
|---------|-------|--------|---------------|
| WhatsApp | Text, voice notes, images | Text, voice, images | ✅ |
| Voice Call | Speech (via STT) | Speech (via TTS) | ✅ |
| Email | Email text + attachments | Composed emails | ✅ |
| Discord | Text, reactions | Text, reactions, embeds | ✅ |
| Cron | Timer trigger | Text to target channel | One-way |

### Cron & Heartbeat

**Cron jobs** fire on a schedule and trigger agent actions:
```
Schedule → Prompt → Agent Loop → Response → Channel
```

**Heartbeats** are a special cron job that checks `HEARTBEAT.md` for a dynamic task list. The agent reads the file, runs whatever checks are due, and either reports findings or replies `HEARTBEAT_OK`.

The difference:
- **Cron** = fixed prompt, fixed schedule
- **Heartbeat** = dynamic task list, the agent decides what to check

### Context Files

Every session, the agent loads these files into its context window:

| File | Purpose | Loaded When |
|------|---------|-------------|
| `AGENTS.md` | How to operate | Every session |
| `TOOLS.md` | Environment details | Every session |
| `SOUL.md` | Who am I | First thing, every session |
| `USER.md` | Who do I serve | First thing, every session |
| `MEMORY.md` | What do I know | Main sessions only |
| `memory/today.md` | What happened today | Every session |
| `memory/yesterday.md` | What happened yesterday | Every session |
| `HEARTBEAT.md` | What to check | Heartbeat polls only |

This is why file-based memory works so well — it maps directly to LLM context windows. No database queries, no embeddings, no retrieval pipelines. Just files that get loaded into the prompt.

## Design Philosophy

1. **Files over databases.** Plain markdown files are readable, editable, version-controllable, and map naturally to LLM context.

2. **Stateless sessions.** The agent wakes up fresh every time. All state lives in files. This makes the system resilient — crash, restart, pick up where you left off.

3. **Channels are adapters.** The core agent logic is channel-agnostic. The same agent handles WhatsApp, voice, email, and Discord through the same loop.

4. **Personality is configuration.** SOUL.md isn't code — it's prose. Anyone can customize an agent's behavior without touching a config file or writing code.

5. **Proactive by default.** Heartbeats mean the agent works even when you're not talking to it. It checks email, reviews calendars, follows up on tasks — like a real team member.
