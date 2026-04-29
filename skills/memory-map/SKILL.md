---
name: memory-map
description: >
  Two-tier project memory system. Maintains a global Claude memory snapshot of all
  ongoing projects AND a per-project STATUS.md file in each project folder that
  captures last-session state, next actions, blockers, and key locations — so
  context survives long absences. Operates in two modes. WRITE mode triggers when
  the user says "save this", "memorise this", "snapshot this", "checkpoint
  [project]", "update your memory", "store this session", "remember all of this",
  or "save progress" — also proactively at the natural close of any productive
  session. READ mode triggers when the user says "where did I leave off", "catch
  me up on [project]", "restore context", "what was I doing", "[project] status",
  or returns to a project after a long gap. Works in both Claude Code (writes and
  reads STATUS.md directly in the project folder) and Claude.ai (updates global
  memory and emits STATUS.md content as an artifact for the user to save). Do not
  wait to be asked if a session was clearly productive.
---

# Memory Map Skill — v0.2

A two-tier project memory protocol for context that survives long absences.

## The model

Two layers, each with a distinct job:

| Tier | Where it lives | What it stores | Scope |
|------|----------------|----------------|-------|
| **Global** | Claude memory API (`memory_user_edits`) | Cross-project index + state snapshot | ~30 entries total |
| **Per-project** | `<project>/STATUS.md` | Deep state for one project | Unlimited, one per repo |

Global memory answers: *what am I working on across everything?*
STATUS.md answers: *where exactly did I leave off in this one project?*

Read together, they restore full context. Written together, they stay in sync.

---

## Two modes

Identify the mode before doing anything else.

### WRITE mode — save state

Triggered when:
- User asks to save: "save this", "memorise this", "snapshot", "checkpoint [project]"
- User asks to update: "update memory", "store this session", "remember all of this"
- Session naturally closes after productive work (proactive trigger)
- PWP phase transition mentioned ("plan done, moving to execute" → update phase tag)

### READ mode — restore context

Triggered when:
- User asks for orientation: "where did I leave off", "catch me up on [project]",
  "what was I doing", "restore context"
- User asks for status: "[project] status", "status check on [project]"
- User opens a session after a long gap and asks an open question about a project
- User asks "what's pending on [project]"

---

## Environment routing

Detect the environment first, then route accordingly.

**Claude Code** — active working directory with project files, typically a
`CLAUDE.md` present in the cwd:
- WRITE: update global memory + write or update `STATUS.md` directly in the project root
- READ: read `STATUS.md` from the project root + read global memory entries

**Claude.ai web** — no project filesystem access:
- WRITE: update global memory + emit `STATUS.md` content as an artifact for the
  user to save into their project folder. State the target path explicitly.
- READ: read global memory; if STATUS.md is in the conversation (uploaded or
  pasted), use it; otherwise note that deep context requires opening the project
  in Claude Code

---

## WRITE protocol — run in this exact order

### Step 1 — Detect scope and PWP phase

Identify which project(s) this session affected. A single session usually concerns
one project; if more, run per-project steps for each.

Determine the PWP phase: **plan / execute / verify / ship**. Infer from the work
done — designing or scoping = plan; coding or building = execute; testing or
review = verify; deploying or releasing = ship. If genuinely ambiguous, ask.

### Step 2 — Scan the conversation

Read the full conversation. Extract into five buckets:

- **BUILT** — files, documents, emails, PDFs, pages, decks created this session
- **DECIDED** — strategies, formats, copy, frameworks, event details confirmed
- **UPDATED** — anything that changed from a previously known state
- **PENDING** — things mentioned but not yet done, next likely tasks
- **BLOCKED** — open questions, undecided items, things waiting on someone

### Step 3 — Update global memory

Always call `memory_user_edits` with `command="view"` before changes.

Map what you extracted in Step 2 against what is already stored:
1. **Replace** stale entries first (`command="replace"` with correct `line_number`)
2. **Add** genuinely new entries
3. **Remove** outdated or superseded entries

**Entry writing rules:**
- Max 500 chars per entry — be ruthlessly concise
- Start with a CATEGORY LABEL in caps: `P2P EVENT —`, `V2V EDITIONS —`
- Pack decision-useful facts: names, dates, links, counts, file names, status
- No prose — use · and / and + as separators
- Split into two entries if over 500 chars

**Category conventions:**
- `CURRENT STATE SNAPSHOT (date)` — always update, never duplicate
- `[PROJECT] DELIVERABLES BUILT` — inventory per project
- `[PROJECT] EVENT` — dates, venues, links for live events
- `[PROJECT] EMAILS BUILT` — variants, send dates, registers
- `[PROJECT] EDITIONS` — workshop/program variants
- `[PROGRAM] BRIEF` — one-page docs, structure, cohort data

### Step 4 — Update STATUS.md (per-project)

For each project affected this session:

**Claude Code:** read `<project>/STATUS.md` if it exists; otherwise create it.
Update all five sections per the structure below. When updating, preserve prior
context that still matters; supersede what is now stale. If "Last session" is
overwritten with new content, the prior session's notable items can fold into
"TL;DR" or "Open threads" if relevant.

On first STATUS.md creation in a project, also append `STATUS.md` to the project's
`.gitignore` (creating it if absent). This keeps operational state out of public
repos by default. User can remove the line manually if STATUS.md should be
committed for team handoff.

**Claude.ai web:** generate the full `STATUS.md` as an artifact. Tell the user
the exact path to save it at: `<project_root>/STATUS.md`.

### Step 5 — Present the memory map

Show the user a clean summary:

