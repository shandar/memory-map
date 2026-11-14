# memory-map: Plugin Directory Submission Notes

Pre-written answers for the Claude plugin directory submission form. Copy each block into the matching field.

**Before submitting:** add a square icon at `.claude-plugin/icon.png` (512 to 2048 px, PNG, under 2 MB). The directory takes the listing icon from the first submission only, and later changes do not update it. Then run:

```bash
claude plugin validate . --profile directory --strict
```

It must pass with zero warnings.

---

### Plugin name
```
memory-map
```

### Display name
```
Memory Map
```

### Short description
```
A complete memory loop for Claude. Snapshot, recall, and prune project context across sessions, so you never re-explain your project at the start of a conversation.
```

### Long description
```
Every new Claude session starts blank. You re-explain the project, re-state the decisions, re-list what is pending. Memory Map removes that tax.

It keeps memory in two tiers:
- A global cross-project index (~/.claude/memory.md in Claude Code) that answers "what am I working on across everything?"
- A STATUS.md in each project root that answers "where exactly did I leave off in this one?" (TL;DR, Last session, Next up, Open threads, Key locations)

Three skills, one loop:
- memory-map: snapshots the session at close, and restores one project from its STATUS.md
- memory-recall: a cross-project briefing at the start of a session
- memory-prune: proposes a cleanup of stale entries, and changes nothing without your yes

Commands: /memory-map:save, /memory-map:status, /memory-map:recall, /memory-map:prune.

Markdown only. No hooks, no scripts, no network calls, no API keys.
```

### Category
```
productivity
```

### Keywords
```
memory, context, session-management, status, productivity
```

### Author
```
Shandar Junaid · Affordance Design Studio
hello@affordance.design
https://affordance.design
```

### Repository / homepage
```
https://github.com/shandar/memory-map
```

### License
```
MIT
```

### Version
```
0.2.0
```

### Install
```
/plugin install memory-map --marketplace shandar/memory-map
```

### Why install it
```
Context survives long absences. Come back to a project after three weeks, run /memory-map:status, and get a 30-second briefing with the literal next action, instead of reading your own commit history to remember what you were doing.
```

### Security and permissions
```
Memory Map is markdown only: three skills and four commands, with no hooks, scripts, MCP servers, or network access. It reads and writes only:
- ~/.claude/memory.md (the global index, in Claude Code)
- STATUS.md and .gitignore in the current project root (it asks first if the folder is not a project, and never writes to the home folder)
On claude.ai it uses the built-in memory tool and produces STATUS.md as an artifact. The skills never store passwords, API keys, or payment details, only where such things live. Pruning always asks for confirmation and backs up memory.md first.
```
