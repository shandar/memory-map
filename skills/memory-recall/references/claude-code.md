# Memory Recall — Claude Code Storage Guide

Storage mechanism: `~/.claude/memory.md`

---

## Reading memory

```bash
cat ~/.claude/memory.md 2>/dev/null
```

If the file does not exist, memory is empty. Respond:

> No stored memory yet. I'll start tracking once we build something worth remembering — say "save this" or use memory-map at the close of a productive session.

---

## Parsing the file

The file uses this structure:

```markdown
# Claude Memory Map
Last updated: [date]

## 1. CURRENT STATE SNAPSHOT (date)
[content]

## 2. PROJECT DELIVERABLES
[content]
```

Parse each `## N. CATEGORY LABEL` heading and its body. Sort by priority:

**Tier 1 (always surface):**
- `## 1. CURRENT STATE SNAPSHOT (...)` — should always be entry #1
- Entries containing "pending", "next", "upcoming", "imminent"

**Tier 2 (surface on context request):**
- `[PROJECT] DELIVERABLES` / `EVENT` / `EMAILS` / `EDITIONS` / `BRIEF`

**Tier 3 (surface only if directly relevant):**
- Personal operating preferences
- Design system tokens
- Historical context, completed work

---

## CLAUDE.md cross-reference

If the project also has a `CLAUDE.md` file, check for a `## Persistent Memory` section.
If found, it points to `~/.claude/memory.md` — confirm both are aligned.

---

## After reading

Return to SKILL.md Step 3 and present the recall in the appropriate format
based on the trigger (proactive / on-demand / specific).