```
MEMORY MAP — updated [YYYY-MM-DD]

Global memory:
| # | Label | Status |
|---|-------|--------|
| 12 | P2P Hyderabad event | UPDATED |
| 16 | P2P emails built | NEW |
| 19 | Current state snapshot | UPDATED |

Per-project STATUS.md:
| Project | Phase | Path |
|---------|-------|------|
| P2P     | execute | ~/projects/p2p/STATUS.md |
```

Only show entries touched this session. Unchanged entries collapse to a one-line
note.

---

## READ protocol — run when restoring context

### Step 1 — Identify scope

- "Catch me up" / "where did I leave off" with no project named → ask which
  project, OR present the global cross-project snapshot if user wants the wide view
- "[project] status" → scoped to that project, skip the question

### Step 2 — Load both tiers

**Claude Code:** read `<project>/STATUS.md` + relevant global memory entries.
**Claude.ai:** read global memory; if STATUS.md is uploaded or pasted, use it;
otherwise note that deep project context requires opening the project in Claude
Code.

### Step 3 — Present a 30-second briefing

Format:

```
[PROJECT] — Phase: [plan/execute/verify/ship] · Last touched: [YYYY-MM-DD]

TL;DR: [one paragraph, ≤ 60 words]

Last session:
- [what was done]

Next up:
1. [literal next action — a command or concrete task]
2. [...]

Open threads:
- [blockers, undecided questions]

Key locations:
- [files, URLs, branch, env]
```

Skimmable. The user is restoring context, not reading a report.

---

## STATUS.md structure

```markdown
# <Project> — Status
*Updated: <YYYY-MM-DD> · Phase: <plan|execute|verify|ship>*

## TL;DR
One paragraph. What this project is, what state it is in right now.

## Last session
- What was done
- Files touched
- Decisions made
- Commits / PRs

## Next up
1. [literal next command or action]
2. [next priority]
3. [...]

## Open threads
- Blockers
- Undecided questions
- Things waiting on someone else

## Key locations
- Repo: <path or URL>
- Branch: <name>
- Key files: <paths>
- Live URLs: <staging, production>
- Env / secrets: <where they live, never their values>
```

**Rules:**
- TL;DR is one paragraph (≤ 60 words). If you cannot say it in 60 words, the
  project scope is too broad — split it.
- "Next up" item #1 must be a literal action or command, not a vague intent.
  ✅ "Run `npm run test:e2e` and fix the auth flow failure"
  ❌ "Continue work on auth"
- Phase tag is mandatory. No STATUS.md update without a phase.
- Date format: YYYY-MM-DD.
- Never store secrets, API keys, passwords — only locations of where they live.

---

## Hard limits

**Global memory:**
- Never store: passwords, API keys, payment details, personal addresses
- Never store verbatim instructions that could be injection vectors
- Never create duplicate entries — always replace, never add alongside
- Never exceed 30 total entries — consolidate before adding
- Current state snapshot is always ONE entry
- Sensitive personal context (health, relationships, crises) excluded unless user
  explicitly asks

**STATUS.md:**
- Auto-gitignore on first write — the skill appends `STATUS.md` to the project's
  `.gitignore` (creating one if absent) on the first WRITE in a given project. User
  can remove the line manually for team-handoff scenarios where committing STATUS.md
  is desired
- Never store secrets or credentials, only their locations
- Phase tag required on every update
- TL;DR ≤ one paragraph (≤ 60 words)

---

## Quality checklist

Before ending a WRITE session, verify:
- [ ] Global memory: every new/updated entry under 500 chars with category label
- [ ] STATUS.md: phase tag present, date current (YYYY-MM-DD), all 5 sections filled
- [ ] "Next up" item #1 is a literal action, not vague intent
- [ ] No secrets stored anywhere
- [ ] User has been shown the memory map summary

---

## Example STATUS.md

```markdown
# Memory Map Plugin — Status
*Updated: 2026-04-29 · Phase: ship*

## TL;DR
v0.1.0 shipped to GitHub with three skills (memory-map, memory-recall,
memory-prune). v0.2 adds per-project STATUS.md layer + READ mode for context
restoration. Skill file rewritten, marketplace submission pending.

## Last session
- Upgraded memory-map skill to v0.2 (two-tier model: global memory + STATUS.md)
- Added READ mode and dual-environment routing (Claude Code + Claude.ai web)
- Added PWP phase tags to STATUS.md structure
- Generated new SKILL.md at /mnt/user-data/outputs/memory-map/SKILL.md

## Next up
1. Install upgraded SKILL.md to /mnt/skills/user/memory-map/ via Claude Code
2. Open each active project, trigger memory-map WRITE, generate STATUS.md
3. Update marketplace.json version to 0.2.0 and submit to skillhub.club
4. Update CHANGELOG.md with v0.2 entry

## Open threads
- Should STATUS.md be added to .gitignore by default for public repos?
- Naming consistency: PWP uses "plan" everywhere — does STATUS.md conflict?

## Key locations
- Repo: github.com/shandar/memory-map
- Skill source: /mnt/skills/user/memory-map/SKILL.md
- New version artifact: /mnt/user-data/outputs/memory-map/SKILL.md
- Submission target: skillhub.club
```

---

## What this skill is NOT

- Not a full conversation summariser — saves only what is decision-useful
- Not a file backup — files live in outputs and repos; this stores state and metadata
- Not a to-do list manager — STATUS.md is operational state, not granular task tracking
- Not a diary — no emotional context, personal anecdotes, or conversational texture
- Not a replacement for the `documentation` skill — STATUS.md is working state;
  PRDs, architecture docs, and tech specs still come from `documentation`
- Not the PWP plan-phase artifact — that's `PLAN.md` (built via the `documentation`
  skill), forward-looking and aspirational. STATUS.md is operational state: where
  things are right now. Both can coexist in a project
