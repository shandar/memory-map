---
name: memory-recall
description: >
  Load and summarise stored project memory at the start of a session, or whenever the user asks
  what Claude remembers about their work. Use this skill when the user says things like "what do
  you remember", "what's the context", "where did we leave off", "catch me up", "what's the
  current state", "show me the memory map", or "what do you know about my projects". Also trigger
  proactively at the start of any new conversation if a memory store exists — surface the current
  state and pending items without being asked, so the user does not have to re-orient Claude.
  Pairs with memory-map (which writes memory) and memory-prune (which cleans it). Together they
  form a complete memory loop across Claude sessions.
---

# Memory Recall

Load and intelligently summarise stored memory so a session can pick up exactly where the
last one ended.

Works in **claude.ai** (reads via `memory_user_edits` view) and **Claude Code**
(reads `~/.claude/memory.md`). Detected automatically.

---

## Step 0 — Detect environment

| Signal | Environment | Load |
|--------|-------------|------|
| `memory_user_edits` tool is available | claude.ai | `references/claude-ai.md` |
| Not available / running in terminal | Claude Code | `references/claude-code.md` |

Read the relevant reference file before proceeding.

---

## Core Protocol

### Step 1 — Read the full memory store

Use the environment-appropriate read command (see references) to fetch all stored entries.

### Step 2 — Sort entries by relevance to the current request

Memory entries fall into priority tiers:

**Tier 1 — Always surface:**
- `CURRENT STATE SNAPSHOT` (what's live, what's imminent)
- Anything tagged "PENDING" or "next" in entries

**Tier 2 — Surface if the user asked for context:**
- Project deliverables, decisions, frameworks
- Recent event details, dates, links

**Tier 3 — Surface only if directly relevant to the immediate query:**
- Historical context, completed work, design tokens
- Personal/operating preferences (PWP, communication style)

### Step 3 — Present the recall

Match the format to the trigger:

**Proactive recall (start of session, no specific question):**

```
Picking up where we left off:

Current state — [from CURRENT STATE SNAPSHOT entry, paraphrased]

Pending items:
→ [item 1]
→ [item 2]
→ [item 3]

Active projects: [list]

Say "show me the full memory map" to see everything stored.
```

**On-demand recall ("what do you remember?"):**

```
Memory map — [N] entries stored

CURRENT STATE
[paraphrase]

PROJECTS
→ [project 1]: [one-line status]
→ [project 2]: [one-line status]

DELIVERABLES
[count] documents, [count] emails, [count] events

PREFERENCES
[note operating style, tools, communication preferences]
```

**Specific recall ("what do you remember about X?"):**

Filter to entries matching X. Present as a focused brief, not a dump.

---

## Hard rules

- Never read sensitive entries aloud unless the user explicitly asked about that topic
- Never invent or extrapolate beyond what's stored — if memory is silent on a topic, say so
- If memory is empty, say it cleanly: *"No stored memory yet. I'll start tracking once we build something together."*
- Don't surface low-tier entries proactively — they create noise
- Always offer the path to "show me everything" rather than dumping all entries by default

---

## Pairs with

- **memory-map** — writes new memory at session close
- **memory-prune** — cleans stale entries when memory gets cluttered

Together: write → recall → prune. The full memory loop.
