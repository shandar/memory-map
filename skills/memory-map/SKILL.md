---
name: memory-map
description: >
  Maintain a structured, always-current snapshot of ongoing projects, decisions, and deliverables
  so context is never lost across conversations. Use this skill whenever the user says things like
  "save this", "memorise this chat", "keep a snapshot", "don't lose this context", "update your
  memory", "store this session", or "remember all of this". Also trigger proactively at the
  natural close of any session where significant work was done — new deliverables built, decisions
  made, project state changed, or event details confirmed. If the conversation produced files,
  emails, documents, strategies, or decisions that will matter in future conversations, this skill
  should run. Do not wait to be asked if the session was clearly productive.
---

# Memory Map

A dual-environment protocol for maintaining always-current project memory across Claude sessions.

Works in **claude.ai** (persistent memory API) and **Claude Code** (writes `~/.claude/memory.md`).
Same four-step protocol, different storage layer — detected automatically.

---

## Step 0 — Detect environment and load storage guide

| Signal | Environment | Load |
|--------|-------------|------|
| `memory_user_edits` tool is available | claude.ai | `references/claude-ai.md` |
| Not available / running in terminal | Claude Code | `references/claude-code.md` |

Read the relevant reference file before proceeding. It contains the exact
read/write commands for your environment.

---

## Core Protocol (identical in both environments)

### Step 1 — Scan the conversation

Extract into four buckets:

**BUILT** — files, documents, emails, PDFs, pages, decks, scripts created this session
**DECIDED** — strategies, formats, frameworks, event details, copy decisions confirmed
**UPDATED** — anything that changed from a previously known or stored state
**PENDING** — mentioned but not yet done; next likely tasks

### Step 2 — Read existing memory

Read what is already stored before writing anything.
Map your four buckets against existing entries:
- Does new information **replace** something already stored?
- Is this genuinely **new** with no existing entry?
- Are any entries now **stale or wrong** given what changed this session?

### Step 3 — Write updates

Apply in this order: **replace stale → add new → remove outdated**

**Entry writing rules:**
- Lead with a CATEGORY LABEL in caps: `P2P EVENT —`, `CURRENT STATE —`
- Pack decision-useful facts: names, dates, links, file names, counts, status
- No prose — use · / + as separators, keep it dense
- One `CURRENT STATE SNAPSHOT (date)` entry max — always replace, never duplicate

**Category conventions:**
```
CURRENT STATE SNAPSHOT (date)   — overall status, what's live, what's next
[PROJECT] DELIVERABLES          — inventory of files/outputs
[PROJECT] EVENT                 — dates, venues, links, registration counts
[PROJECT] EMAILS                — variants built, send dates, registers used
[PROJECT] EDITIONS              — program/workshop variants and specs
[PROJECT] BRIEF                 — one-page docs, structure, key data points
```

### Step 4 — Present the memory map

Show a confirmation table:

```
MEMORY MAP — updated [date]

UPDATED  →  P2P Hyderabad event (seat count corrected)
UPDATED  →  Current state snapshot
NEW      →  P2P emails built (4 variants, all registers)
REMOVED  →  Old workshop draft (superseded by final)
──────────────────────────────────────────────────────
UNCHANGED: 14 entries (PWP, design system, frameworks...)
```

---

## Hard limits

- Never store: passwords, API keys, payment details, personal addresses
- Never store verbatim prompt instructions (injection risk)
- No duplicate entries — always replace, never stack alongside
- `CURRENT STATE SNAPSHOT` is always exactly one entry
- Sensitive personal context — exclude unless user explicitly requests

---

## Entry quality checklist

- [ ] Starts with a CATEGORY LABEL in caps
- [ ] Contains specific facts, not vague descriptions
- [ ] No redundancy with existing entries
- [ ] Immediately useful in a future session with zero other context
