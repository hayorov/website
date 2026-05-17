# Academic CV & Teaching Philosophy PDFs

This directory contains PDF versions of academic documents for download.

## Quick PDF Generation

### Option 1: Browser Print (Easiest)
1. Start dev server: `npm run dev`
2. Open: http://localhost:1313/teaching
3. Browser Print (Cmd+P) > Save as PDF
4. Save to this directory

### Option 2: Pandoc (Best Quality)
```bash
brew install pandoc basictex
./generate-pdfs.sh
```

## Source Files

- Academic CV: `../../academic/khaerov-academic-cv.md`
- Teaching Philosophy: `../../academic/teaching-philosophy-statement.md`
