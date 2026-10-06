#!/usr/bin/env bash
# Requalifies every sample row in samples/manifest.tsv against the CNA.NET and CNA checkouts beside
# this repository: Release build, a capture on the private Xvfb display, the exit path the source
# itself has, and the capture measured against a capture of the row's C++ port taken the same way.
#
# Usage: scripts/requalify.sh [--out DIR] [--settle SECONDS] [--xdotool 'COMMANDS'] [SampleDirectory ...]
#
# --xdotool gives the C# run and the C++ port the same input before their captures
# (capture-sample.sh --xdotool), so an interaction is measured like a first frame.
#
# Writes DIR/<sample>/ and DIR/<sample>/cpp/ (what capture-sample.sh writes) and
# DIR/requalification.md, one table row per sample. A row that builds, runs, shows its window, exits
# cleanly where its source has an exit key, and logs no failure is "pass"; everything else says
# which step failed; "pass" in the build column means Debug and Release. The C++ port is the binary
# cna-samples built under /rv/tmp/samples (manifest column 4, else the row's own name). The pixel column is a measurement, not a verdict: an animated or randomly seeded sample
# differs from any other capture by construction, so a reviewer reads it next to the images.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dotnet_root="$(cd "$here/../cna-dotnet" && pwd)"
cna_root="$(cd "$here/../cna" && pwd)"
out=""
settle=5
input=()
rows=()

while [ $# -gt 0 ]; do
    case "$1" in
        --out)    out="$2"; shift 2 ;;
        --settle) settle="$2"; shift 2 ;;
        --xdotool) input=(--xdotool "$2"); shift 2 ;;
        -h|--help) sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)       echo "error: unknown option $1" >&2; exit 2 ;;
        *)        rows+=("$1"); shift ;;
    esac
done

stamp="$(date +%Y%m%d)-dotnet$(git -C "$dotnet_root" rev-parse --short HEAD)-cna$(git -C "$cna_root" rev-parse --short HEAD)"
out="${out:-/rv/tmp/cs-samples/requal-$stamp}"
mkdir -p "$out"

if [ ${#rows[@]} -eq 0 ]; then
    mapfile -t rows < <(grep -v '^#' "$here/samples/manifest.tsv" | cut -f1 | sed '/^$/d')
fi

# Fraction of pixels that differ by more than 2% between two same-sized images, or why not.
measure() {
    local a=$1 b=$2
    [ -f "$a" ] && [ -f "$b" ] || { echo "no reference"; return; }
    local sa sb
    sa="$(identify -format '%wx%h' "$a" 2>/dev/null)"
    sb="$(identify -format '%wx%h' "$b" 2>/dev/null)"
    [ "$sa" = "$sb" ] || { echo "size $sa vs $sb"; return; }
    local differing total
    differing="$(compare -metric AE -fuzz 2% "$a" "$b" null: 2>&1 | awk '{print int($1)}')"
    total=$(( ${sa%x*} * ${sa#*x} ))
    awk -v d="$differing" -v t="$total" 'BEGIN { printf "%.2f%% (%d px)\n", 100 * d / t, d }'
}

table="$out/requalification.md"
{
    echo "# Requalification $stamp"
    echo
    echo "CNA.NET \`$(git -C "$dotnet_root" rev-parse --short HEAD)\`, CNA \`$(git -C "$cna_root" rev-parse --short HEAD)\`,"
    echo "native \`$("$here/scripts/build-native-cna.sh" --no-build)\`, private Xvfb, settle ${settle}s."
    echo
    echo "| Sample | Build | Run + capture | Exit | vs C++ port | Window |"
    echo "|---|---|---|---|---|---|"
} >"$table"

for row in "${rows[@]}"; do
    project="$here/samples/$row/$row.csproj"
    log="$out/$row"
    mkdir -p "$log"
    build="pass"; run="-"; exit_result="-"; cpp="-"; window="-"

    if ! dotnet build "$project" -c Debug -m:1 >"$log/build-debug.log" 2>&1; then
        build="**Debug fails**"
    elif ! dotnet build "$project" -c Release -m:1 >"$log/build.log" 2>&1; then
        build="**Release fails**"
    else
        exit_args=()
        # A Windows Phone title's Back button is Escape off a phone (CNA.NET CSX-095), so a phone
        # row that leaves on GamePad Back is checked like one that reads Escape itself.
        if ! grep -rq 'Keys.Escape' --include='*.cs' "$here/samples/$row" &&
           ! { grep -q '<XnaPlatform>Windows Phone</XnaPlatform>' "$project" &&
               grep -rq 'Buttons.Back' --include='*.cs' "$here/samples/$row"; }; then
            # Nothing in the sample answers a key: there is nothing to press.
            exit_args=(--no-exit-check)
            exit_result="no key in source"
        fi
        # A row qualified in another configuration names it (ShapeRendering draws only in Debug).
        configuration="$(sed -n 's:.*<CnaSampleConfiguration>\(.*\)</CnaSampleConfiguration>.*:\1:p' "$project")"
        if "$here/scripts/capture-sample.sh" "$row" --window '.' --out "$log" --settle "$settle" \
                --configuration "${configuration:-Release}" "${input[@]}" \
                "${exit_args[@]}" >"$log/capture.log" 2>&1; then
            run="pass"
            [ "$exit_result" = "-" ] && exit_result="Escape, code 0"
        else
            run="**fail**"
            if grep -q 'did not exit the sample\|exit code' "$log/capture.log"; then
                exit_result="**$(grep -o 'did not exit the sample\|exit code [0-9]*' "$log/capture.log" | tail -1)**"
                run="pass"
            fi
        fi
        [ -f "$log/window-name.txt" ] && window="$(cat "$log/window-name.txt") $(sed -n 's/ *Width: *//p' "$log/window-geometry.txt")x$(sed -n 's/ *Height: *//p' "$log/window-geometry.txt")"
        # Column 4 names the port that supplies the content; a row with none ('-') is its own port.
        port="$(awk -F'\t' -v r="$row" '$1 == r { print ($4 == "-" ? $1 : $4) }' "$here/samples/manifest.tsv")"
        port_dir="$(ls -d /rv/tmp/samples/SAMPLE-*/cna-native-opengles3/samples/"$port" 2>/dev/null | head -1 || true)"
        port_exe=""
        # The game, not a test runner beside it (CollisionSample ships CollisionSampleUnitTests too).
        if [ -n "$port_dir" ] && [ -x "$port_dir/${port}_cna_samples" ]; then
            port_exe="$port_dir/${port}_cna_samples"
        elif [ -n "$port_dir" ]; then
            port_exe="$(find "$port_dir" -maxdepth 1 -type f -executable ! -name '*.so*' ! -iname '*test*' | head -1)"
        fi
        if [ -z "$port_exe" ]; then
            cpp="no C++ port"
        elif "$here/scripts/capture-sample.sh" "$row" --exe "$port_exe" --window '.' --out "$log/cpp" \
                --settle "$settle" "${input[@]}" --no-exit-check >"$log/cpp-capture.log" 2>&1 || [ -f "$log/cpp/$row.png" ]; then
            [ -f "$log/$row.png" ] && cpp="$(measure "$log/$row.png" "$log/cpp/$row.png")"
        else
            cpp="C++ capture failed"
        fi
    fi
    echo "| $row | $build | $run | $exit_result | $cpp | $window |" >>"$table"
    echo "$row: build=$build run=$run exit=$exit_result cpp=$cpp"
done

echo
echo "table: $table"
