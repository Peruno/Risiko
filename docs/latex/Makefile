.PHONY: all clean build watch help

# Variables
SRC_DIR = src
OUTPUT_DIR = output
IMAGES_DIR = images
TEX_FILE = main.tex
PDF_FILE = $(OUTPUT_DIR)/main.pdf

# Default target
all: build

# Build the PDF
build:
	@echo "Building LaTeX documentation..."
	@cd $(SRC_DIR) && pdflatex $(TEX_FILE) > /dev/null 2>&1
	@cd $(SRC_DIR) && pdflatex $(TEX_FILE) > /dev/null 2>&1
	@cp $(SRC_DIR)/main.pdf $(OUTPUT_DIR)/
	@echo "✅ PDF built: $(PDF_FILE)"

# Clean auxiliary files
clean:
	@echo "Cleaning auxiliary files..."
	@cd $(SRC_DIR) && rm -f *.aux *.log *.out *.synctex.gz *.fdb_latexmk *.fls
	@echo "✅ Cleaned"

# Watch for changes (requires fswatch)
watch:
	@echo "Watching for changes... (Press Ctrl+C to stop)"
	@fswatch -o $(SRC_DIR) $(IMAGES_DIR) | while read; do make build; done

# Help
help:
	@echo "Available targets:"
	@echo "  build  - Build the LaTeX document"
	@echo "  clean  - Clean auxiliary files"
	@echo "  watch  - Watch for changes and rebuild automatically"
	@echo "  help   - Show this help"