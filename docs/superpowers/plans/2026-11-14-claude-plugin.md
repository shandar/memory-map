# memory-map v0.2.0 Claude Code Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the memory-map repo installable as a Claude Code plugin marketplace, at v0.2.0, with working Claude Code storage routing.

**Architecture:** The repo root is both the marketplace and the single plugin (`source: "./"`). Markdown only: skills, four slash commands, manifests. No hooks, scripts, or MCP.

**Tech Stack:** Claude Code plugin manifests (JSON), SKILL.md, command markdown.

**Spec:** `docs/superpowers/specs/2026-11-14-claude-plugin-design.md`

## Global Constraints

- Version string everywhere: `0.2.0`.
- Plugin name `memory-map`; marketplace name `memory-map-marketplace`; source `./`.
- Author `Shandar Junaid`, email `hello@affordance.design`, url `https://github.com/shandar`; homepage/repository `https://github.com/shandar/memory-map`; license `MIT`; category `productivity`.
- No change to entry format in `~/.claude/memory.md` or STATUS.md structure.
- Copy follows human-voice rules: no em dashes in new prose, no contractions ("it is", not "it's").
- Gate for every task: `claude plugin validate . --profile directory --strict` exits 0.
- Commits: `type(scope): description`, ending with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Review Focus

1. Claude Code user upgrading with a v0.1 `~/.claude/memory.md` → save/recall read it unchanged, no reformat. (Task 2 check)
2. Claude Code user with no `~/.claude/memory.md` → save creates it with the v0.1 header, does not error. (Task 2 check)
3. "Where did I leave off" in a folder with `STATUS.md` → memory-map READ, not memory-recall; in `~` with no STATUS.md → memory-recall. (Task 3 check)
4. Save run from `~` or a non-project folder → asks for the project root, never writes `~/STATUS.md` or `~/.gitignore`. (Task 2 check)
5. User who previously ran `install.sh` then installs the plugin → README tells them to remove `~/.claude/skills/memory-{map,recall,prune}`. (Task 5 check)

---

### Task 1: Plugin and marketplace manifests

**Files:**
- Create: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`
- Delete: `marketplace.json` (legacy schema)

**Interfaces:**
- Produces: plugin id `memory-map@memory-map-marketplace`; command namespace `/memory-map:*`.

- [ ] **Step 1:** Write `plugin.json` with name, version, description (one paragraph: three skills, two tiers, nothing deleted without confirmation), author object, homepage, repository, license, keywords `["memory","context","session-management","status","productivity"]`. Mirror field order of `~/Downloads/Trace/plugins/trace-prd/.claude-plugin/plugin.json`.
- [ ] **Step 2:** Write `marketplace.json` with `name`, `owner`, `metadata {description, version}`, and one `plugins[]` entry (source `./`, category, keywords, same author/homepage/license). Mirror TRACE's `.claude-plugin/marketplace.json`.
- [ ] **Step 3:** `git rm marketplace.json`.
- [ ] **Step 4:** Run `claude plugin validate . --profile directory --strict`. Expected: `✔ Validation passed`, no MANIFEST_NOT_FOUND note. Also `claude plugin validate .claude-plugin/marketplace.json` passes.
- [ ] **Step 5:** Commit `feat(plugin): add Claude Code plugin and marketplace manifests`.

### Task 2: Claude Code storage routing in memory-map

**Files:**
- Modify: `skills/memory-map/SKILL.md` (model table ~L27-32, Environment routing ~L62-78, WRITE Step 3 ~L101-123, Step 4 ~L125, Hard limits ~L255-262)

**Interfaces:**
- Consumes: `skills/memory-map/references/claude-code.md` and `references/claude-ai.md` (unchanged).

- [ ] **Step 1:** Model table: Global tier "Where it lives" = "claude.ai: memory API (`memory_user_edits`) · Claude Code: `~/.claude/memory.md`".
- [ ] **Step 2:** Environment routing: add detection rule copied from memory-recall Step 0 (`memory_user_edits` available → claude.ai, else Claude Code) and "read the matching file in `references/` before writing".
- [ ] **Step 3:** WRITE Step 3: split into "claude.ai" (existing text) and "Claude Code" (read `~/.claude/memory.md`, create with the v0.1 header if absent, edit `## N. LABEL` sections per `references/claude-code.md`; replace before add; keep under 200 lines).
- [ ] **Step 4:** WRITE Step 4 (Claude Code): add "If cwd is `~` or has no project markers (`.git`, `package.json`, `CLAUDE.md`, `STATUS.md`), ask for the project root before writing STATUS.md or .gitignore."
- [ ] **Step 5:** Hard limits: "30 total entries" applies to claude.ai; Claude Code limit is 200 lines.
- [ ] **Step 6: Check:** `grep -n "memory.md" skills/memory-map/SKILL.md` shows the Claude Code path in table, routing, and Step 3; `grep -c "memory_user_edits" skills/memory-map/SKILL.md` lines are all inside claude.ai branches. Scenario check (Review Focus 1, 2, 4): in a scratch dir with `HOME` unchanged, read the skill as the model would and confirm each path has one unambiguous instruction.
- [ ] **Step 7:** Validate gate, then commit `fix(memory-map): route global tier to ~/.claude/memory.md in Claude Code`.

