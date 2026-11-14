# Memory Recall — claude.ai Storage Guide

Storage mechanism: `memory_user_edits` tool

---

## Reading memory

```
memory_user_edits(command="view")
```

Returns a numbered list of all current entries. Parse them by their CATEGORY LABEL prefix.

---

## Parsing entries

Look for entries beginning with these labels (in priority order):

**Tier 1 (always surface):**
- `CURRENT STATE SNAPSHOT (...)` — the current state of all projects
- Entries with the words "pending", "next", "upcoming", "imminent"

**Tier 2 (surface on context request):**
- `[PROJECT] DELIVERABLES`
- `[PROJECT] EVENT`
- `[PROJECT] EMAILS`
- `[PROJECT] EDITIONS`
- `[PROJECT] BRIEF`

**Tier 3 (surface only if directly relevant):**
- Personal operating preferences (PWP, communication style)
- Design system tokens
- Historical context, completed work

---

## What if memory is empty?

If `memory_user_edits(command="view")` returns no entries, respond:

> No stored memory yet. I'll start tracking once we build something worth remembering — say "save this" or use memory-map at the close of a productive session.

Do not pretend to remember anything. Do not extrapolate.

---

## After reading

Return to SKILL.md Step 3 and present the recall in the appropriate format
based on the trigger (proactive / on-demand / specific).
