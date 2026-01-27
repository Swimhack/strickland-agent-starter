# HEARTBEAT.md — Proactive Check Configuration

<!--
  This file tells your agent what to check during heartbeat polls.
  Heartbeats fire every ~30 minutes. The agent reads this file,
  runs the checks, and either reports findings or replies HEARTBEAT_OK.
  
  Keep this lean — every item costs tokens.
  Rotate through checks rather than running all of them every time.
-->

## Priority Checks (Every Heartbeat)

- [ ] **Urgent emails** — Check inbox for unread messages from key contacts or with urgent keywords. Summarize anything that needs attention.
- [ ] **Upcoming meetings** — Any meetings in the next 2 hours? Alert with agenda and prep notes.

## Regular Checks (2-3x Daily)

- [ ] **Follow-up tracker** — Review `memory/follow-ups.md` for any overdue follow-ups. Flag items past their deadline.
- [ ] **Calendar review** — Scan next 24 hours. Flag conflicts, missing agendas, or back-to-back blocks without buffer.
- [ ] **Outreach pipeline** — Check if any outreach sequences need next-step emails sent.

## Daily Checks (1x Per Day, Morning)

- [ ] **Daily briefing** — Compile: today's meetings, pending follow-ups, priority tasks, notable emails overnight.
- [ ] **Memory maintenance** — Review recent daily logs, update MEMORY.md with anything worth keeping long-term.
- [ ] **Weather check** — If principal has outdoor meetings or travel today, check forecast.

## Weekly Checks (Monday Morning)

- [ ] **Week ahead** — Summarize the full week's calendar, deadlines, and goals.
- [ ] **Outreach report** — How many emails sent, responses received, meetings booked last week.
- [ ] **Memory cleanup** — Archive old daily logs, prune MEMORY.md of stale info.

## Quiet Hours (22:00–08:00)

During quiet hours, only check for genuine emergencies:
- Email from key contacts marked urgent
- Calendar conflicts for tomorrow morning
- Anything else → `HEARTBEAT_OK`

## State Tracking

Track your last check times in `memory/heartbeat-state.json`:
```json
{
  "lastChecks": {
    "email": null,
    "calendar": null,
    "followUps": null,
    "outreach": null,
    "weather": null,
    "weeklyReport": null
  },
  "lastDailyBrief": null,
  "lastWeeklyReview": null
}
```

Update timestamps after each check to avoid redundant work.
