# Memory Prune — Claude Code Storage Guide

Storage mechanism: `~/.claude/memory.md`

---

## Reading memory

```bash
cat ~/.claude/memory.md
```

---

## Backup before pruning

**Always create a timestamped backup first:**

```bash
cp ~/.claude/memory.md ~/.claude/memory.md.backup-$(date +%Y%m%d-%H%M%S)
```

This protects the user from any accidental data loss. Backups can be removed manually
later if not needed.

---

## Applying approved changes

Since we're working with a single markdown file, the safest approach is to **rewrite
the entire file** with the cleaned version rather than trying to edit in place.

### Step 1 — Build the cleaned content in memory

Construct the new file content with:
- All entries the user approved to keep
- Consolidated entries replacing the originals
- Renumbered headings (`## 1.`, `## 2.`, etc.) starting from 1
- Updated `Last updated:` date

### Step 2 — Write the new file

```bash
cat > ~/.claude/memory.md << 'EOF'
# Claude Memory Map
Last updated: [date]

## 1. CURRENT STATE SNAPSHOT (date)
[content]

## 2. [LABEL]
[content]

[... cleaned entries ...]
EOF
```

### Step 3 — Verify

```bash
cat ~/.claude/memory.md | head -20
wc -l ~/.claude/memory.md
```

Show the user the new line count and entry count to confirm the prune worked.

---

## Restoring from backup

If anything went wrong, the user can restore:

```bash
ls -la ~/.claude/memory.md.backup-*  # find the latest backup
cp ~/.claude/memory.md.backup-YYYYMMDD-HHMMSS ~/.claude/memory.md
```

---

## After pruning

Return to SKILL.md Step 6 and show the user:
- Lines before/after
- Entries before/after
- Backup file path (in case they want to restore later)
