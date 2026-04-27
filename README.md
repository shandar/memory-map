# memory-map

**A complete memory loop for Claude. Snapshot, recall, and prune project context across sessions.**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.0-orange.svg)](https://github.com/shandar/memory-map/releases)
[![Compatible](https://img.shields.io/badge/works%20with-Claude%20Code%20%7C%20claude.ai-blue.svg)](#install)
[![SKILL.md](https://img.shields.io/badge/format-SKILL.md-purple.svg)](https://docs.claude.com)

Three skills, bundled as one plugin. Works in claude.ai, Claude Code, Cursor, Windsurf, and Codex CLI.

---

## The problem

Every new Claude conversation starts blank.

You re-explain your project. You re-describe what you are building. You re-state the decisions you already made. Every. Single. Time.

It is a tax on every session. And it gets worse the longer your project runs.

## The fix

Three skills that give Claude a working memory across sessions:

| Skill | What it does | When it triggers |
|-------|--------------|------------------|
| **memory-map** | Snapshots your session — what was built, decided, pending — to persistent memory | At session close, or when you say "save this" |
| **memory-recall** | Loads stored memory and surfaces what is relevant right now | At session start, or when you ask "what do you remember?" |
| **memory-prune** | Identifies stale entries and proposes a cleanup, with your confirmation | When memory gets cluttered, or on request |

The loop: **write → recall → prune.** Together they make Claude feel like it actually remembers your work.

---

## Works everywhere

Same protocol, two storage backends, detected automatically:

| Environment | Storage |
|-------------|---------|
| **claude.ai** | Persistent memory API (`memory_user_edits`) |
| **Claude Code** | Local file at `~/.claude/memory.md` |

Compatible with the open SKILL.md format, also works in Cursor, Windsurf, Codex CLI, and any tool that supports Anthropic's Agent Skills spec.

---

## Install

### Claude Code (one line)

```bash
curl -fsSL https://raw.githubusercontent.com/shandar/memory-map/main/install.sh | bash
```

The installer clones the repo, copies all three skills to `~/.claude/skills/`, initialises `~/.claude/memory.md`, and backs up any pre-existing skill folders.

### Claude Code (manual)

```bash
git clone https://github.com/shandar/memory-map.git
cd memory-map
cp -r skills/* ~/.claude/skills/
```

Restart Claude Code. The skills load automatically.

### claude.ai

Each skill installs separately on claude.ai:

1. Download the [latest release](https://github.com/shandar/memory-map/releases)
2. Extract the archive
3. Open Settings → Skills → Install from file
4. Upload `skills/memory-map/SKILL.md`, then `memory-recall/SKILL.md`, then `memory-prune/SKILL.md`

After all three are installed, they trigger automatically based on what you say.

---

## Usage

After install, just talk normally. The skills trigger themselves.

### At the start of a session

```
You: "Hey, what do you remember about my P2P workshop?"

Claude: Picking up where we left off:

Current state — P2P Hyderabad May 8+9, 100+ registrations for 60 seats.
Confirmation emails drafted for Apr 28 / May 1 / May 7 / waitlist.

Pending items:
→ TIU detailed agenda
→ Chitkara V2V edition collateral
→ Plugin v0.2 release

Active projects: P2P Hyderabad, V2V Enterprise, memory-map plugin.
```

### At the end of a session

```
You: "Save this conversation"

Claude: MEMORY MAP — updated April 27 2026

UPDATED  →  P2P Hyderabad event (4 emails confirmed)
UPDATED  →  Current state snapshot
NEW      →  Enterprise pitch emails (2 variants)
──────────────────────────────────────────────────
UNCHANGED: 14 entries
```

### When memory gets cluttered

```
You: "Clean up the memory"

Claude: MEMORY PRUNE — proposed changes

REMOVE (stale)
→ Entry 18: TIU registration link (event closed)
→ Entry 12: P2P landing page draft v1 (superseded by v2)

CONSOLIDATE
→ Entries 9 + 10 → single "V2V EDITIONS" entry

KEEP all 14 operating preference entries

Apply these changes? [yes / modify / cancel]
```

---

## Trigger phrases

The skills activate on natural language, no commands to memorise.

| Skill | Trigger phrases |
|-------|----------------|
| **memory-map** | save this · snapshot this · memorise this chat · update your memory · store this session · don't lose this context |
| **memory-recall** | what do you remember · what's the context · where did we leave off · catch me up · show me the memory map |
| **memory-prune** | clean up memory · prune memory · consolidate memory · trim the memory map |

All three also fire **proactively** when conditions are right, at the close of a productive session, at the start of a new one, or when memory is approaching its limits.

---

## How memory is stored

### Claude Code: `~/.claude/memory.md`

Plain markdown, readable, editable, version-controllable:

```markdown
# Claude Memory Map
Last updated: April 27 2026

## 1. CURRENT STATE SNAPSHOT (April 2026)
P2P Hyderabad May 8+9 imminent: confirmation emails drafted. Enterprise brief
built with role cards. Memory plugin v0.1 ready to ship.

## 2. P2P HYDERABAD EVENT
T-Hub 6F, Hitech City. May 8+9 2025. 9:30 AM. 100+ reg, 60 seats.

## 3. PWP OPERATING PROTOCOL
Plan, execute, verify, ship. AI proposes, user decides. No code without a plan.
```

You can edit this file directly. memory-prune will respect your edits.

### claude.ai: Persistent memory API

Stored via Anthropic's `memory_user_edits` tool. Visible in Settings → Memory. Works the same way functionally, same category labels, same density rules, just managed via API instead of file.

---

## Design principles

- **Proactive, not reactive**, skills run when they should, without being asked
- **Replace over accumulate**, stale entries are replaced, never stacked
- **Density over prose**, every entry is scannable, fact-packed, no filler
- **One source of truth**, `CURRENT STATE SNAPSHOT` is always exactly one entry
- **Confirm before destruction**, memory-prune always proposes, never deletes autonomously
- **Environment-aware**, same skill, right storage for the right tool

---

## Repository structure

```
memory-map/
├── README.md                          ← you are here
├── LICENSE                            ← MIT
├── CHANGELOG.md                       ← version history
├── CONTRIBUTING.md                    ← how to contribute
├── marketplace.json                   ← plugin manifest
├── install.sh                         ← one-line installer
└── skills/
    ├── memory-map/
    │   ├── SKILL.md
    │   └── references/
    │       ├── claude-ai.md           ← memory_user_edits API
    │       └── claude-code.md         ← ~/.claude/memory.md file
    ├── memory-recall/
    │   ├── SKILL.md
    │   └── references/
    │       ├── claude-ai.md
    │       └── claude-code.md
    └── memory-prune/
        ├── SKILL.md
        └── references/
            ├── claude-ai.md
            └── claude-code.md
```

Each skill is self-contained and can be used independently. The plugin bundles them for one-command install.

---

## Roadmap

- [x] **v0.1**, memory-map, memory-recall, memory-prune
- [ ] **v0.2**, multi-project memory (separate stores per repo or workspace)
- [ ] **v0.3**, memory export/import for sharing project context across teams
- [ ] **v0.4**, memory diffing across sessions ("what changed since last week?")

Track progress in [issues](https://github.com/shandar/memory-map/issues) and [discussions](https://github.com/shandar/memory-map/discussions).

---

## Built by

[Shandar Junaid](https://shandarjunaid.com), Founder, [Affordance Design Studio](https://affordance.design), [Vibe Coding School](https://vibecodingschool.in)

If you build on top of this, I would love to see what you make. Tag me on [LinkedIn](https://www.linkedin.com/in/shandarjunaid/) or [X](https://x.com/shandarjunaid).

---

## License

MIT, use it, fork it, extend it. See [LICENSE](LICENSE).

---

## Credits

The SKILL.md format and Agent Skills specification are from Anthropic. This plugin is an independent open-source project, not affiliated with Anthropic.
