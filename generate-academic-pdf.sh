#!/bin/bash
# Generate Academic CV PDF from website

echo "🎓 Academic CV PDF Generator"
echo "============================"
echo ""

# Check if Hugo dev server is running
if ! curl -s http://localhost:1313/ >/dev/null 2>&1; then
    echo "⚠️  Hugo dev server not running. Starting it now..."
    npm run dev &
    sleep 3
fi

echo "✅ Hugo server is running"
echo ""
echo "📄 Generating PDF from web page..."
echo ""

# Option 1: Try to use Chrome headless if available
if command -v "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" &> /dev/null; then
    echo "📌 Using Chrome headless to generate PDF..."

    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
        --headless \
        --disable-gpu \
        --print-to-pdf="static/files/khaerov-academic-cv.pdf" \
        --no-pdf-header-footer \
        --print-to-pdf-no-header \
        "http://localhost:1313/academic/" \
        2>/dev/null

    if [ -f "static/files/khaerov-academic-cv.pdf" ]; then
        echo "✅ PDF generated successfully!"
        echo "   Location: static/files/khaerov-academic-cv.pdf"
        echo ""
        ls -lh static/files/khaerov-academic-cv.pdf
        echo ""
        echo "📖 Opening PDF for preview..."
        open static/files/khaerov-academic-cv.pdf
        exit 0
    else
        echo "❌ Chrome headless failed. Trying manual method..."
    fi
fi

# Option 2: Manual browser print
echo "📋 Manual PDF Generation Instructions:"
echo ""
echo "1. Open your browser to: http://localhost:1313/academic/"
echo "2. Press: Cmd + P (Print)"
echo "3. Select: Save as PDF"
echo "4. Save to: static/files/khaerov-academic-cv.pdf"
echo ""
echo "Opening page in browser..."
open "http://localhost:1313/academic/"

echo ""
echo "After saving the PDF, press Enter to validate it..."
read -r

# Validate PDF exists
if [ -f "static/files/khaerov-academic-cv.pdf" ]; then
    echo "✅ PDF found and validated!"
    ls -lh static/files/khaerov-academic-cv.pdf

    # Verify it's a valid PDF
    if file static/files/khaerov-academic-cv.pdf | grep -q "PDF"; then
        echo "✅ Valid PDF file confirmed"

        # Get file size
        SIZE=$(du -h static/files/khaerov-academic-cv.pdf | cut -f1)
        echo "📊 File size: $SIZE"

        # Preview
        echo ""
        echo "📖 Opening PDF for preview..."
        open static/files/khaerov-academic-cv.pdf
    else
        echo "⚠️  File exists but may not be a valid PDF"
    fi
else
    echo "❌ PDF not found at static/files/khaerov-academic-cv.pdf"
    echo "Please save the PDF manually to this location."
fi
