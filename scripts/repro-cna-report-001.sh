#!/usr/bin/env bash
# Reproduces CNA-REPORT-001: a CNA game window is resizable, and once resized the backbuffer image
# stays at the bottom-left of the client area instead of filling or scaling it.
#
# Usage: scripts/repro-cna-report-001.sh [executable] [window-name-regex]
#
# Defaults to the CSSAMPLE-001 Release build. It takes an arbitrary executable on purpose: the open
# question in cna-bugs.md is whether a C++ CNA game built against the SAME CNA revision behaves the
# same way, and answering that means pointing this at the rebuilt C++ port.
#
# Prints the content bounding box before and after the resize. The defect is present when the
# "after" box is the "before" box pushed to the bottom of a taller window, rather than filling it.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exe="${1:-$here/samples/PrimitivesSample/bin/Release/Primitives}"
window="${2:-^Primitives$}"
display="${CNA_REPRO_DISPLAY:-:129}"
out="${CNA_REPRO_OUT:-/rv/tmp/cs-samples/CNA-REPORT-001}"
grow_w=1200
grow_h=900

[ -x "$exe" ] || { echo "error: $exe is not an executable" >&2; exit 2; }
mkdir -p "$out"

: "${CNA_NATIVE_LIBRARY:=$("$here/scripts/build-native-cna.sh" --no-build)}"
export CNA_NATIVE_LIBRARY

Xvfb "$display" -screen 0 1600x1200x24 +extension GLX >"$out/xvfb.log" 2>&1 &
xvfb_pid=$!
game_pid=""
cleanup() {
    [ -n "$game_pid" ] && kill "$game_pid" 2>/dev/null || true
    kill "$xvfb_pid" 2>/dev/null || true
    wait 2>/dev/null || true
}
trap cleanup EXIT
for _ in $(seq 1 100); do DISPLAY="$display" xdpyinfo >/dev/null 2>&1 && break; sleep 0.1; done

cd "$(dirname "$exe")"
env -u WAYLAND_DISPLAY DISPLAY="$display" SDL_VIDEODRIVER=x11 LIBGL_ALWAYS_SOFTWARE=1 \
    "./$(basename "$exe")" >"$out/run.log" 2>&1 &
game_pid=$!

w=""
for _ in $(seq 1 120); do
    w="$(DISPLAY="$display" xdotool search --onlyvisible --name "$window" 2>/dev/null | head -1 || true)"
    [ -n "$w" ] && break
    kill -0 "$game_pid" 2>/dev/null || { echo "error: exited before its window appeared" >&2; cat "$out/run.log" >&2; exit 1; }
    sleep 0.5
done
[ -n "$w" ] || { echo "error: no window matching /$window/" >&2; exit 1; }

geometry() {
    DISPLAY="$display" xwininfo -id "$w" |
        sed -n 's/ *Width: *\([0-9]*\)/\1/p; s/ *Height: *\([0-9]*\)/\1/p' | paste -sd' '
}

DISPLAY="$display" xdotool windowmove "$w" 0 0
sleep 4
read -r bw bh <<<"$(geometry)"
DISPLAY="$display" import -window root -crop "${bw}x${bh}+0+0" +repage "$out/before.png"

DISPLAY="$display" xdotool windowsize "$w" "$grow_w" "$grow_h"
sleep 4
read -r aw ah <<<"$(geometry)"
DISPLAY="$display" import -window root -crop "${aw}x${ah}+0+0" +repage "$out/after.png"

python3 - "$out/before.png" "$out/after.png" <<'PY'
import sys
from PIL import Image
for path in sys.argv[1:]:
    im = Image.open(path).convert("L")
    px = im.load()
    pts = [(x, y) for y in range(im.height) for x in range(im.width) if px[x, y] > 0]
    if not pts:
        print(f"{path}: {im.size}  nothing drawn")
        continue
    xs = [p[0] for p in pts]
    ys = [p[1] for p in pts]
    print(f"{path}: window {im.size[0]}x{im.size[1]}  "
          f"content x {min(xs)}..{max(xs)} y {min(ys)}..{max(ys)}  pixels {len(pts)}")
PY

echo
echo "The defect is present when the second line's content box has the same height as the first's"
echo "and starts near the bottom of the taller window, instead of covering it."
