#!/bin/bash
# memory-map: local installer for Claude Code setups without the plugin system.
# Installs from the checkout this script lives in, so what you read is what you get.
# https://github.com/shandar/memory-map
#
# Usage (from a clone):  bash install.sh

set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${SCRIPT_DIR}/plugins/memory-map/skills"
STAMP="$(date +%Y%m%d-%H%M%S)"
SKILLS=(memory-map memory-recall memory-prune)

echo "──────────────────────────────────────────"
echo "  memory-map installer"
echo "  v0.2.1 · MIT · Affordance Design Studio"
echo "──────────────────────────────────────────"
echo ""

# Check the source before touching anything in ~/.claude
for skill in "${SKILLS[@]}"; do
  if [ ! -f "${SRC_DIR}/${skill}/SKILL.md" ]; then
    echo "✗ ${SRC_DIR}/${skill}/SKILL.md not found."
    echo "  Run this script from a full clone of the memory-map repo:"
    echo "    git clone https://github.com/shandar/memory-map.git && cd memory-map && bash install.sh"
    exit 1
  fi
done

mkdir -p "${SKILLS_DIR}"
echo "✓ Skills directory ready: ${SKILLS_DIR}"
echo ""
echo "→ Installing skills from ${SRC_DIR}"
for skill in "${SKILLS[@]}"; do
  if [ -e "${SKILLS_DIR}/${skill}" ]; then
    mv "${SKILLS_DIR}/${skill}" "${SKILLS_DIR}/${skill}.backup-${STAMP}"
    echo "  ⚠  ${skill} already existed, backed up to ${skill}.backup-${STAMP}"
  fi
  cp -R "${SRC_DIR}/${skill}" "${SKILLS_DIR}/${skill}"
  echo "  ✓ Installed ${skill}"
done

# Initialise memory.md if it does not exist
if [ ! -f "${CLAUDE_DIR}/memory.md" ]; then
  cat > "${CLAUDE_DIR}/memory.md" << 'EOF'
# Claude Memory Map
Last updated: never

(No entries yet. Use the memory-map skill at the close of any productive session
to start tracking project context across conversations.)
EOF
  echo "  ✓ Initialised ${CLAUDE_DIR}/memory.md"
fi

echo ""
echo "──────────────────────────────────────────"
echo "  ✓ memory-map installed"
echo "──────────────────────────────────────────"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code to load the new skills"
echo "  2. Try: 'what do you remember about my projects?'"
echo "  3. At session close: 'save this conversation'"
echo ""
echo "Backup folders (*.backup-*) still contain a SKILL.md. Delete them once you"
echo "are happy with the install, or the old skills load alongside the new ones."
echo ""
echo "Memory store: ${CLAUDE_DIR}/memory.md"
echo "Skills: ${SKILLS_DIR}/{memory-map,memory-recall,memory-prune}"
echo ""
