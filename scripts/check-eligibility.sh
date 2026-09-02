#!/usr/bin/env bash
# CSINFRA-005. Re-derives the eligible inventory from ../cna-samples/plan.md and compares it with
# this repository's plan.md, so a row that becomes eligible -- or stops being -- is noticed rather
# than rediscovered months later.
#
# Eligible means: the row is ✅ over there AND that ✅ stands for a real C++ port. The two
# owner-accepted non-ports, SAMPLE-004 StockEffects and SAMPLE-015 TicTacToe, are excluded by name
# because nothing in the table distinguishes them; both are documented in plan.md.
#
# Exit 0 when the two inventories agree, 1 otherwise.
set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
theirs="${CNA_SAMPLES_ROOT:-$(cd "$here/.." && pwd)/cna-samples}/plan.md"
[ -f "$theirs" ] || { echo "error: ../cna-samples/plan.md not found at $theirs" >&2; exit 2; }

# Status is the LAST table cell, not a fixed column: several rows contain a '|' inside their prose.
awk -F'|' '/^\| SAMPLE-[0-9]+ \|/ {
    id = $2; status = $(NF - 1)
    gsub(/^ +| +$/, "", id); gsub(/^ +| +$/, "", status)
    if (status == "✅") { sub(/SAMPLE-/, "", id); print id }
}' "$theirs" | grep -vxE "004|015" | sort > /tmp/.cs-eligible-derived.$$

grep -oE "^\| CSSAMPLE-[0-9]+ \|" "$here/plan.md" | grep -oE "[0-9]+" | sort > /tmp/.cs-rows-ours.$$
grep -oE "^\| CSSAMPLE-[0-9]+ \|.*\| ✅ \|$" "$here/plan.md" | grep -oE "CSSAMPLE-[0-9]+" |
    grep -oE "[0-9]+" | sort > /tmp/.cs-done-ours.$$

missing_row=$(comm -23 /tmp/.cs-eligible-derived.$$ /tmp/.cs-rows-ours.$$)
stale_row=$(comm -13 /tmp/.cs-eligible-derived.$$ /tmp/.cs-rows-ours.$$)
# The one that is always wrong: we claim a row complete that ../cna-samples no longer does.
overclaimed=$(comm -13 /tmp/.cs-eligible-derived.$$ /tmp/.cs-done-ours.$$)
derived=$(wc -l < /tmp/.cs-eligible-derived.$$)
ours=$(wc -l < /tmp/.cs-rows-ours.$$)
rm -f /tmp/.cs-eligible-derived.$$ /tmp/.cs-rows-ours.$$ /tmp/.cs-done-ours.$$

echo "../cna-samples now yields $derived eligible row(s); plan.md carries $ours"
status=0
if [ -n "$overclaimed" ]; then
    echo
    echo "OVERCLAIMED -- marked ✅ here while ../cna-samples no longer marks it complete:"
    printf '  CSSAMPLE-%s\n' $overclaimed
    status=1
fi
if [ -n "$missing_row" ]; then
    echo; echo "NEWLY ELIGIBLE -- add a row to plan.md:"; printf '  CSSAMPLE-%s\n' $missing_row; status=1
fi
if [ -n "$stale_row" ]; then
    # Not a failure on its own: a row that upstream reopened stays here, correctly not ✅, until it
    # is either re-qualified or removed. CSSAMPLE-002 is the case in point.
    echo
    echo "note: carried here but not currently eligible upstream (fine while not marked ✅):"
    printf '  CSSAMPLE-%s\n' $stale_row
fi
[ "$status" -eq 0 ] && echo "no overclaim; inventories reconcile"
exit "$status"
