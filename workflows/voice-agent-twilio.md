# Voice Agent Setup — Twilio

How to give your AI agent a phone number using Twilio. Recommended for most users — Twilio has the largest community, best docs, and most developers already have an account.

## Prerequisites

- the agent installed and running
- A Twilio account (free trial works for testing)
- A public URL for webhooks (ngrok for dev, domain for production)

## Setup Steps

### 1. Create a Twilio Account

1. Sign up at [twilio.com](https://www.twilio.com/try-twilio)
2. Verify your email and phone number
3. From the Console Dashboard, note your:
   - **Account SID** (starts with `AC...`)
   - **Auth Token** (click to reveal)

### 2. Get a Phone Number

**Trial account:**
- Twilio gives you one free number
- Can only call numbers you've verified (add them in Console → Verified Caller IDs)
- Caller ID shows "Trial account" prefix on outbound calls

**Upgraded account ($20 minimum deposit):**
- Buy any local, toll-free, or mobile number (~$1.15/mo)
- Call anyone, no restrictions
- Clean caller ID
- Console → Phone Numbers → Buy a Number

**Recommendation:** Start with trial to test, upgrade before going live. The $20 deposit covers months of usage for most agents.

### 3. Configure the agent

Add the voice-call plugin to your `config.json`:

```json
{
  "plugins": {
    "entries": {
      "voice-call": {
        "enabled": true,
        "config": {
          "provider": "twilio",
          "twilio": {
            "accountSid": "YOUR_ACCOUNT_SID",
            "authToken": "YOUR_AUTH_TOKEN"
          },
          "fromNumber": "+1XXXXXXXXXX",
          "publicUrl": "https://your-domain.com/voice",
          "serve": {
            "port": 18800,
            "bind": "0.0.0.0",
            "path": "/voice"
          },
          "tts": {
            "provider": "openai",
            "openai": {
              "voice": "onyx"
            }
          },
          "responseModel": "anthropic/claude-3-5-haiku-20241022",
          "responseTimeoutMs": 15000,
          "inboundPolicy": "allowlist",
          "allowFrom": [
            "+1YOURNUMBER"
          ]
        }
      }
    }
  }
}
```

### 4. Set Up Webhooks

Twilio needs to reach your the agent instance when calls come in.

**Development (ngrok):**
```bash
# Start ngrok
ngrok http 18800

# Copy the https URL (e.g., https://abc123.ngrok-free.app)
# Update publicUrl in config to: https://abc123.ngrok-free.app/voice
```

**Production:**
- Point a domain/subdomain to your server
- Use HTTPS (Let's Encrypt, Caddy, or nginx reverse proxy)
- Set `publicUrl` to `https://agent.yourdomain.com/voice`

**Configure in Twilio Console:**
1. Go to Phone Numbers → Manage → Active Numbers → Your Number
2. Under "Voice & Fax":
   - **A call comes in:** Webhook → `https://your-url/voice`
   - **HTTP method:** POST
3. Save

### 5. Security — Validate Twilio Signatures

Twilio signs every webhook request. the agent validates these automatically when you provide your Auth Token. This prevents anyone from sending fake call events to your webhook.

**Never expose your Auth Token publicly.** Keep it in your config file, which should be in `.gitignore`.

### 6. Test

**Inbound test:**
```
Call your Twilio number from your phone.
Your agent should answer and greet you.
```

**Outbound test:**
```
Message your agent: "Call me at +1YOURNUMBER"
Or use the CLI: agent-cli eval "Call +1YOURNUMBER and say hello"
```

## Conversation Modes

### `conversation`
Full two-way dialog. Agent listens, thinks, responds. Use for:
- Customer support
- Sales calls
- General assistant

### `notify`
One-way message. Agent speaks, then hangs up. Use for:
- Appointment reminders
- Delivery alerts
- Urgent notifications

## Twilio vs Telnyx — Which to Choose

| Factor | Twilio | Telnyx |
|--------|--------|--------|
| **Ease of setup** | Easier — bigger community, more tutorials | Slightly more technical |
| **Pricing** | $0.014/min outbound, $0.0085/min inbound | $0.01/min both directions |
| **Free trial** | Yes (verified numbers only) | Yes (verified numbers only) |
| **Number cost** | ~$1.15/mo | ~$1.00/mo |
| **Voice quality** | Excellent | Excellent |
| **Neural TTS** | Via Amazon Polly or OpenAI | Built-in Polly Neural voices |
| **Community** | Massive — most examples use Twilio | Growing — developer-focused |
| **Best for** | Most users, fastest to get started | Cost-sensitive, high volume |

**Bottom line:** Use Twilio unless you have a specific reason not to.

## Trial Account Limitations

Before upgrading, be aware:
- Can only call verified numbers (add in Console → Verified Caller IDs)
- Outbound calls play a "trial account" message before your agent speaks
- Limited to one phone number
- SMS has similar restrictions

**Upgrade path:** Console → Billing → Upgrade → $20 minimum deposit. Removes all restrictions immediately.

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| "Cannot make calls to unverified numbers" | Trial account | Verify the number or upgrade account |
| Calls go straight to voicemail | Webhook not configured | Check Twilio Console number settings |
| Agent answers but no audio | TTS not configured | Check OpenAI API key in config |
| Agent can't hear caller | STT not starting | Check the agent gateway logs |
| "Invalid Auth Token" | Wrong credentials | Re-copy from Twilio Console |
| Webhook returns 404 | Wrong path | Ensure publicUrl includes `/voice` |
| Call drops after greeting | Response timeout | Increase `responseTimeoutMs` |

## Cost Estimates

| Component | Cost |
|-----------|------|
| Twilio number | ~$1.15/mo |
| Outbound calls | $0.014/min |
| Inbound calls | $0.0085/min |
| OpenAI TTS | ~$0.015 per 1K chars |
| Claude (response gen) | ~$0.01-0.05 per turn |

**Typical 5-minute call: ~$0.15-0.35 all-in.**

## Next Steps

- [Configure your agent's personality](../templates/SOUL.md)
- [Set up email integration](./email-integration.md)
- [Build outreach campaigns](./outreach-automation.md)
