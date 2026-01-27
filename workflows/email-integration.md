# Email Integration

How to set up your agent to read, draft, and send emails.

## Architecture

```
┌──────────┐    IMAP     ┌──────────┐    API/SMTP    ┌──────────┐
│  Inbox   │ ──────────► │  Agent   │ ──────────────► │ Outbox   │
│ (read)   │             │ (think)  │                 │ (send)   │
└──────────┘             └──────────┘                 └──────────┘
```

**Reading** uses IMAP (universal, works with any provider).  
**Sending** uses provider API (recommended) or SMTP.

> **Why API over SMTP?** Many VPS providers block SMTP ports (25, 465, 587). Provider APIs work regardless and offer better deliverability tracking.

## Supported Providers

| Provider | IMAP | Sending Method | Notes |
|----------|------|---------------|-------|
| Gmail | ✅ | Gmail API | Requires OAuth2 setup |
| Zoho | ✅ | Zoho Mail API | Good for business domains |
| Outlook/365 | ✅ | Microsoft Graph API | Enterprise-friendly |
| FastMail | ✅ | SMTP (ports work) | Developer-friendly |
| Any IMAP provider | ✅ | Varies | Check if SMTP ports are open |

## Setup

### Step 1: IMAP (Reading Emails)

We recommend [Himalaya](https://github.com/pimalaya/himalaya) as the CLI email client. It's fast, lightweight, and works great with AI agents.

```bash
# Install Himalaya
curl -sSL https://raw.githubusercontent.com/pimalaya/himalaya/master/install.sh | bash

# Or via package manager
# macOS: brew install himalaya
# Arch: pacman -S himalaya
```

Configure `~/.config/himalaya/config.toml`:

```toml
[accounts.default]
email = "you@yourdomain.com"
display-name = "Your Name"
default = true

[accounts.default.imap]
host = "imap.yourprovider.com"
port = 993
login = "you@yourdomain.com"
passwd.cmd = "cat ~/.config/himalaya/.email-pass"
encryption = "tls"

[accounts.default.smtp]
host = "smtp.yourprovider.com"
port = 465
login = "you@yourdomain.com"
passwd.cmd = "cat ~/.config/himalaya/.email-pass"
encryption = "tls"
```

Store your password:
```bash
mkdir -p ~/.config/himalaya
echo "your-app-password" > ~/.config/himalaya/.email-pass
chmod 600 ~/.config/himalaya/.email-pass
```

**Important:** Use an app-specific password, not your main login password. Most providers support this in security settings.

Test it:
```bash
himalaya envelope list          # List recent emails
himalaya message read 1         # Read email #1
```

### Step 2: Sending Emails

#### Option A: Provider API (Recommended)

**Zoho example:**

```bash
# Create API credentials
mkdir -p ~/.config/zoho-api

# Store credentials (get from Zoho API Console)
cat > ~/.config/zoho-api/credentials.json << 'EOF'
{
  "clientId": "YOUR_CLIENT_ID",
  "clientSecret": "YOUR_CLIENT_SECRET",
  "refreshToken": "YOUR_REFRESH_TOKEN",
  "accountId": "YOUR_ACCOUNT_ID"
}
EOF

chmod 600 ~/.config/zoho-api/credentials.json
```

Create a send script at `~/.local/bin/zoho-send`:
```bash
#!/bin/bash
# Usage: zoho-send "to@email.com" "Subject" "Body"
TO="$1"
SUBJECT="$2"
BODY="$3"

# Load credentials
CREDS=~/.config/zoho-api/credentials.json
CLIENT_ID=$(jq -r .clientId "$CREDS")
CLIENT_SECRET=$(jq -r .clientSecret "$CREDS")
REFRESH_TOKEN=$(jq -r .refreshToken "$CREDS")
ACCOUNT_ID=$(jq -r .accountId "$CREDS")

# Get access token
ACCESS_TOKEN=$(curl -s "https://accounts.zoho.com/oauth/v2/token" \
  -d "refresh_token=$REFRESH_TOKEN" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=refresh_token" | jq -r .access_token)

# Send email
curl -s "https://mail.zoho.com/api/accounts/$ACCOUNT_ID/messages" \
  -H "Authorization: Zoho-oauthtoken $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"fromAddress\": \"you@yourdomain.com\",
    \"toAddress\": \"$TO\",
    \"subject\": \"$SUBJECT\",
    \"content\": \"$BODY\"
  }"
```

```bash
chmod +x ~/.local/bin/zoho-send
```

#### Option B: SMTP (if ports are open)

If SMTP ports aren't blocked, Himalaya handles sending natively:
```bash
himalaya message write           # Opens editor to compose
echo "Body text" | himalaya message send --to "to@email.com" --subject "Subject"
```

### Step 3: Agent Configuration

Update `TOOLS.md` in your workspace:

```markdown
## Email

**Reading:**
- CLI: `himalaya`
- Commands: `himalaya envelope list`, `himalaya message read <id>`

**Sending:**
- Script: `~/.local/bin/zoho-send "to@email.com" "Subject" "Body"`
- From: you@yourdomain.com
```

### Step 4: Heartbeat Integration

Add to `HEARTBEAT.md`:

```markdown
- [ ] **Email check** — Run `himalaya envelope list` and scan for unread messages
      from key contacts or with urgent keywords. Summarize anything important.
```

## Agent Email Behavior

### Reading
The agent runs `himalaya envelope list` to check for new emails, then `himalaya message read <id>` for ones that look important. It prioritizes:
1. Emails from key contacts (defined in USER.md)
2. Emails with urgent keywords
3. Replies to outreach campaigns
4. Everything else

### Drafting
When the agent drafts an email, it:
1. Matches the formality level of the original sender
2. Uses your communication style (defined in USER.md)
3. Keeps it concise unless the situation requires detail
4. Always shows you the draft before sending (unless you've granted autonomous send permission)

### Sending
By default, the agent asks before sending any email. To enable autonomous sending for certain cases, add to SOUL.md:

```markdown
## Email Autonomy
- May send follow-up emails in active outreach sequences without asking
- May send calendar confirmations and scheduling emails without asking
- Must ask before: first contact with new people, anything financial, anything legal
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `himalaya` connection refused | Check IMAP host/port, ensure TLS is correct |
| Authentication failed | Use app-specific password, not main password |
| Can't send (SMTP blocked) | Switch to API method — most VPS block SMTP |
| Emails going to spam | Set up SPF, DKIM, DMARC records for your domain |
| Agent reads same emails repeatedly | Track read message IDs in `memory/email-state.json` |
