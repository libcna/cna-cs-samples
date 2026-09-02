#!/usr/bin/env bash
# CSINFRA-003. Every compiled content file in this repository must be byte-identical to the
# official XNA Content Pipeline output the C++ campaign holds.
#
# Three outcomes per file, and the third is the interesting one:
#   MATCH     identical to ../cna-samples/samples/<port>/Content/<same path>
#   DRIFT     present there and DIFFERENT -- always a failure
#   ELSEWHERE not in the port's Content at all. Not automatically wrong: CSSAMPLE-002's font comes
#             from the campaign's artifact root because that port ships a CNA-native .cnj instead.
#             Each such file must be justified in its sample's missing.md, which this script cannot
#             read for you -- it lists them so a human decides.
#
# Exit 0 when there is no DRIFT, 1 otherwise.
set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ports="${CNA_SAMPLES_ROOT:-$(cd "$here/.." && pwd)/cna-samples}/samples"
manifest="$here/samples/manifest.tsv"
match=0; drift=0; elsewhere=0

[ -d "$ports" ] || { echo "error: ../cna-samples/samples not found at $ports" >&2; exit 2; }

while IFS=$'\t' read -r sample _ _ port; do
    case "$sample" in ''|'#'*) continue ;; esac
    content="$here/samples/$sample/Content"
    [ -d "$content" ] || continue

    while IFS= read -r -d '' file; do
        rel="${file#"$content"/}"
        theirs="$ports/$port/Content/$rel"
        if [ "$port" = "-" ] || [ ! -f "$theirs" ]; then
            echo "ELSEWHERE  $sample/$rel"
            elsewhere=$((elsewhere + 1))
        elif cmp -s "$file" "$theirs"; then
            match=$((match + 1))
        else
            echo "DRIFT      $sample/$rel"
            echo "             ours   $(sha256sum "$file"   | cut -c1-16)  $(stat -c%s "$file") B"
            echo "             theirs $(sha256sum "$theirs" | cut -c1-16)  $(stat -c%s "$theirs") B"
            drift=$((drift + 1))
        fi
    done < <(find "$content" -type f -print0)
done < "$manifest"

echo
echo "$match identical, $drift drifted, $elsewhere sourced elsewhere"
[ "$drift" -eq 0 ]
