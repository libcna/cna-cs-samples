#!/usr/bin/env bash
# Runs every manifest row on the Android emulator (scripts/android-sample.sh), taps Back once, and
# measures each capture against the row's desktop C# capture from a scripts/requalify.sh run.
#
# Usage: scripts/android-requalify.sh --desktop DIR [--out DIR] [--seconds N] [SampleDirectory ...]
#
# Writes DIR/<sample>/ and DIR/android-requalification.md. "pass" means the app built, the game ran
# for the given time without a managed exception or a native crash, drew (its frame is not one flat
# colour), and one Back tap ended its Main. The pixel column is a measurement: the game's frame is
# cut out of the screen (the back buffer scaled to fit and centred) and scaled back, so resampling
# edges and the status bar drawn over a windowed game differ by construction, as do animated and
# seeded rows; a game whose SupportedOrientations rotate it is not compared. An emulator this script
# started is stopped at the end.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
adb="${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}/platform-tools/adb"
desktop=""; out=""; seconds=10; rows=()
while [ $# -gt 0 ]; do
    case "$1" in
        --desktop) desktop="$2"; shift 2 ;;
        --out)     out="$2"; shift 2 ;;
        --seconds) seconds="$2"; shift 2 ;;
        -h|--help) sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)        echo "error: unknown option $1" >&2; exit 2 ;;
        *)         rows+=("$1"); shift ;;
    esac
done
[ -d "$desktop" ] || { echo "error: --desktop must name a scripts/requalify.sh output" >&2; exit 2; }
out="${out:-/rv/tmp/cs-samples/android-requal-$(date +%Y%m%d)}"
mkdir -p "$out"
if [ ${#rows[@]} -eq 0 ]; then
    mapfile -t rows < <(grep -v '^#' "$here/samples/manifest.tsv" | cut -f1 | sed '/^$/d')
fi

running_before=0
"$adb" devices | grep -q '^emulator-[0-9]*[[:space:]]*device$' && running_before=1
cleanup() { [ "$running_before" = 0 ] && "$adb" emu kill >/dev/null 2>&1 || true; }
trap cleanup EXIT

# The game's frame inside the screen: its back buffer scaled to fit and centred.
measure() {
    local capture=$1 reference=$2
    [ -f "$reference" ] || { echo "no desktop capture"; return; }
    local sw sh w h
    read -r sw sh < <(identify -format '%w %h' "$capture")
    read -r w h < <(identify -format '%w %h' "$reference")
    # A game that declares only the other orientation's SupportedOrientations runs rotated on a
    # phone, with its back buffer's sides swapped, and lays out for that; desktop XNA ignored it.
    if [ $((sw > sh)) != $((w > h)) ]; then
        echo "rotated (desktop ${w}x${h}), not compared"
        return
    fi
    local geometry
    geometry="$(awk -v sw="$sw" -v sh="$sh" -v w="$w" -v h="$h" 'BEGIN {
        s = sw / w; if (sh / h < s) s = sh / h
        cw = int(w * s + 0.5); ch = int(h * s + 0.5)
        printf "%dx%d+%d+%d", cw, ch, int((sw - cw) / 2), int((sh - ch) / 2) }')"
    local frame="${capture%.png}-frame.png" differing
    convert "$capture" -crop "$geometry" +repage -resize "${w}x${h}!" -alpha off "$frame"
    differing="$(compare -metric AE -fuzz 10% "$frame" <(convert "$reference" -alpha off png:-) null: 2>&1 \
        | awk '{print int($1)}')"
    awk -v d="$differing" -v t=$((w * h)) -v g="$geometry" \
        'BEGIN { printf "%.2f%% (%d px) in %s\n", 100 * d / t, d, g }'
}

table="$out/android-requalification.md"
{
    echo "# Android requalification $(date +%Y-%m-%d)"
    echo
    echo "CNA.NET \`$(git -C "$here/../cna-cs" rev-parse --short HEAD)\`, CNA \`$(git -C "$here/../cna" rev-parse --short HEAD)\`,"
    echo ".NET 11 net11.0-android, emulator x86_64 (SwiftShader GLES 3), ${seconds}s then one Back tap;"
    echo "desktop reference \`$desktop\`."
    echo
    echo "| Sample | Android run | vs desktop C# (frame, 10% fuzz) | Screen | Back ends Main |"
    echo "|---|---|---|---|---|"
} >"$table"

for row in "${rows[@]}"; do
    log="$out/$row"
    mkdir -p "$log"
    result="pass"; pixels="-"; screen="-"; ended="-"
    if ! "$here/scripts/android-sample.sh" "$row" --out "$log" --seconds "$seconds" --keep-emulator \
            --then 'input keyevent KEYCODE_BACK' >"$log/android.log" 2>&1; then
        result="**fail**"
        grep -q "Android build failed" "$log/android.log" && result="**build fails**"
    fi
    if [ -f "$log/logcat.txt" ]; then
        if grep -qE " E CNA *:|FATAL EXCEPTION|Fatal signal" "$log/logcat.txt"; then
            [ "$result" = "pass" ] && result="**crashed**"
        fi
    fi
    ended="$(sed -n 's/^run ended: //p' "$log/android.log")"
    ended="${ended:--}"
    capture="$log/$row.png"
    if [ -f "$capture" ]; then
        screen="$(identify -format '%wx%h' "$capture")"
        pixels="$(measure "$capture" "$desktop/$row/$row.png")"
        frame="${capture%.png}-frame.png"
        if [ -f "$frame" ] && [ "$(convert "$frame" -format '%k' info:)" -le 1 ]; then
            [ "$result" = "pass" ] && result="**drew nothing**"
        fi
    fi
    [ "$result" = "pass" ] && [ "$ended" != "yes" ] && result="**did not exit**"
    echo "| $row | $result | $pixels | $screen | $ended |" >>"$table"
    echo "$row: $result $pixels screen=$screen ended=$ended"
done

echo
echo "table: $table"
