#!/bin/bash
# memory-map plugin — local installer for Claude Code
# https://github.com/shandar/memory-map

set -e

CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
REPO_URL="https://github.com/shandar/memory-map.git"
TEMP_DIR="$(mktemp -d)"

echo "──────────────────────────────────────────"
echo "  memory-map plugin installer"
echo "  v0.1.0 · MIT · Affordance Design Studio"
echo "──────────────────────────────────────────"
echo ""

# Create skills directory if it doesn't exist
mkdir -p "${SKILLS_DIR}"
echo "✓ Skills directory ready: ${SKILLS_DIR}"

# Clone the repo to a temp location
echo ""
echo "→ Cloning memory-map..."
git clone --depth 1 "${REPO_URL}" "${TEMP_DIR}/memory-map" 2>&1 | sed 's/^/  /'

# Install each skill
echo ""
echo "→ Installing skills..."
for skill in memory-map memory-recall memory-prune; do
  if [ -d "${SKILLS_DIR}/${skill}" ]; then
    echo "  ⚠  ${skill} already exists — backing up to ${skill}.backup-$(date +%Y%m%d)"
    mv "${SKILLS_DIR}/${skill}" "${SKILLS_DIR}/${skill}.backup-$(date +%Y%m%d)"
  fi
  cp -r "${TEMP_DIR}/memory-map/skills/${skill}" "${SKILLS_DIR}/${skill}"
  echo "  ✓ Installed ${skill}"
done

# Initialise memory.md if it doesn't exist
if [ ! -f "${CLAUDE_DIR}/memory.md" ]; then
  cat > "${CLAUDE_DIR}/memory.md" << 'EOF'
# Claude Memory Map
Last updated: never

(No entries yet. Use the memory-map skill at the close of any productive session
to start tracking project context across conversations.)
EOF
  echo "  ✓ Initialised ${CLAUDE_DIR}/memory.md"
fi

# Cleanup
rm -rf "${TEMP_DIR}"

echo ""
echo "──────────────────────────────────────────"
echo "  ✓ memory-map plugin installed"
echo "──────────────────────────────────────────"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code to load the new skills"
echo "  2. Try: 'what do you remember about my projects?'"
echo "  3. At session close: 'save this conversation'"
echo ""
echo "Memory store: ${CLAUDE_DIR}/memory.md"
echo "Skills: ${SKILLS_DIR}/{memory-map,memory-recall,memory-prune}"
echo ""
