#!/usr/bin/env bash

set -euo pipefail

repository_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
workflow="$repository_root/.github/workflows/release-pdf.yml"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

assert_contains() {
    local expected=$1

    grep -Fq -- "$expected" "$workflow" ||
        fail "release workflow is missing: $expected"
}

[[ -f $workflow ]] || fail "missing release workflow: $workflow"

assert_contains 'workflow_dispatch:'
assert_contains '- "v[0-9]*"'
assert_contains 'cancel-in-progress: false'
assert_contains 'actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1'
assert_contains 'actions/upload-artifact@043fb46d1a93c77aae656e7c1c64a875d1fc6a0a'
assert_contains 'actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c'
assert_contains 'MDBOOK_VERSION: "0.5.2"'
assert_contains 'MDBOOK_SHA256: "084e4342ba564db270108763e404a7d1f309d932651a22484e93c0dc1a071f6d"'
assert_contains 'MDBOOK_PDF_VERSION: "0.1.13"'
assert_contains 'MDBOOK_PDF_SHA256: "78926f96540add76d8dd035d683b01bee01844229544c129e04a7bc4c30a5cbb"'
assert_contains '--retry 5 --retry-all-errors --retry-delay 2'
assert_contains 'contents: read'
assert_contains 'contents: write'
assert_contains "expected_cover_version=\"### Version \$release_version\""
assert_contains 'en-us/src/cover.md zh-tw/src/cover.md'
assert_contains 'bash tests/test-build-book.bash'
assert_contains 'bash tests/test-release-workflow.bash'
assert_contains './build-book.bash'
assert_contains 'botnana-book_en-us.pdf'
assert_contains 'botnana-book_zh-tw.pdf'
assert_contains 'if-no-files-found: error'
assert_contains 'retention-days: 30'
assert_contains '--json isDraft --jq .isDraft'
assert_contains '--draft --generate-notes'
assert_contains '--draft=false --latest'

echo "release workflow contract passed"
