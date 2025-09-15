#!/bin/bash

# Setup git pre-commit hook for LaTeX document rebuilding

HOOK_FILE="../../.git/hooks/pre-commit"
PROJECT_ROOT="$(cd ../../ && pwd)"

cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash

# Check if LaTeX files have changed
LATEX_CHANGED=$(git diff --cached --name-only | grep -E "^docs/latex/(src/.*\.tex|images/.*)")

if [ -n "$LATEX_CHANGED" ]; then
    echo "LaTeX files changed, rebuilding documentation..."

    # Check if pdflatex is available
    if command -v pdflatex &> /dev/null; then
        docs/latex/build.sh

        # Add the generated PDF to the commit if it exists
        if [ -f "docs/latex/output/main.pdf" ]; then
            git add docs/latex/output/main.pdf
            echo "✅ Updated documentation added to commit"
        fi
    else
        echo "⚠️  pdflatex not found, skipping documentation build"
    fi
fi
EOF

chmod +x "$HOOK_FILE"
echo "✅ Git pre-commit hook installed"
echo "Now LaTeX documentation will rebuild automatically when you commit changes to docs/latex/"