### Task 3: Recall boundary

**Files:**
- Modify: `skills/memory-map/SKILL.md` frontmatter description + READ Step 1 (~L170-175)
- Modify: `skills/memory-recall/SKILL.md` frontmatter description + new "Scope" section after the intro

- [ ] **Step 1:** memory-map description: READ triggers become "catch me up on [project]", "[project] status", "restore context", and "where did I leave off" when the cwd has a STATUS.md. Add: "For a cross-project overview use memory-recall."
- [ ] **Step 2:** memory-recall description: keep "what do you remember", "show me the memory map", "what do you know about my projects", start-of-session; keep "where did we leave off" / "catch me up" only "when no project is named and the current folder has no STATUS.md". Add: "For one project's STATUS.md use memory-map."
- [ ] **Step 3:** memory-map READ Step 1: replace "ask which project, OR present the global snapshot" with "cwd has STATUS.md → that project; else hand off to memory-recall."
- [ ] **Step 4:** memory-recall Scope section: two-line rule mirroring Step 3, plus "In Claude Code, if cwd has a STATUS.md, mention it in the briefing."
- [ ] **Step 5: Check (Review Focus 3):** both descriptions name each other; neither lists an unconditional "catch me up". `grep -n "catch me up\|leave off" skills/*/SKILL.md` shows only conditioned uses.
- [ ] **Step 6:** Validate gate, commit `refactor(skills): separate cross-project recall from per-project restore`.

### Task 4: Slash commands

**Files:**
- Create: `commands/save.md`, `commands/status.md`, `commands/recall.md`, `commands/prune.md`

**Interfaces:**
- Produces: `/memory-map:save`, `/memory-map:status [project]`, `/memory-map:recall [topic]`, `/memory-map:prune`.

- [ ] **Step 1:** Each file: frontmatter `description` (one line) and `argument-hint` where it takes an argument; body = "Use the <skill> skill in <mode> mode" + `$ARGUMENTS` passthrough + one line of the mode's key rule (save: show the memory map summary at the end; prune: propose, never delete without a yes). Format per `~/Downloads/Trace/plugins/trace-prd/commands/init.md`.
- [ ] **Step 2: Check:** `claude plugin details .` (or validate output) lists 3 skills and 4 commands.
- [ ] **Step 3:** Validate gate, commit `feat(plugin): add save, status, recall and prune commands`.

### Task 5: Release docs

**Files:**
- Modify: `README.md` (badge L6, Install section, Repository structure, Roadmap L228-229), `CHANGELOG.md`, `install.sh` L14, `CONTRIBUTING.md` L3 (the example STATUS.md inside `skills/memory-map/SKILL.md` stays untouched: it is illustrative history)
- Create: `SUBMISSION.md`
- Add: `docs/superpowers/specs/…`, `docs/superpowers/plans/…`

- [ ] **Step 1:** README: badge 0.2.0; Install leads with the two `/plugin` commands, then commands table, then "Already used install.sh? Remove `~/.claude/skills/memory-{map,recall,prune}` first so skills do not load twice" (Review Focus 5); manual/curl install kept under "Without the plugin system"; Repository structure shows `.claude-plugin/` and `commands/`; Roadmap marks v0.2 done (two-tier + STATUS.md + plugin) and lists v0.3 (local mirror, projects index).
- [ ] **Step 2:** CHANGELOG `[0.2.0] — 2026-11-14`: Added (STATUS.md tier, READ mode, plugin manifests, commands), Fixed (Claude Code global tier), Changed (recall boundary), Removed (legacy marketplace.json).
- [ ] **Step 3:** install.sh banner `v0.2.0`; CONTRIBUTING roadmap reference → v0.3.
- [ ] **Step 4:** SUBMISSION.md modelled on `~/Downloads/Trace/SUBMISSION.md`: name, display name, short + long description, install commands, categories, keywords, privacy note (all data stays in `~/.claude/memory.md`, project STATUS.md, or claude.ai memory; no network calls).
- [ ] **Step 5: Check:** `grep -rn "0\.1\.0" --exclude=CHANGELOG.md --exclude-dir=.git --exclude-dir=docs .` returns only the illustrative example in `skills/memory-map/SKILL.md`.
- [ ] **Step 6:** Validate gate, commit `docs(release): v0.2.0 plugin install, changelog and submission notes`.

### Task 6: Verification

- [ ] **Step 1:** `claude plugin validate . --profile directory --strict` → passes, zero warnings.
- [ ] **Step 2:** `claude plugin details .` → 3 skills, 4 commands; note token cost.
- [ ] **Step 3:** Local install test (user approval needed, it changes their Claude Code config): `claude plugin marketplace add ~/Downloads/memory-map-repo`, `claude plugin install memory-map@memory-map-marketplace`, confirm listed, then uninstall and remove the marketplace.
- [ ] **Step 4:** Report diff summary (`git log --oneline main..`, `git diff --stat main`) for review. No push.
