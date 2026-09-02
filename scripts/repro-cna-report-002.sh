#!/usr/bin/env bash
# Reproduces CNA-REPORT-002: after one ModelMesh.Draw, the effect's technique handle is invalid.
#
# Usage: scripts/repro-cna-report-002.sh [frames]
#
# Needs a native library built with CNA_EASYGL_COMPILED_EFFECTS=ON -- the sample's model carries a
# compiled effect, and a library without it fails earlier and differently. build-native-cna.sh
# selects such a tree.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
frames="${1:-6}"
project="$here/scripts/repro/cna-report-002/EffectTechniqueLifetime.csproj"
out="${CNA_REPRO_OUT:-/rv/tmp/cs-samples/CNA-REPORT-002}"
display="${CNA_REPRO_DISPLAY:-:130}"
content="$here/samples/ColorReplacement/Content"

[ -d "$content" ] || { echo "error: $content is missing; CSSAMPLE-028 supplies the model" >&2; exit 2; }
mkdir -p "$out"

: "${CNA_NATIVE_LIBRARY:=$("$here/scripts/build-native-cna.sh" --no-build)}"
export CNA_NATIVE_LIBRARY
echo "native library: $CNA_NATIVE_LIBRARY"

dotnet build "$project" -c Release -o "$out/bin" >"$out/build.log" 2>&1 || {
    echo "error: the reproduction did not build; see $out/build.log" >&2; exit 1; }
mkdir -p "$out/bin/Content"
cp "$content"/*.xnb "$out/bin/Content/"

Xvfb "$display" -screen 0 800x600x24 +extension GLX >"$out/xvfb.log" 2>&1 &
xvfb_pid=$!
trap 'kill "$xvfb_pid" 2>/dev/null || true' EXIT
for _ in $(seq 1 100); do DISPLAY="$display" xdpyinfo >/dev/null 2>&1 && break; sleep 0.1; done

cd "$out/bin"
env -u WAYLAND_DISPLAY DISPLAY="$display" SDL_VIDEODRIVER=x11 LIBGL_ALWAYS_SOFTWARE=1 \
    timeout 180 ./EffectTechniqueLifetime "$frames" 2>&1 | grep -E "^frame|^RESULT|Exception"
