# Voice Calling Skill

**Create and control AI voice agents for outbound calling.**

---

## Description

This skill lets you create AI voice agents with custom personalities that can make outbound phone calls. Perfect for sales outreach, appointment setting, customer follow-ups, or any scenario where you need a voice agent.

**Powered by:** Vapi.ai

---

## Prerequisites

1. Vapi.ai account: https://vapi.ai
2. API key from Vapi dashboard
3. Phone number (Vapi provides one, or import your own Twilio number)

**Configuration:**

Add to your `openclaw.json`:

```json
{
  "integrations": {
    "vapi": {
      "enabled": true,
      "apiKey": "your_vapi_api_key_here"
    }
  }
}
```

---

## Usage

### Create a Voice Agent

**User:** "Create a voice agent named Sarah for sales calls. She should be friendly and professional, pitching our $500 website service to home service businesses."

**Agent will:**
1. Create Vapi assistant with that persona
2. Configure voice settings
3. Save agent ID for future use
4. Confirm it's ready

### Make a Call

**User:** "Call John at 832-555-1234 using Sarah. He runs an HVAC company and has no website."

**Agent will:**
1. Look up Sarah's agent ID
2. Make the call via Vapi
3. Provide call ID for tracking
4. Monitor status

### Custom Personas

**User:** "Call me as The Terminator. Make it funny."

**Agent will:**
1. Create one-off agent with Terminator personality
2. Call your number
3. Break character when you question it (if instructed)

### Check Call Status

**User:** "What happened on call ID 019c3478...?"

**Agent will:**
1. Fetch call details from Vapi
2. Show transcript
3. Provide recording URLs
4. Summarize outcome

---

## Features

### Persona Customization
- Any personality (professional, casual, funny, robotic)
- Voice selection (male, female, accents)
- Speech speed control
- Response timing adjustments

### Call Management
- Outbound calling to any number
- Real-time status tracking
- Full call transcripts
- Recording URLs (audio playback)

### Analytics
- Call duration and cost
- Success/failure detection
- Conversation flow analysis
- Objection extraction (if configured)

---

## Configuration Options

### Agent Settings

```javascript
{
  name: "Agent Name",
  persona: "Full personality prompt",
  voice: {
    provider: "11labs",
    voiceId: "sarah",
    speed: 1.0,
    stability: 0.5
  },
  behavior: {
    responseDelay: 1.0,  // Seconds before speaking
    interruptible: true,
    maxDuration: 600     // 10 minutes
  }
}
```

### Call Settings

```javascript
{
  phoneNumber: "+18005551234",
  assistantId: "agent-uuid",
  metadata: {
    leadId: "lead-123",
    campaignId: "campaign-abc"
  }
}
```

---

## Examples

### Sales Agent

```
Create a voice agent named "Alex" for B2B sales.

Personality:
- Professional but warm
- Confident, not pushy
- Good listener
- Handles objections smoothly

Script:
- Intro: "Hi, this is Alex from [Company]. I help businesses like yours..."
- Pitch: "$500 website + Google Business setup"
- Handle objections: price, timing, already have website
- Close: Send examples via text or email
```

### Appointment Setter

```
Create agent "Lisa" for appointment setting.

Personality:
- Friendly and efficient
- Respectful of their time
- Persistent but polite

Goal:
- Book 15-minute consultation calls
- Get them to confirm date/time
- Send calendar invite after call
```

### Customer Service

```
Create agent "Mike" for support calls.

Personality:
- Patient and helpful
- Technical but not jargon-heavy
- Empathetic to frustration

Tasks:
- Troubleshoot common issues
- Escalate complex problems
- Log all interactions
```

---

## Advanced Usage

### Multi-Agent Campaigns

```
1. Create 3 agents (different approaches)
2. A/B test which performs best
3. Use winning agent for full campaign
```

### Integration with CRM

```
When call completes:
- Save transcript to CRM
- Update lead status
- Schedule follow-ups
- Alert human to hot leads
```

### Voice Cloning (ElevenLabs)

```
1. Record your voice (11labs.io)
2. Get voice ID
3. Use in agent config
4. Agent sounds like you!
```

---

## API Reference

### Create Agent

```bash
vapi-create-agent \
  --name "Sarah" \
  --persona "Friendly sales rep..." \
  --voice "sarah" \
  --speed 1.0
```

### Make Call

```bash
vapi-call \
  --agent "Sarah" \
  --phone "+18005551234" \
  --metadata '{"leadId":"123"}'
```

### Get Call Details

```bash
vapi-get-call --id "019c3478-e58e-7887-92fc-8f5c1f33f8d6"
```

---

## Pricing (Vapi.ai)

**Per Minute Costs:**
- Voice calling: ~$0.05-0.15/minute
- Typical call (3-5 min): $0.15-0.75
- 100 calls: ~$25-75

**Vapi Plans:**
- **Starter:** $99/month (1,000 minutes)
- **Growth:** $299/month (5,000 minutes)
- **Scale:** Custom pricing

---

## Best Practices

### 1. Test Before Launching
Always test agent on yourself first. Check:
- Does personality sound right?
- Are pauses natural?
- Does script flow well?

### 2. Respect Call Limits
- Don't spam (30-60s between calls minimum)
- Honor Do Not Call lists
- Stop if requested

### 3. Monitor Performance
- Review call recordings
- Track success rates
- Adjust script based on objections

### 4. Compliance
- TCPA compliant (opt-out handling)
- Record calls where required
- Don't misrepresent identity

---

## Troubleshooting

### "Call failed: daily limit"
- Vapi built-in numbers have limits
- Import your own Twilio number for unlimited

### "Authentication failed"
- Check Vapi API key in config
- Regenerate key if needed

### "Agent sounds robotic"
- Increase voice temperature (0.8-0.9)
- Add natural speech patterns to prompt
- Slow down speech speed (0.8-0.9x)

### "No answer / voicemail"
- Normal (50-70% of calls hit voicemail)
- Configure voicemail message
- Schedule callback attempts

---

## Scripts Location

**Installation:** `skills/voice-calling/scripts/`

- `create-agent.js` - Create Vapi assistants
- `make-call.js` - Initiate outbound calls
- `get-call.js` - Fetch call details
- `list-agents.js` - View all agents

**Usage:**

```bash
cd skills/voice-calling/scripts
node create-agent.js --name "Sarah" --persona "..."
node make-call.js --agent-id "xxx" --phone "+1..."
```

---

## Support

**Issues?**
- Email: support@stricklandtechnology.net
- Discord: https://discord.gg/strickland-tech
- Vapi Docs: https://docs.vapi.ai

---

**Make AI voice calls from chat. It's that easy.**
