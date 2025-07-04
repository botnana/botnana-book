#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# The root directory of the Traditional Chinese book.
BOOK_DIR="/home/ccwu/botnana-book/zh-tw"

# The source directory containing SUMMARY.md and chapter files.
SRC_DIR="${BOOK_DIR}/src"

# The desired output PDF file path.
OUTPUT_PDF="${BOOK_DIR}/botnana-book-zh-tw.pdf"

# The font to use for the PDF. Make sure it's installed on your system.
MAIN_FONT="Noto Sans CJK TC"

# --- Script ---
echo "Searching for Markdown files in ${SRC_DIR}/SUMMARY.md..."

# Automatically find all .md files listed in SUMMARY.md in the correct order.
# It extracts file paths from lines like: [Chapter 1](chapter_1.md)
FILES=$(grep -o '\[.*\](.*\.md)' "${SRC_DIR}/SUMMARY.md" | sed -e 's/.*(\(.*\))/\1/')

if [ -z "$FILES" ]; then
    echo "Error: Could not find any .md files in SUMMARY.md" >&2
    exit 1
fi

echo "Found files. Starting PDF conversion..."

# Run pandoc, executing from within the src directory to resolve relative image paths.
(cd "$SRC_DIR" && pandoc $FILES \
  -o "$OUTPUT_PDF" \
  --pdf-engine=xelatex \
  -V lang=zh-TW \
  -V mainfont="$MAIN_FONT" \
  --toc \
  --number-sections)

echo "✅ PDF successfully created at: $OUTPUT_PDF"