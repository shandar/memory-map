# Memory Prune — claude.ai Storage Guide

Storage mechanism: `memory_user_edits`

---

## Reading memory

```
memory_user_edits(command="view")
```

---

## Applying approved changes

**Order matters.** Line numbers shift after every operation. Apply in this order:

### 1. Replace operations first
Replacing preserves line numbers, so do all consolidations before any removals:
```
memory_user_edits(command="replace", line_number=N, replacement="LABEL — content")
```

### 2. Remove operations last, in DESCENDING line number order
Removing from highest to lowest preserves the line numbers of the entries below:

```
# WRONG — line numbers shift mid-loop, you'll delete the wrong entries
memory_user_edits(command="remove", line_number=5)
memory_user_edits(command="remove", line_number=12)  # was 13 before previous remove

# RIGHT — descending order, line numbers stable below cursor
memory_user_edits(command="remove", line_number=13)
memory_user_edits(command="remove", line_number=5)
```

### 3. Verify
After all operations, re-read memory and show the user the final state:
```
memory_user_edits(command="view")
```

---

## Limits

- 500 character max per entry — same as memory-map
- 30 entries max — pruning is essential when approaching this

---

## After pruning

Return to SKILL.md Step 6 and present the result to the user.
