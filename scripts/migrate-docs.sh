#!/bin/bash
# Migrate dev documentation files to .claude/docs/
# Run this ONCE from the project root to reorganize docs.
# After running, commit with: git add -A && git commit -m "chore: move dev docs to .claude/docs/"

set -euo pipefail

DOCS_DIR=".claude/docs"

echo "=== Migrating dev docs to $DOCS_DIR ==="

mkdir -p "$DOCS_DIR"

# Move dev docs (preserve git history with git mv)
for f in CLAUDE2.md CLAUDE_FULL.md PLAN.md DESIGN_THEME.md audit_cms_claude_code.md; do
    if [ -f "$f" ]; then
        git mv "$f" "$DOCS_DIR/$f"
        echo "  Moved: $f -> $DOCS_DIR/$f"
    fi
done

# Rename current CLAUDE.md to full spec
if [ -f "CLAUDE.md" ]; then
    git mv "CLAUDE.md" "$DOCS_DIR/SPEC.md"
    echo "  Moved: CLAUDE.md -> $DOCS_DIR/SPEC.md"
fi

echo ""
echo "Done! Now create the new slim CLAUDE.md at root."
echo "Then commit: git add -A && git commit -m 'chore: move dev docs to .claude/docs/'"
