# memory-map

A complete memory loop for Claude. Snapshot, recall, and prune project context across sessions, so you never re-explain your project at the start of a conversation.

## Install

```
/plugin install memory-map --marketplace shandar/memory-map
```

On older Claude Code versions:

```
/plugin marketplace add shandar/memory-map
/plugin install memory-map@memory-map-marketplace
```

If you previously copied the skills into `~/.claude/skills/`, remove `memory-map`, `memory-recall`, `memory-prune`, and any `memory-*.backup-*` folders there first, so the skills do not load twice.

## How it works

Two tiers:

| Tier | Where | Answers |
|------|-------|---------|
| Global index | `~/.claude/memory.md` (Claude Code) or the claude.ai memory tool | What am I working on across everything? |
| Per project | `STATUS.md` in the project root | Where exactly did I leave off in this one? |

Three skills:

- **memory-map** saves the session at close, and restores one project from its `STATUS.md`
- **memory-recall** gives a cross-project briefing at the start of a session
- **memory-prune** proposes a cleanup of stale entries and changes nothing without your yes

## Commands

| Command | What it does |
|---------|--------------|
| `/memory-map:save` | Snapshot this session: global index + this project's `STATUS.md` |
| `/memory-map:status [project]` | Restore one project from its `STATUS.md` |
| `/memory-map:recall [topic]` | Cross-project briefing from memory |
| `/memory-map:prune` | Propose a cleanup; nothing changes without your yes |

You can also just talk: "save this", "catch me up on [project]", "what do you remember".

## What it touches

Markdown only: no hooks, scripts, MCP servers, or network calls. In Claude Code it reads and writes `~/.claude/memory.md` (with a dated backup before each change), and `STATUS.md` plus `.gitignore` in the project root. It asks for the project root if the current folder is not a project, and never writes those files into your home folder. It never stores passwords, API keys, or payment details, only where such things live.

## More

Source, changelog, and issues: https://github.com/shandar/memory-map

MIT licensed. Built by Shandar Junaid, Affordance Design Studio.
