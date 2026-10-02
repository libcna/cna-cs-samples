#!/usr/bin/env bash
# Runs one sample on a private X display, captures its window, exercises its exit key and
# reports what was on screen.
#
# Usage: scripts/capture-sample.sh <SampleDirectory> --window <regex> --out <directory>
#                                  [--configuration Debug|Release] [--settle SECONDS]
#                                  [--exit-key KEY] [--display :N] [--no-exit-check]
#                                  [--exe PATH] [--xdotool 'COMMANDS']
#
# --exe captures another executable the same way -- the retained C++ port, for the reference the
# C# capture is compared against. The sample directory still names the output file.
#
# --xdotool drives the focused window after the settle time and before the capture, e.g.
# 'keydown Right sleep 1.5 keyup Right' (xdotool's own chaining), so input has evidence too.
#
# Two details are not obvious and both were learned the hard way:
#
#   * Xvfb needs +extension GLX, and SDL needs SDL_VIDEODRIVER=x11 with WAYLAND_DISPLAY unset.
#     Without the second, SDL happily opens the window on the developer's real Wayland session
#     instead -- the run looks fine and the private display stays empty.
#   * The window is captured by cropping the ROOT window to the sample window's geometry.
#     "import -window <id>" on a GL window reads back black.
#
# The sample runs with a private home under the output directory and no session bus: a sample that
# starts GamerServices otherwise reads and writes the developer's own CNA profiles, credentials and
# asset cache (XDG data/state/cache, the Secret Service). Mesa keeps its shared shader cache.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sample=""; window_pattern=""; out=""; configuration=Release
settle=5; exit_key=Escape; display=":${CNA_CAPTURE_DISPLAY_NUMBER:-128}"; check_exit=1; exe_override=""; input=""

while [ $# -gt 0 ]; do
    case "$1" in
        --window)         window_pattern="$2"; shift 2 ;;
        --out)            out="$2"; shift 2 ;;
        -c|--configuration) configuration="$2"; shift 2 ;;
        --settle)         settle="$2"; shift 2 ;;
        --exit-key)       exit_key="$2"; shift 2 ;;
        --display)        display="$2"; shift 2 ;;
        --no-exit-check)  check_exit=0; shift ;;
        --exe)            exe_override="$2"; shift 2 ;;
        --xdotool)        input="$2"; shift 2 ;;
        -h|--help)        sed -n '2,21p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
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

if [ -n "$exe_override" ]; then
    exe="$(realpath "$exe_override")"
else
    exe="$(find "$project_dir/bin/$configuration" -maxdepth 1 -type f -executable \
            ! -name '*.so' ! -name '*.dll' 2>/dev/null | head -1)"
fi
[ -n "$exe" ] && [ -x "$exe" ] || { echo "error: no $configuration build of $sample" >&2; exit 2; }

Xvfb "$display" -screen 0 1920x1200x24 +extension GLX >"$out/xvfb.log" 2>&1 &
xvfb_pid=$!
sample_pid=""
# The sample goes first and Xvfb only once it has gone: a game still drawing when its X server
# dies takes Xlib's IO-error exit(), which deadlocked against a concurrent exit() (CNA.NET CSX-084).
cleanup() {
    if [ -n "$sample_pid" ] && kill -0 "$sample_pid" 2>/dev/null; then
        kill "$sample_pid" 2>/dev/null || true
        for _ in $(seq 1 100); do kill -0 "$sample_pid" 2>/dev/null || break; sleep 0.1; done
        kill -0 "$sample_pid" 2>/dev/null && { echo "warning: SIGTERM did not end the sample; killed" >&2; kill -KILL "$sample_pid" 2>/dev/null || true; }
    fi
    kill "$xvfb_pid" 2>/dev/null || true
    wait 2>/dev/null || true
}
trap cleanup EXIT
for _ in $(seq 1 100); do DISPLAY="$display" xdpyinfo >/dev/null 2>&1 && break; sleep 0.1; done

