#!/usr/bin/env bash
# Runs every manifest row in the browser (scripts/browser-sample.sh) and measures each canvas
# capture against the row's desktop C# capture from a scripts/requalify.sh run.
#
# Usage: scripts/browser-requalify.sh --desktop DIR [--out DIR] [--seconds N] [--threads] [SampleDirectory ...]
#
# Writes DIR/<sample>/ and DIR/browser-requalification.md. "pass" means the browser project built,
# the page ran for the given time without throwing, and the game drew (its capture is not one flat
# colour). The pixel column is a measurement: animated and seeded rows differ by construction.
# --threads builds every row as a multithreaded bundle (browser-sample.sh --threads).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
desktop=""; out=""; seconds=6; threads=(); rows=()
while [ $# -gt 0 ]; do
    case "$1" in
        --desktop) desktop="$2"; shift 2 ;;
        --out)     out="$2"; shift 2 ;;
        --seconds) seconds="$2"; shift 2 ;;
        --threads) threads=(--threads); shift ;;
        -h|--help) sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)        echo "error: unknown option $1" >&2; exit 2 ;;
        *)         rows+=("$1"); shift ;;
    esac
done
[ -d "$desktop" ] || { echo "error: --desktop must name a scripts/requalify.sh output" >&2; exit 2; }
out="${out:-/rv/tmp/cs-samples/browser-requal-$(date +%Y%m%d)}"
mkdir -p "$out"
if [ ${#rows[@]} -eq 0 ]; then
    mapfile -t rows < <(grep -v '^#' "$here/samples/manifest.tsv" | cut -f1 | sed '/^$/d')
fi

measure() {
    local a=$1 b=$2
    [ -f "$a" ] && [ -f "$b" ] || { echo "no desktop capture"; return; }
    local sa sb
    sa="$(identify -format '%wx%h' "$a")"; sb="$(identify -format '%wx%h' "$b")"
    [ "$sa" = "$sb" ] || { echo "size $sa vs $sb"; return; }
    local differing total
    differing="$(compare -metric AE -fuzz 2% "$a" "$b" null: 2>&1 | awk '{print int($1)}')"
    total=$(( ${sa%x*} * ${sa#*x} ))
    awk -v d="$differing" -v t="$total" 'BEGIN { printf "%.2f%% (%d px)\n", 100 * d / t, d }'
}

table="$out/browser-requalification.md"
{
    echo "# Browser requalification $(date +%Y-%m-%d)"
    echo
    echo "CNA.NET \`$(git -C "$here/../cna-dotnet" rev-parse --short HEAD)\`, CNA \`$(git -C "$here/../cna" rev-parse --short HEAD)\`,"
    echo ".NET 11 browser-wasm${threads:+ multithreaded}, headless Chromium (SwiftShader WebGL2), ${seconds}s; desktop reference \`$desktop\`."
    echo
    echo "| Sample | Browser run | vs desktop C# | Canvas | Page errors |"
    echo "|---|---|---|---|---|"
} >"$table"

for row in "${rows[@]}"; do
    log="$out/$row"
    mkdir -p "$log"
    result="pass"; pixels="-"; canvas="-"; errors=0
    if ! "$here/scripts/browser-sample.sh" "$row" --out "$log" --seconds "$seconds" "${threads[@]}" >"$log/browser.log" 2>&1; then
        result="**fail**"
        grep -q "browser build failed" "$log/browser.log" && result="**build fails**"
    fi
    capture="$log/$row.png"
    if [ -f "$capture" ]; then
        canvas="$(identify -format '%wx%h' "$capture")"
        if [ "$(convert "$capture" -format '%k' info:)" -le 1 ]; then
            [ "$result" = "pass" ] && result="**drew nothing**"
        fi
        pixels="$(measure "$capture" "$desktop/$row/$row.png")"
    fi
    [ -f "$log/run.log" ] && errors="$(grep -c '^\[pageerror\]' "$log/run.log" || true)"
    echo "| $row | $result | $pixels | $canvas | $errors |" >>"$table"
    echo "$row: $result $pixels canvas=$canvas errors=$errors"
done

echo
echo "table: $table"
