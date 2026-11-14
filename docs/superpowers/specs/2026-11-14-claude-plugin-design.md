# memory-map v0.2.0 as a Claude Code plugin — design

Status: Approved 2026-11-14 (Shandar)
Size: small change

## Intent

Make memory-map installable from the Claude Code plugin marketplace the way TRACE and PWP are, without changing what the skills do. Today the repo cannot be added as a marketplace: its root `marketplace.json` uses a custom schema Claude Code does not read, and there is no `.claude-plugin/` directory.

## Goals

1. **Repo root is the plugin.** Add `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` (marketplace name `memory-map-marketplace`, plugin `memory-map`, source `./`). Install: `/plugin marketplace add shandar/memory-map` then `/plugin install memory-map@memory-map-marketplace`. `skills/` stays in place so git history, `install.sh`, and existing links keep working.
2. **Delete the legacy root `marketplace.json`.** No tool reads its schema; it would read as a second, conflicting manifest.
3. **Fix Claude Code routing.** v0.2 `memory-map` writes the global tier only via `memory_user_edits`, which exists on claude.ai only. In Claude Code the global tier is `~/.claude/memory.md` (format per `references/claude-code.md`, unchanged from v0.1).
4. **Separate the two "catch me up" skills.** `memory-recall` = cross-project briefing from the global tier. `memory-map` READ = one project from its `STATUS.md`. Descriptions state the boundary.
5. **Four commands:** `/memory-map:save`, `/memory-map:status`, `/memory-map:recall`, `/memory-map:prune` — thin `commands/*.md` files that invoke the matching skill/mode.
6. **Docs:** every version string 0.2.0; CHANGELOG 0.2.0 entry; README leads with plugin install and warns against also running `install.sh`; `SUBMISSION.md` with pre-written form answers (TRACE precedent).

## Non-goals

- v0.3 (local mirror, `PROJECTS_INDEX.md`).
- Hooks — proactive triggers stay description-driven; no guaranteed SessionStart recall.
- Any change to what the skills store or how entries/STATUS.md are formatted.

## Anti-goals

- Anything that changes how existing users' `~/.claude/memory.md` or `STATUS.md` files are read.

## Approaches considered

| Approach | Trade-off | Outcome |
|---|---|---|
| A. Package v0.2 properly | Small, low-risk, lists fast | **Picked** |
| B. A + ship v0.3 specs | Bigger launch story; untested specs need their own design pass | Deferred |

Layout: root-as-plugin chosen over TRACE's `plugins/<name>/` layout, which exists only because TRACE ships two editions.

## Calls made by Claude (overridable)

- Work in a fresh clone at `~/Downloads/memory-map-repo`, branch `feature/claude-plugin`, one commit per concern. No push until reviewed.
- Author email `hello@affordance.design` (matches TRACE manifests).
- No icon in this release.
- Boundary refinement: in Claude Code, a project counts as "named" when the cwd has a `STATUS.md`, so "where did I leave off" inside a project routes to `memory-map` READ; with no project named and no `STATUS.md` in cwd, it routes to `memory-recall`.

## Verification

`claude plugin validate .`, manifest comparison against TRACE, local install from the folder, and a scripted check of each command's trigger.
