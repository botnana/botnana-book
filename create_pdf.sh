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

# --- Chapter & Page Break Configuration ---
# The header level in your Markdown files that should be treated as a "Chapter".
# For example, set to 1 for '#', 2 for '##', 3 for '###'.
# Based on your `ethercat-io-primitives.md` file, your top headers appear
# to be level 3, so we'll start with that.
BASE_HEADER_LEVEL=3

# --- Metadata ---
METADATA_FILE="${BOOK_DIR}/metadata.yaml"

# --- Script ---
echo "Searching for Markdown files in ${SRC_DIR}/SUMMARY.md..."

# Automatically find all .md files listed in SUMMARY.md in the correct order.
# We use mapfile (an alias for readarray) to read the file list into an array.
# This is more robust than a simple string, especially if filenames contain spaces.
mapfile -t FILES < <(grep -o '\[.*\](.*\.md)' "${SRC_DIR}/SUMMARY.md" | sed -e 's/.*(\(.*\))/\1/')

if [ ${#FILES[@]} -eq 0 ]; then
    echo "Error: Could not find any .md files in SUMMARY.md" >&2
    exit 1
fi

# Calculate the necessary header level shift for pandoc.
HEADER_SHIFT=$((1 - BASE_HEADER_LEVEL))

echo "Found files. Starting PDF conversion..."

# Run pandoc.
# - We execute from within the src directory to resolve relative image paths correctly.
# - The metadata file is passed first to apply title, author, and other settings.
# - We pass "${FILES[@]}" to handle filenames with spaces or special characters safely.
(cd "$SRC_DIR" && pandoc "${METADATA_FILE}" "${FILES[@]}" \
  -o "$OUTPUT_PDF" \
  --pdf-engine=xelatex \
  --toc \
  --number-sections \
  --shift-heading-level-by=$HEADER_SHIFT \
  --top-level-division=chapter)

echo "✅ PDF successfully created at: $OUTPUT_PDF"