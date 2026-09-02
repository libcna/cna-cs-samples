#!/usr/bin/env bash
# Runs one sample on a private X display, captures its window, exercises its exit key and
# reports what was on screen.
#
# Usage: scripts/capture-sample.sh <SampleDirectory> --window <regex> --out <directory>
#                                  [--configuration Debug|Release] [--settle SECONDS]
#                                  [--exit-key KEY] [--display :N] [--no-exit-check]
#
# Two details are not obvious and both were learned the hard way:
#
#   * Xvfb needs +extension GLX, and SDL needs SDL_VIDEODRIVER=x11 with WAYLAND_DISPLAY unset.
#     Without the second, SDL happily opens the window on the developer's real Wayland session
#     instead -- the run looks fine and the private display stays empty.
#   * The window is captured by cropping the ROOT window to the sample window's geometry.
#     "import -window <id>" on a GL window reads back black.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sample=""; window_pattern=""; out=""; configuration=Release
settle=5; exit_key=Escape; display=":${CNA_CAPTURE_DISPLAY_NUMBER:-128}"; check_exit=1

while [ $# -gt 0 ]; do
    case "$1" in
        --window)         window_pattern="$2"; shift 2 ;;
        --out)            out="$2"; shift 2 ;;
        -c|--configuration) configuration="$2"; shift 2 ;;
        --settle)         settle="$2"; shift 2 ;;
        --exit-key)       exit_key="$2"; shift 2 ;;
        --display)        display="$2"; shift 2 ;;
        --no-exit-check)  check_exit=0; shift ;;
        -h|--help)        sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)               echo "error: unknown option $1" >&2; exit 2 ;;
        *)                sample="$1"; shift ;;
    esac
done

[ -n "$sample" ]         || { echo "error: no sample given" >&2; exit 2; }
[ -n "$window_pattern" ] || { echo "error: --window is required" >&2; exit 2; }
[ -n "$out" ]            || { echo "error: --out is required" >&2; exit 2; }

project_dir="$here/samples/$sample"
[ -d "$project_dir" ] || { echo "error: $project_dir does not exist" >&2; exit 2; }
mkdir -p "$out"

lib="${CNA_NATIVE_LIBRARY:-$("$here/scripts/build-native-cna.sh" --no-build)}"
[ -f "$lib" ] || { echo "error: native CNA library not found at $lib" >&2; exit 2; }

exe="$(find "$project_dir/bin/$configuration" -maxdepth 1 -type f -executable \
        ! -name '*.so' ! -name '*.dll' 2>/dev/null | head -1)"
[ -n "$exe" ] || { echo "error: no $configuration build of $sample" >&2; exit 2; }

Xvfb "$display" -screen 0 1280x1024x24 +extension GLX >"$out/xvfb.log" 2>&1 &
xvfb_pid=$!
sample_pid=""
cleanup() {
    [ -n "$sample_pid" ] && kill -0 "$sample_pid" 2>/dev/null && kill "$sample_pid" 2>/dev/null || true
    kill "$xvfb_pid" 2>/dev/null || true
    wait 2>/dev/null || true
}
trap cleanup EXIT
for _ in $(seq 1 100); do DISPLAY="$display" xdpyinfo >/dev/null 2>&1 && break; sleep 0.1; done

cd "$(dirname "$exe")"
env -u WAYLAND_DISPLAY DISPLAY="$display" SDL_VIDEODRIVER=x11 LIBGL_ALWAYS_SOFTWARE=1 \
    CNA_NATIVE_LIBRARY="$lib" "$exe" >"$out/run.log" 2>&1 &
sample_pid=$!

# Pick a NAMED window, not just any match. SDL creates an unnamed 1x1 helper window beside the
# real one, and a loose pattern plus the wrong list position selects it; the crop is then garbage
# and the comparison invents a difference. CSSAMPLE-079 produced a 124187-pixel "difference"
# against the C++ port that way, which was entirely this bug.
window=""
for _ in $(seq 1 120); do
    window="$(DISPLAY="$display" xwininfo -root -tree 2>/dev/null |
        grep -oE '0x[0-9a-f]+ "[^"]+": \("[^"]*" "[^"]*"\)  [0-9]+x[0-9]+' |
        awk -v pat="$window_pattern" '{
            id=$1; line=$0
            if (match(line, /"[^"]+"/)) { name=substr(line, RSTART+1, RLENGTH-2) }
            if (match(line, /[0-9]+x[0-9]+$/)) { split(substr(line, RSTART, RLENGTH), d, "x") }
            if (name ~ pat && d[1] > 8 && d[2] > 8) { print id; exit }
        }')"
    [ -n "$window" ] && break
    if ! kill -0 "$sample_pid" 2>/dev/null; then
        echo "error: the sample exited before its window appeared" >&2
        cat "$out/run.log" >&2
        exit 1
    fi
    sleep 0.5
done
[ -n "$window" ] || { echo "error: no window matching /$window_pattern/ appeared" >&2; exit 1; }

DISPLAY="$display" xdotool windowmove "$window" 100 100
sleep 0.5
DISPLAY="$display" xwininfo -id "$window" >"$out/window-geometry.txt"
DISPLAY="$display" xdotool getwindowname "$window" >"$out/window-name.txt"
eval "$(DISPLAY="$display" xwininfo -id "$window" |
    sed -n 's/ *Absolute upper-left X: *\([0-9]*\)/wx=\1/p;
            s/ *Absolute upper-left Y: *\([0-9]*\)/wy=\1/p;
            s/ *Width: *\([0-9]*\)/ww=\1/p;
            s/ *Height: *\([0-9]*\)/wh=\1/p')"

DISPLAY="$display" xdotool windowfocus --sync "$window"
sleep "$settle"
DISPLAY="$display" import -window root -crop "${ww}x${wh}+${wx}+${wy}" +repage "$out/$sample.png"

echo "window   : $(cat "$out/window-name.txt") ${ww}x${wh}"
echo "capture  : $out/$sample.png"

if [ "$check_exit" = 1 ]; then
    DISPLAY="$display" xdotool windowfocus --sync "$window" keydown "$exit_key"
    sleep 0.3
    DISPLAY="$display" xdotool keyup "$exit_key" || true
    for _ in $(seq 1 100); do kill -0 "$sample_pid" 2>/dev/null || break; sleep 0.1; done
    if kill -0 "$sample_pid" 2>/dev/null; then
        echo "error: $exit_key did not exit the sample" >&2
        exit 1
    fi
    set +e; wait "$sample_pid"; code=$?; set -e
    sample_pid=""
    echo "exit key : $exit_key -> exit code $code"
    [ "$code" = 0 ] || exit 1
fi

if grep -Eiq 'fatal|abort|uncaught|unhandled|runtime error' "$out/run.log"; then
    echo "error: the run log reports a failure" >&2
    grep -Ei 'fatal|abort|uncaught|unhandled|runtime error' "$out/run.log" >&2
    exit 1
fi

sha256sum "$out/$sample.png" >"$out/capture-sha256.txt"
cat "$out/capture-sha256.txt"
