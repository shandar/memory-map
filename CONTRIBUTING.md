# Contributing to memory-map

Thanks for taking interest. This is an open project under MIT — contributions are welcome, especially around the v0.2 roadmap items.

## Ways to contribute

- **Try it and break it.** Use it in a long-running project for a week and file issues for anything that feels off.
- **Improve trigger detection.** If a phrase that should trigger a skill is missing, suggest it via issue.
- **Port to other tools.** If you get this working in Cline, Aider, or another SKILL.md-compatible tool, share the install steps in a PR.
- **Add a new skill.** The plugin is built around the write/recall/prune loop. Adjacent skills that fit (memory-export, memory-diff, memory-search) are welcome.

## Before you open a PR

1. Open an issue first to align on the approach. This saves rework.
2. Test in both environments (claude.ai and Claude Code) where applicable.
3. Keep changes scoped — one skill or one feature per PR.
4. Update `CHANGELOG.md` under an `[Unreleased]` heading.

## Skill design principles

When adding or modifying skills, stay consistent with the plugin's design:

- **Proactive triggers** — skills should run when they should, without being asked
- **Replace over accumulate** — never stack duplicate entries
- **Density over prose** — every memory entry is fact-packed, scannable
- **Confirm before destruction** — anything that removes data must propose first
- **Environment-aware** — same protocol, right storage backend

## Code style

There is no code in the traditional sense — these are markdown skills. But:

- YAML frontmatter must be valid (test with any YAML linter)
- Trigger lists in `description:` should be comprehensive but not over-broad
- References in `references/*.md` should be self-contained — assume the user clicked through without reading SKILL.md first

## Reporting issues

Use the issue templates. Include:
- Which environment (claude.ai / Claude Code / other)
- Plugin version
- A minimal reproduction
- Memory file contents if relevant (redact sensitive entries)

## Questions

Open a discussion or reach out at hello@affordancedesign.in.

---

This project follows a "ship and iterate" rhythm. Small, frequent releases over big planned ones.
