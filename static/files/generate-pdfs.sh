#!/bin/bash
# PDF Generation Script for Academic CV and Teaching Philosophy
#
# This script provides instructions and helpers for generating PDFs from markdown source files.
#
# Prerequisites:
#   Option 1: Install pandoc (recommended)
#     brew install pandoc basictex
#
#   Option 2: Use online converter
#     https://www.markdowntopdf.com/
#     https://www.zamzar.com/convert/md-to-pdf/
#
#   Option 3: Use VS Code with Markdown PDF extension
#     1. Install "Markdown PDF" extension
#     2. Open markdown file
#     3. Press Cmd+Shift+P > "Markdown PDF: Export (pdf)"

# Set source directory
SOURCE_DIR="../../academic"
OUTPUT_DIR="."

echo "🎓 Academic CV & Teaching Philosophy PDF Generator"
echo "=================================================="
echo ""

# Check if pandoc is available
if command -v pandoc &> /dev/null; then
    echo "✅ Pandoc found! Generating PDFs..."

    # Generate Academic CV PDF
    echo "📄 Generating Academic CV..."
    pandoc "$SOURCE_DIR/khaerov-academic-cv.md" \
        -o "$OUTPUT_DIR/khaerov-academic-cv.pdf" \
        --pdf-engine=pdflatex \
        -V geometry:margin=1in \
        -V fontsize=11pt \
        -V documentclass=article \
        --toc \
        --toc-depth=2

    # Generate Teaching Philosophy PDF
    echo "📖 Generating Teaching Philosophy Statement..."
    pandoc "$SOURCE_DIR/teaching-philosophy-statement.md" \
        -o "$OUTPUT_DIR/khaerov-teaching-philosophy.pdf" \
        --pdf-engine=pdflatex \
        -V geometry:margin=1in \
        -V fontsize=11pt \
        -V documentclass=article

    echo ""
    echo "✅ PDFs generated successfully!"
    echo "   - khaerov-academic-cv.pdf"
    echo "   - khaerov-teaching-philosophy.pdf"
else
    echo "❌ Pandoc not found."
    echo ""
    echo "📋 Manual PDF Generation Options:"
    echo ""
    echo "Option 1: Install Pandoc (recommended)"
    echo "  brew install pandoc basictex"
    echo "  Then run this script again."
    echo ""
    echo "Option 2: Online Converter"
    echo "  1. Open: https://www.markdowntopdf.com/"
    echo "  2. Upload: $SOURCE_DIR/khaerov-academic-cv.md"
    echo "  3. Save as: khaerov-academic-cv.pdf"
    echo "  4. Repeat for teaching-philosophy-statement.md"
    echo ""
    echo "Option 3: VS Code Extension"
    echo "  1. Install 'Markdown PDF' extension"
    echo "  2. Open markdown file"
    echo "  3. Cmd+Shift+P > 'Markdown PDF: Export (pdf)'"
    echo ""
    echo "Option 4: Print to PDF from Browser"
    echo "  1. Run: npm run dev"
    echo "  2. Open: http://localhost:1313/teaching"
    echo "  3. Print > Save as PDF"
fi

echo ""
echo "📁 Source files location:"
echo "   $SOURCE_DIR/khaerov-academic-cv.md"
echo "   $SOURCE_DIR/teaching-philosophy-statement.md"
echo ""
