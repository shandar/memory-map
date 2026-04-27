# Changelog

## [0.1.0] — 2026-04-27

### Initial release — Memory Map plugin

A complete memory loop for Claude. Three skills bundled as one plugin.

**Skills included:**
- `memory-map` — snapshot project context to persistent memory at session close
- `memory-recall` — load and summarise stored memory at session start or on demand
- `memory-prune` — clean stale, redundant, or outdated entries (with confirmation)

**Features:**
- Dual environment support — claude.ai (memory API) + Claude Code (`~/.claude/memory.md`)
- Automatic environment detection in every skill
- SKILL.md format — works in Claude Code, Cursor, Windsurf, Codex CLI
- Plugin manifest (`marketplace.json`) for one-command install
- Tier-based recall surfacing (always / on context / on relevance)
- Confirmation-required pruning with automatic backup (Claude Code)
- Safe operation ordering (replace before remove, descending line numbers)

**Design principles:**
- Proactive triggering — skills run when they should, without being asked
- Replace over accumulate
- Density over prose
- One source of truth (`CURRENT STATE SNAPSHOT`)
- Confirm before destructive operations

### Coming next (v0.2 roadmap)

- Multi-project memory — separate memory stores per repo or workspace
- Memory export/import for sharing project context across teams
- Memory diffing across sessions ("what changed since last week?")
