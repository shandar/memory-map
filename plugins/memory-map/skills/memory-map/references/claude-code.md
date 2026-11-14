# Memory Map — Claude Code Storage Guide

Storage mechanism: `~/.claude/memory.md` — a structured markdown file persisted
across all Claude Code sessions. If the file does not exist, create it.

---

## Reading memory

```bash
cat ~/.claude/memory.md 2>/dev/null || echo "(empty — no memory file yet)"
```

Parse the file as numbered sections. Each entry is a `## N. LABEL` block.
Note existing entry numbers before writing.

---

## File format

```markdown
# Claude Memory Map
Last updated: [date]

## 1. CURRENT STATE SNAPSHOT (date)
[content]

## 2. PROJECT DELIVERABLES
[content]

## 3. EVENT DETAILS
[content]
```

Rules:
- Each entry is a `## N. CATEGORY LABEL` heading followed by one paragraph of content
- Entries are dense, fact-packed, no prose
- Max ~300 characters per entry body (keep it scannable)
- File should stay under 200 lines total

---

## Writing memory

**Read first, always:**
```bash
cat ~/.claude/memory.md
```

**Back up before any change:**
```bash
[ -f ~/.claude/memory.md ] && cp ~/.claude/memory.md ~/.claude/memory.md.backup-$(date +%Y%m%d-%H%M%S)
```

**Edit only the sections that change.** Use your file-edit tool to replace a single
`## N. LABEL` section in place, so entries you are not changing are never retyped.

**Create the file only when it does not exist yet:**
```bash
cat > ~/.claude/memory.md << 'EOF'
# Claude Memory Map
Last updated: [date]

## 1. CURRENT STATE SNAPSHOT ([date])
[content]

## 2. [LABEL]
[content]

[... all entries ...]
EOF
```

**Or append a new entry:**
```bash
cat >> ~/.claude/memory.md << 'EOF'

## N. NEW LABEL
[content]
EOF
```

---

## Constraints

- No hard character limit per entry, but keep each under 300 chars for scannability
- No hard entry limit, but keep total file under 200 lines
- `CURRENT STATE SNAPSHOT` is always entry #1, always replaced
- After writing, always verify with `cat ~/.claude/memory.md`

---

## CLAUDE.md integration (optional)

If the project has a `CLAUDE.md` without this pointer, ask the user once whether to add it. Add it at the top only after a yes; never edit `CLAUDE.md` without asking:

```markdown
## Persistent Memory
See ~/.claude/memory.md for cross-session project state and snapshots.
```

This ensures Claude Code loads the pointer even if it does not auto-read memory.md.

---

## After writing

Return to SKILL.md Step 4 (update STATUS.md), then Step 5 (present the memory map summary to the user).