private_home="$(cd "$out" && pwd)/home"
mkdir -p "$private_home"
mesa_cache="${MESA_SHADER_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/mesa_shader_cache}"
cd "$(dirname "$exe")"
# Sound goes nowhere unless asked for: the private display has no speakers of its own, and SDL would
# otherwise find the developer's sound server through XDG_RUNTIME_DIR.
env -u WAYLAND_DISPLAY -u DBUS_SESSION_BUS_ADDRESS DISPLAY="$display" SDL_VIDEODRIVER=x11 LIBGL_ALWAYS_SOFTWARE=1 \
    SDL_AUDIODRIVER="${CNA_CAPTURE_AUDIODRIVER:-dummy}" \
    HOME="$private_home" XDG_DATA_HOME="$private_home/.local/share" XDG_STATE_HOME="$private_home/.local/state" \
    XDG_CONFIG_HOME="$private_home/.config" XDG_CACHE_HOME="$private_home/.cache" \
    MESA_SHADER_CACHE_DIR="$mesa_cache" CNA_NATIVE_LIBRARY="$lib" "$exe" >"$out/run.log" 2>&1 &
sample_pid=$!

# Pick a NAMED window, not just any match. SDL creates an unnamed 1x1 helper window beside the
# real one, and a loose pattern plus the wrong list position selects it; the crop is then garbage
# and the comparison invents a difference. CSSAMPLE-079 produced a 124187-pixel "difference"
# against the C++ port that way, which was entirely this bug.
window=""
for _ in $(seq 1 120); do
    # `|| true` is load-bearing: under `set -e` with `pipefail`, a grep that matches nothing --
    # which is every iteration before the window appears -- would abort the script silently.
    window="$(DISPLAY="$display" xwininfo -root -tree 2>/dev/null |
        awk '
            match($0, /0x[0-9a-f]+ "[^"]+"/) {
                id = substr($0, RSTART, index(substr($0, RSTART), " ") - 1)
                s = substr($0, RSTART)
                match(s, /"[^"]+"/); name = substr(s, RSTART + 1, RLENGTH - 2)
                if (match($0, /[0-9]+x[0-9]+\+/)) {
                    split(substr($0, RSTART, RLENGTH - 1), d, "x")
                    if (name ~ pat && d[1] > 8 && d[2] > 8) { print id; exit }
                }
            }' pat="$window_pattern" || true)"
    [ -n "$window" ] && break
    if ! kill -0 "$sample_pid" 2>/dev/null; then
        echo "error: the sample exited before its window appeared" >&2
        cat "$out/run.log" >&2
        exit 1
    fi
    sleep 0.5
done
[ -n "$window" ] || { echo "error: no window matching /$window_pattern/ appeared" >&2; exit 1; }

# A game that sizes its window after showing it can resize from the position it still believes,
# undoing a move that arrived in between (Mahjong, 800x480 to 850x700); --xdotool coordinates
# assume +100+100, so the move is repeated until it holds.
for attempt in 1 2 3 4 5 6 7 8 9 10; do
    DISPLAY="$display" xdotool windowmove "$window" 100 100
    sleep 0.5
    DISPLAY="$display" xwininfo -id "$window" | grep -q -- '-geometry [0-9]*x[0-9]*+100+100$' && break
done
DISPLAY="$display" xdotool getwindowname "$window" >"$out/window-name.txt"

DISPLAY="$display" xdotool windowfocus --sync "$window"
sleep "$settle"
if [ -n "$input" ]; then
    # Word splitting is the point: the value is a sequence of xdotool arguments.
    # shellcheck disable=SC2086
    DISPLAY="$display" xdotool $input
fi
# The geometry is read now, not when the window appeared: a game that sets its back buffer size
# after startup (PlayingInTraffic goes from 800x480 to 1280x720) has resized its window since.
DISPLAY="$display" xwininfo -id "$window" >"$out/window-geometry.txt"
eval "$(sed -n 's/ *Absolute upper-left X: *\([0-9]*\)/wx=\1/p;
            s/ *Absolute upper-left Y: *\([0-9]*\)/wy=\1/p;
            s/ *Width: *\([0-9]*\)/ww=\1/p;
            s/ *Height: *\([0-9]*\)/wh=\1/p' "$out/window-geometry.txt")"
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
