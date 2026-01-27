# Voice Agent Setup

How to give your AI agent a phone number it can answer and make calls from.

## Stack

| Component | Provider | Purpose |
|-----------|----------|---------|
| Phone number + SIP | [Telnyx](https://telnyx.com) | Telephony infrastructure |
| Text-to-Speech | [ElevenLabs](https://elevenlabs.io) | Neural voice for the agent |
| Speech-to-Text | [Deepgram](https://deepgram.com) | Real-time transcription |
| Orchestration | Moltbot | Conversation logic + memory |

## Setup Steps

### 1. Telnyx Account

1. Sign up at [telnyx.com](https://telnyx.com)
2. Buy a phone number (Mission Control → Numbers → Search & Buy)
3. Create a SIP Connection:
   - Mission Control → SIP Connections → Add
   - Type: **Credentials**
   - Note the **Connection ID**
4. Create an API Key:
   - Auth → API Keys → Create
   - Note the key (starts with `KEY...`)
5. Assign the number to your SIP connection:
   - Numbers → Your Number → Connection → Select your SIP connection

### 2. ElevenLabs Voice

1. Sign up at [elevenlabs.io](https://elevenlabs.io)
2. Get your API key from Profile → API Keys
3. Choose or create a voice:
   - **Library voices:** Browse VoiceLab → Voice Library for pre-made voices
   - **Voice cloning:** Upload 1-5 minutes of clear audio to clone a specific voice
4. Note the **Voice ID** from the voice settings

**Recommended model:** `eleven_turbo_v2_5` — lowest latency for real-time conversation.

### 3. Deepgram (Speech-to-Text)

1. Sign up at [deepgram.com](https://deepgram.com)
2. Create an API key in the console
3. Recommended model: `nova-2` — best accuracy-to-speed ratio

### 4. Webhook Setup

Your Moltbot gateway needs a public URL for Telnyx to send call events to.

**Development (ngrok):**
```bash
# Run the deploy-voice script
chmod +x scripts/deploy-voice.sh
./scripts/deploy-voice.sh
```

This starts ngrok and configures the webhook automatically.

**Production:**
- Point a domain to your server (e.g., `agent.yourdomain.com`)
- Set up HTTPS (Let's Encrypt / Caddy / nginx)
- Configure webhook URL: `https://agent.yourdomain.com/voice/webhook`

### 5. Configure Moltbot

Update your `config.json` with the voice-call plugin settings (see [config-guide.md](../config/config-guide.md#voice-call-telnyx)).

### 6. Test

```bash
# Make a test call from the agent
moltbot eval "Call +1YOURNUMBER and say hello"

# Or call your Telnyx number from any phone
```

## Conversation Modes

### `conversation` (default)
Full back-and-forth dialog. The agent listens, thinks, and responds. Best for:
- Inbound support calls
- Sales conversations
- General assistant calls

### `notify`
One-way message delivery. The agent speaks, then hangs up. Best for:
- Appointment reminders
- Urgent alerts
- Delivery notifications

### Example: Outbound Sales Call

```
You: "Call Jane Smith at +1-555-123-4567. Introduce yourself as calling from Acme Corp. 
      The purpose is to follow up on the proposal we sent last week. Ask if she has 
      questions and try to schedule a demo."

Agent: [Dials the number]
Agent: "Hi Jane, this is Atlas calling from Acme Corp. I wanted to follow up on the 
        proposal we sent over last week — did you get a chance to review it?"
[Conversation continues naturally...]
[Agent logs the call summary to memory automatically]
```

## Voice Tuning

### Latency Optimization
- Use `eleven_turbo_v2_5` for ElevenLabs (fastest model)
- Use `nova-2` for Deepgram (best speed/accuracy)
- Set `silenceTimeoutMs` to 1500-2500ms (too low = interrupts, too high = awkward pauses)
- Deploy geographically close to your callers

### Voice Quality
- **Cloned voices** sound most natural but require good source audio
- **Library voices** are consistent and professionally recorded
- Test with real phone calls — laptop speakers ≠ phone audio quality

### Conversation Tips for SOUL.md
Add these to your agent's personality:
```markdown
## Phone Behavior
- Always identify yourself and your organization immediately
- Keep responses concise — phone conversations should be snappy
- Confirm key information by repeating it back
- End every call with a clear next step
- If you can't help, say so and offer to have a human follow up
```

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| No audio from agent | TTS not configured | Check ElevenLabs API key and voice ID |
| Agent can't hear caller | STT not configured | Check Deepgram API key |
| Calls don't connect | Webhook unreachable | Verify ngrok is running or domain DNS |
| Long pauses | High latency | Use turbo TTS model, check server location |
| Agent talks over caller | Silence timeout too low | Increase `silenceTimeoutMs` to 2500 |
| Call drops immediately | Telnyx config issue | Check SIP connection and number assignment |

## Cost Estimates

| Service | Cost | Notes |
|---------|------|-------|
| Telnyx | ~$1/mo per number + $0.01/min | Very affordable |
| ElevenLabs | $5-99/mo | Based on character count |
| Deepgram | $0.0043/min (pay-as-you-go) | Nova-2 pricing |
| Anthropic (Claude) | ~$0.01-0.05 per call turn | Depends on context length |

A typical 5-minute call costs roughly $0.15-0.30 all-in.
