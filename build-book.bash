#!/usr/bin/env bash

set -euo pipefail

repository_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
build_root=""
transaction_active=false
docs_had_original=false
english_pdf_had_original=false
chinese_pdf_had_original=false
docs_published=false
english_pdf_published=false
chinese_pdf_published=false

english_pdf="$repository_root/botnana-book_en-us.pdf"
chinese_pdf="$repository_root/botnana-book_zh-tw.pdf"

fail() {
    echo "build-book: $*" >&2
    exit 1
}

require_command() {
    local command_name=$1

    command -v "$command_name" > /dev/null 2>&1 ||
        fail "$command_name is required; install it and ensure it is in PATH"
}

rollback_publish() {
    local failed_publish="$build_root/failed-publish"

    mkdir -p "$failed_publish"

    if $docs_published && [[ -e $repository_root/docs ]]; then
        mv -- "$repository_root/docs" "$failed_publish/docs"
    fi
    if $english_pdf_published && [[ -e $english_pdf ]]; then
        mv -- "$english_pdf" "$failed_publish/botnana-book_en-us.pdf"
    fi
    if $chinese_pdf_published && [[ -e $chinese_pdf ]]; then
        mv -- "$chinese_pdf" "$failed_publish/botnana-book_zh-tw.pdf"
    fi

    if $docs_had_original; then
        mv -- "$build_root/previous/docs" "$repository_root/docs"
    fi
    if $english_pdf_had_original; then
        mv -- "$build_root/previous/botnana-book_en-us.pdf" "$english_pdf"
    fi
    if $chinese_pdf_had_original; then
        mv -- "$build_root/previous/botnana-book_zh-tw.pdf" "$chinese_pdf"
    fi
}

cleanup() {
    local status=$?

    trap - EXIT
    if $transaction_active; then
        rollback_publish || status=1
    fi
    if [[ -n $build_root && -d $build_root &&
        $build_root == "$repository_root"/.build-book.* ]]; then
        rm -rf -- "$build_root"
    fi
    exit "$status"
}

trap cleanup EXIT

require_command mdbook
require_command mdbook-pdf

build_root=$(mktemp -d "$repository_root/.build-book.XXXXXX")

echo "Building English HTML and PDF..."
mdbook build "$repository_root/en-us" --dest-dir "$build_root/en-us"

echo "Building Traditional Chinese HTML and PDF..."
mdbook build "$repository_root/zh-tw" --dest-dir "$build_root/zh-tw"

english_html="$build_root/en-us/html"
english_pdf_output="$build_root/en-us/pdf/output.pdf"
chinese_html="$build_root/zh-tw/html"
chinese_pdf_output="$build_root/zh-tw/pdf/output.pdf"

[[ -f $english_html/index.html ]] || fail "English HTML output is missing"
[[ -s $english_pdf_output ]] || fail "English PDF output is missing or empty"
[[ -f $chinese_html/index.html ]] || fail "Traditional Chinese HTML output is missing"
[[ -s $chinese_pdf_output ]] || fail "Traditional Chinese PDF output is missing or empty"

[[ ! -e $repository_root/docs || -d $repository_root/docs ]] ||
    fail "$repository_root/docs exists but is not a directory"
[[ ! -e $english_pdf || -f $english_pdf ]] ||
    fail "$english_pdf exists but is not a regular file"
[[ ! -e $chinese_pdf || -f $chinese_pdf ]] ||
    fail "$chinese_pdf exists but is not a regular file"

mkdir "$build_root/previous"
transaction_active=true

if [[ -d $repository_root/docs ]]; then
    mv -- "$repository_root/docs" "$build_root/previous/docs"
    docs_had_original=true
fi
if [[ -f $english_pdf ]]; then
    mv -- "$english_pdf" "$build_root/previous/botnana-book_en-us.pdf"
    english_pdf_had_original=true
fi
if [[ -f $chinese_pdf ]]; then
    mv -- "$chinese_pdf" "$build_root/previous/botnana-book_zh-tw.pdf"
    chinese_pdf_had_original=true
fi

mv -- "$chinese_html" "$repository_root/docs"
docs_published=true
mv -- "$english_pdf_output" "$english_pdf"
english_pdf_published=true
mv -- "$chinese_pdf_output" "$chinese_pdf"
chinese_pdf_published=true

transaction_active=false

echo "Published Traditional Chinese HTML to $repository_root/docs"
echo "Published English PDF to $english_pdf"
echo "Published Traditional Chinese PDF to $chinese_pdf"
