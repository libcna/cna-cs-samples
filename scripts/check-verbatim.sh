#!/usr/bin/env bash
# CSINFRA-004. Verifies this repository's central rule mechanically: every checked-in upstream
# source file is byte-identical to /rv/tmp/XNAGameStudio/Samples.
#
# Exit 0 when every sample is verbatim, 1 when any differs. A sample whose missing.md records a
# deviation still fails here: the point is that a deviation is a decision someone made, not
# something a diff quietly tolerates. Fix the file or take it off the list.
#
# Usage: scripts/check-verbatim.sh [sample ...]
set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
upstream_root="${XNA_SAMPLES_ROOT:-/rv/tmp/XNAGameStudio/Samples}"
manifest="$here/samples/manifest.tsv"
failures=0
checked=0

[ -d "$upstream_root" ] || { echo "error: upstream snapshot not found at $upstream_root" >&2; exit 2; }

while IFS=$'\t' read -r sample upstream subpath _; do
    case "$sample" in ''|'#'*) continue ;; esac
    if [ $# -gt 0 ]; then
        printf '%s\n' "$@" | grep -qx "$sample" || continue
    fi

    src="$upstream_root/$upstream/$subpath"
    dst="$here/samples/$sample/$(basename "$subpath")"

    if [ ! -d "$src" ]; then
        echo "MISSING UPSTREAM  $sample -> $src"; failures=$((failures + 1)); continue
    fi
    if [ ! -d "$dst" ]; then
        echo "NOT CHECKED IN    $sample -> $dst"; failures=$((failures + 1)); continue
    fi

    checked=$((checked + 1))

    # Content/ is excluded on both sides: rules.md keeps the upstream project's pipeline INPUTS out
    # of this repository, and the compiled output lives in the sample's own Content/ instead.
    diff_output="$(diff -r --exclude=Content "$src" "$dst" 2>&1)"
    if [ -n "$diff_output" ]; then
        echo "DIFFERS           $sample"
        printf '%s\n' "$diff_output" | sed 's/^/                    /' | head -12
        failures=$((failures + 1))
    fi
done < "$manifest"

echo
echo "checked $checked sample(s), $failures failure(s)"
[ "$failures" -eq 0 ]
