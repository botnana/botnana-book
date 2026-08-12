#!/usr/bin/env bash

set -euo pipefail

repository_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
workflow="$repository_root/.github/workflows/pages.yml"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

assert_contains() {
    local expected=$1
    local file=${2:-$workflow}

    grep -Fq -- "$expected" "$file" ||
        fail "$(basename -- "$file") is missing: $expected"
}

[[ -f $workflow ]] || fail "missing Pages workflow: $workflow"

assert_contains 'workflow_dispatch:'
assert_contains 'branches:'
assert_contains '- master'
assert_contains 'cancel-in-progress: false'
assert_contains 'contents: read'
assert_contains 'pages: write'
assert_contains 'id-token: write'
assert_contains 'actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1'
assert_contains 'actions/configure-pages@45bfe0192ca1faeb007ade9deae92b16b8254a0d'
assert_contains 'actions/upload-pages-artifact@fc324d3547104276b827a68afc52ff2a11cc49c9'
assert_contains 'actions/deploy-pages@cd2ce8fcbc39b97be8ca5fce6e763baed58fa128'
assert_contains 'MDBOOK_VERSION: "0.5.2"'
assert_contains 'MDBOOK_SHA256: "084e4342ba564db270108763e404a7d1f309d932651a22484e93c0dc1a071f6d"'
assert_contains 'MDBOOK_OUTPUT__PDF__OPTIONAL: "true"'
assert_contains '--retry 5 --retry-all-errors --retry-delay 2'
assert_contains 'mdbook build zh-tw --dest-dir "$pages_build_root"'
assert_contains 'test -f "$pages_site/index.html"'
assert_contains "grep -Fq 'Botnana BN-B3A' \"\$pages_site/bn-b3a.html\""
assert_contains "grep -Fq 'Version 1.14.3' \"\$pages_site/cover.html\""
assert_contains 'path: ${{ runner.temp }}/botnana-pages/html'
assert_contains 'name: github-pages'
assert_contains 'url: ${{ steps.deployment.outputs.page_url }}'

echo "Pages workflow contract passed"
