#!/usr/bin/env bash

set -euo pipefail

repository_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
test_root=$(mktemp -d "${TMPDIR:-/tmp}/botnana-book-tests.XXXXXX")
trap 'rm -rf -- "$test_root"' EXIT

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

assert_contents() {
    local path=$1
    local expected=$2

    [[ -f $path ]] || fail "missing file: $path"
    [[ $(<"$path") == "$expected" ]] ||
        fail "unexpected contents in $path"
}

assert_no_build_directory() {
    local fixture=$1

    if compgen -G "$fixture/.build-book.*" > /dev/null; then
        fail "temporary build directory remains in $fixture"
    fi
}

assert_required_pdf_renderer() {
    local config=$1

    awk '
        /^\[output\.pdf\]$/ { found = 1; in_pdf = 1; next }
        /^\[/ { in_pdf = 0 }
        in_pdf && /^optional[[:space:]]*=[[:space:]]*true/ { optional = 1 }
        END { exit !(found && !optional) }
    ' "$config" || fail "PDF renderer is not required in $config"
}

new_fixture() {
    local name=$1
    local include_pdf_backend=${2:-yes}
    local fixture="$test_root/$name/repository"
    local bin_dir="$test_root/$name/bin"

    mkdir -p "$fixture/en-us" "$fixture/zh-tw" "$fixture/docs" "$bin_dir"
    cp "$repository_root/build-book.bash" "$fixture/build-book.bash"
    cp "$repository_root/en-us/book.toml" "$fixture/en-us/book.toml"
    cp "$repository_root/zh-tw/book.toml" "$fixture/zh-tw/book.toml"
    cp "$repository_root/tests/fixtures/mdbook" "$bin_dir/mdbook"
    chmod +x "$fixture/build-book.bash" "$bin_dir/mdbook"

    if [[ $include_pdf_backend == yes ]]; then
        cp "$repository_root/tests/fixtures/mdbook-pdf" "$bin_dir/mdbook-pdf"
        chmod +x "$bin_dir/mdbook-pdf"
    fi

    echo "published-before" > "$fixture/docs/index.html"
    echo "english-pdf-before" > "$fixture/botnana-book_en-us.pdf"
    echo "chinese-pdf-before" > "$fixture/botnana-book_zh-tw.pdf"

    FIXTURE=$fixture
    FIXTURE_BIN=$bin_dir
    FAKE_LOG="$test_root/$name/mdbook.log"
    RUN_LOG="$test_root/$name/build.log"
}

run_build() {
    local working_directory=$1

    set +e
    (
        cd "$working_directory"
        PATH="$FIXTURE_BIN:/usr/bin:/bin" \
            FAKE_MDBOOK_LOG="$FAKE_LOG" \
            FAKE_MDBOOK_FAIL="${FAKE_MDBOOK_FAIL:-}" \
            "$FIXTURE/build-book.bash"
    ) > "$RUN_LOG" 2>&1
    RUN_STATUS=$?
    set -e
}

missing_pdf_backend_then_existing_outputs_remain_unchanged() {
    new_fixture "missing-pdf-backend" no

    run_build "$test_root"

    [[ $RUN_STATUS -ne 0 ]] || fail "build unexpectedly succeeded without mdbook-pdf"
    grep -q "mdbook-pdf" "$RUN_LOG" || fail "missing mdbook-pdf diagnostic"
    assert_contents "$FIXTURE/docs/index.html" "published-before"
    assert_contents "$FIXTURE/botnana-book_en-us.pdf" "english-pdf-before"
    assert_contents "$FIXTURE/botnana-book_zh-tw.pdf" "chinese-pdf-before"
    assert_no_build_directory "$FIXTURE"
}

second_language_failure_then_existing_outputs_remain_unchanged() {
    new_fixture "second-language-failure"
    FAKE_MDBOOK_FAIL=zh-tw

    run_build "$test_root"

    [[ $RUN_STATUS -ne 0 ]] || fail "build unexpectedly succeeded after renderer failure"
    assert_contents "$FIXTURE/docs/index.html" "published-before"
    assert_contents "$FIXTURE/botnana-book_en-us.pdf" "english-pdf-before"
    assert_contents "$FIXTURE/botnana-book_zh-tw.pdf" "chinese-pdf-before"
    assert_no_build_directory "$FIXTURE"
    unset FAKE_MDBOOK_FAIL
}

successful_build_then_publishes_chinese_html_and_both_pdfs() {
    new_fixture "successful-build"

    run_build "$test_root"

    [[ $RUN_STATUS -eq 0 ]] || fail "build failed: $(<"$RUN_LOG")"
    assert_contents "$FIXTURE/docs/index.html" "html-zh-tw"
    assert_contents "$FIXTURE/botnana-book_en-us.pdf" "pdf-en-us"
    assert_contents "$FIXTURE/botnana-book_zh-tw.pdf" "pdf-zh-tw"
    assert_contents "$FAKE_LOG" $'en-us\nzh-tw'
    assert_no_build_directory "$FIXTURE"
}

both_language_configs_require_pdf_output() {
    assert_required_pdf_renderer "$repository_root/en-us/book.toml"
    assert_required_pdf_renderer "$repository_root/zh-tw/book.toml"
}

both_language_configs_require_pdf_output
missing_pdf_backend_then_existing_outputs_remain_unchanged
second_language_failure_then_existing_outputs_remain_unchanged
successful_build_then_publishes_chinese_html_and_both_pdfs

echo "build-book tests passed"
