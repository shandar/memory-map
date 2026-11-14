# Changelog

## [0.2.1] — 2026-11-14

### Plugin folder for directory review

**Changed**
- The plugin now lives in `plugins/memory-map/` and the repo root holds only the marketplace. The submitted plugin is markdown, JSON, and one PNG; `install.sh` and the icon's SVG source stay in the repo but are no longer part of the plugin
- The plugin has its own README for reviewers and users

**Removed**
- The `curl | bash` one-line install from the README. Clone the repo and run `bash install.sh` after reading it, or use the plugin

**Fixed**
- `install.sh` installs from the clone it runs in instead of re-downloading `main`, checks its source before touching `~/.claude/skills`, and fails loudly (`set -euo pipefail`)
- Backups of `~/.claude/memory.md` and of replaced skill folders are timestamped to the second, so a second save on the same day no longer overwrites the first backup
- The optional `CLAUDE.md` pointer is only added after the user says yes

Install commands are unchanged. Manual installs now copy from `plugins/memory-map/skills/`.

## [0.2.0] — 2026-11-14

### Claude Code plugin release

memory-map now installs as a Claude Code plugin:

```
/plugin install memory-map --marketplace shandar/memory-map
```

**Added**
- Two-tier memory: the global cross-project index plus a per-project `STATUS.md` (TL;DR, Last session, Next up, Open threads, Key locations), auto-added to `.gitignore` on first write
- READ mode in `memory-map`: a 30-second briefing that restores one project from its `STATUS.md`
- Plugin manifests at `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
- Commands: `/memory-map:save`, `/memory-map:status`, `/memory-map:recall`, `/memory-map:prune` (user-invoked only, so a plain "save this file" never fires a memory save)
- Project entries in the global index record a `Root:` path, so `/memory-map:status <project>` can find the project's `STATUS.md` from any folder without scanning the disk
- Claude Code backs up `~/.claude/memory.md` before every change and edits only the sections that change

**Fixed**
- Claude Code saves: the global tier now goes to `~/.claude/memory.md`. The v0.2 skill draft only called the claude.ai memory API, which Claude Code does not have
- `STATUS.md` and `.gitignore` are never written into the home folder; the skill asks for the project root instead

**Changed**
- `memory-recall` is the cross-project briefing; `memory-map` READ mode restores one project. "Where did I leave off" goes to `memory-map` when a project is named or the folder has a `STATUS.md`, and to `memory-recall` otherwise

**Removed**
- Root `marketplace.json`. Its custom schema was not read by any tool; the `.claude-plugin/` manifests replace it

Existing `~/.claude/memory.md` files are read as they are. No migration needed.

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
