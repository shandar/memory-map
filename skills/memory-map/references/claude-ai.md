# Memory Map — claude.ai Storage Guide

Storage mechanism: `memory_user_edits` tool (persistent across all conversations)

---

## Reading memory

```
memory_user_edits(command="view")
```

This returns a numbered list of all current entries. Note the line numbers — you will need
them for replace and remove operations.

---

## Writing memory

**Replace an existing entry** (always do this before adding new ones):
```
memory_user_edits(command="replace", line_number=N, replacement="LABEL — content")
```

**Add a new entry:**
```
memory_user_edits(command="add", control="LABEL — content")
```

**Remove a stale entry:**
```
memory_user_edits(command="remove", line_number=N)
```

---

## Constraints

- Max 500 characters per entry — hard limit enforced by the API
- Max 30 entries total — consolidate before adding if at limit
- If an entry would exceed 500 chars, split into two with related labels:
  `V2V EDITIONS (1/2) —` and `V2V EDITIONS (2/2) —`
- Always call `view` first — line numbers shift after every add/remove

---

## Example entries

```
P2P HYDERABAD EVENT — T-Hub 6F, Hitech City, Hyderabad. May 8+9 2025. 9:30 AM.
100+ reg, 60 seats. maps.app.goo.gl/xxx. forms.gle/xxx. hello@affordancedesign.in.
```

```
CURRENT STATE SNAPSHOT (April 2026) — P2P Hyderabad imminent: emails drafted Apr 28/
May 1/May 7/waitlist. Enterprise brief built with role cards. TIU brief complete.
Next: TIU detailed agenda, institutional brief.
```

---

## After writing

Return to SKILL.md Step 4 and present the memory map summary to the user.
