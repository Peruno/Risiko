#!/bin/bash

LATEX_DIR="$(dirname "$0")"
SRC_DIR="$LATEX_DIR/src"
OUTPUT_DIR="$LATEX_DIR/output"
PDF_FILE="$OUTPUT_DIR/main.pdf"

if [ -f "$PDF_FILE" ]; then
    PDF_TIME=$(stat -f %m "$PDF_FILE" 2>/dev/null || stat -c %Y "$PDF_FILE" 2>/dev/null)
else
    PDF_TIME=0
fi

NEEDS_BUILD=false

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

    mkdir -p "$OUTPUT_DIR"

    cd "$SRC_DIR"

    if ! command -v pdflatex &> /dev/null; then
        echo "Error: pdflatex not found. Please install LaTeX."
        exit 1
    fi

    pdflatex -output-directory="$OUTPUT_DIR" main.tex > /dev/null 2>&1
    pdflatex -output-directory="$OUTPUT_DIR" main.tex > /dev/null 2>&1

    echo "✅ PDF regenerated: $PDF_FILE"
else
    echo "📄 PDF is up-to-date"
fi