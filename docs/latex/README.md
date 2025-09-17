# LaTeX Document Structure

This directory contains the LaTeX recreation of the provided PDF document.

## Directory Structure

- `src/` - LaTeX source files
- `images/` - Images and figures used in the document
- `output/` - Generated PDF and auxiliary files

## Building the Document

To compile the LaTeX document:

```bash
cd docs/latex/src
pdflatex main.tex
pdflatex main.tex
pdflatex main.tex
```

Or use latexmk for automatic compilation:

```bash
latexmk -pdf main.tex
```