#!/bin/bash

# Build LaTeX document if sources have changed
LATEX_DIR="$(dirname "$0")"
SRC_DIR="$LATEX_DIR/src"
OUTPUT_DIR="$LATEX_DIR/output"
PDF_FILE="$OUTPUT_DIR/main.pdf"

# Check if PDF exists and get its timestamp
if [ -f "$PDF_FILE" ]; then
    PDF_TIME=$(stat -f %m "$PDF_FILE" 2>/dev/null || stat -c %Y "$PDF_FILE" 2>/dev/null)
else
    PDF_TIME=0
fi

# Check if any source files are newer than the PDF
NEEDS_BUILD=false

# Check LaTeX source files
for file in "$SRC_DIR"/*.tex; do
    if [ -f "$file" ]; then
        FILE_TIME=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null)
        if [ "$FILE_TIME" -gt "$PDF_TIME" ]; then
            NEEDS_BUILD=true
            echo "Source file $file has changed"
            break
        fi
    fi
done

# Check image files
if [ "$NEEDS_BUILD" = false ]; then
    for file in "$LATEX_DIR/images"/*; do
        if [ -f "$file" ]; then
            FILE_TIME=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null)
            if [ "$FILE_TIME" -gt "$PDF_TIME" ]; then
                NEEDS_BUILD=true
                echo "Image file $file has changed"
                break
            fi
        fi
    done
fi

if [ "$NEEDS_BUILD" = true ] || [ "$1" = "--force" ]; then
    echo "Building LaTeX document..."
    cd "$SRC_DIR"

    # Check if pdflatex is available
    if ! command -v pdflatex &> /dev/null; then
        echo "Error: pdflatex not found. Please install LaTeX."
        exit 1
    fi

    # Build twice for references
    pdflatex main.tex > /dev/null 2>&1
    pdflatex main.tex > /dev/null 2>&1

    # Ensure output directory exists and copy PDF
    mkdir -p "$OUTPUT_DIR"
    cp main.pdf "$OUTPUT_DIR/"

    echo "✅ PDF regenerated: $PDF_FILE"
else
    echo "📄 PDF is up-to-date"
fi