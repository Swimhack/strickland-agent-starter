# Outreach Automation

How to set up automated email outreach campaigns with AI-powered follow-ups, personalization, and pipeline tracking.

## Overview

Your agent can run multi-step outreach sequences:
1. **Import leads** → CSV or manual entry into a tracking file
2. **Send initial emails** → Personalized using AI based on lead context
3. **Track responses** → Agent monitors inbox for replies
4. **Follow up automatically** → Timed sequences with escalating urgency
5. **Report results** → Weekly summaries of open rates, replies, meetings booked

## Setup

### 1. Create the Outreach Directory

```bash
mkdir -p workspace/memory/outreach
```

### 2. Lead List Format

Create `workspace/memory/outreach/leads.md`:

```markdown
# Active Leads

## Pipeline

| Name | Company | Email | Status | Last Contact | Next Action | Notes |
|------|---------|-------|--------|-------------|-------------|-------|
| Jane Smith | Acme Corp | jane@acme.com | initial | 2026-01-15 | Follow-up 1 (Jan 18) | Met at conference |
| Bob Chen | TechCo | bob@techco.io | responded | 2026-01-14 | Schedule call | Interested in demo |
```

### 3. Email Templates

Create `workspace/memory/outreach/templates.md`:

```markdown
# Outreach Templates

## Initial Contact
Subject: {{personalized_subject}}

Hi {{first_name}},

{{personalized_opener_based_on_context}}

We help {{company_type}} companies {{value_proposition}}.

{{specific_relevance_to_their_business}}

Would you be open to a 15-minute call this week?

Best,
{{your_name}}

## Follow-up 1 (3 days after initial)
Subject: Re: {{original_subject}}

Hi {{first_name}},

Quick follow-up on my note from {{days_ago}}. {{new_angle_or_value_add}}.

Happy to work around your schedule — here's my calendar: {{calendar_link}}

{{your_name}}

## Follow-up 2 (7 days after initial)
Subject: Re: {{original_subject}}

Hi {{first_name}},

Last note from me — I know you're busy.

{{brief_case_study_or_result}} and thought it might be relevant for {{company}}.

If the timing isn't right, no worries at all. Just reply "not now" and I'll check back in a few months.

{{your_name}}

## Break-up Email (14 days after initial)
Subject: Closing the loop

Hi {{first_name}},

I've reached out a few times and haven't heard back, so I'll assume the timing isn't right.

I'll remove you from my follow-up list. If things change, my inbox is always open.

All the best,
{{your_name}}
```

### 4. Configure the Cron Job

In your `config.json`, add an outreach cron:

```json
{
  "cron": {
    "outreach-check": {
      "schedule": "0 9 * * 1-5",
      "prompt": "Review workspace/memory/outreach/leads.md. For any leads where the Next Action date is today or past, draft and send the appropriate follow-up email using the templates. Update the lead status and Last Contact date. Log all actions to today's daily memory file.",
      "channel": "whatsapp"
    }
  }
}
```

## How It Works

### Agent Behavior

When the outreach cron fires, your agent:

1. Reads `leads.md` to find pending follow-ups
2. Reads `templates.md` for the appropriate template stage
3. **Personalizes** each email using AI — not mail-merge, actual intelligent personalization based on the lead's company, role, and context
4. Sends via the configured email provider
5. Updates `leads.md` with new status and dates
6. Logs everything to the daily memory file

### Tracking Responses

Add this to your `HEARTBEAT.md`:

```markdown
- [ ] **Outreach responses** — Check inbox for replies from anyone in the outreach pipeline. Update their status in leads.md. Flag hot leads for immediate attention.
```

The agent will match incoming emails against your lead list and update statuses automatically.

### Weekly Report

The `weekly-outreach` cron (from example config) generates a summary:

```
📊 Weekly Outreach Report (Jan 13-17)
- Emails sent: 12
- Responses received: 4 (33% reply rate)
- Meetings booked: 2
- Pipeline value: $45K
- Hot leads: Jane Smith (Acme), Bob Chen (TechCo)
- Stale leads (no response after 3 touches): 3
```

## Best Practices

1. **Quality over volume** — 10 well-researched, personalized emails beat 100 generic ones
2. **Space follow-ups** — 3 days, then 7, then 14. Don't be aggressive.
3. **Always provide value** — Each follow-up should add new information, not just "checking in"
4. **Respect opt-outs** — If someone says no, mark them as closed immediately
5. **Log everything** — Your agent's memory is your CRM. Every interaction gets recorded.
6. **Review weekly** — Check the outreach report every Monday. Adjust templates based on what's working.

## Advanced: Multi-Channel Outreach

Combine email with other channels:

```markdown
## Sequence: Enterprise Prospect
1. Day 0: LinkedIn connection request (manual)
2. Day 1: Initial email
3. Day 3: Follow-up email with case study
4. Day 5: WhatsApp message (if number available)
5. Day 7: Phone call attempt via voice agent
6. Day 14: Break-up email
```

Your agent can execute steps 2-6 automatically. Log LinkedIn actions manually in the lead notes.
