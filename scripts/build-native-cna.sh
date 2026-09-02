#!/usr/bin/env bash
# Builds (or finds) the CNA C ABI library the samples load at runtime.
#
# Reuse is the point. The openeggbert build rules exist because repeated from-scratch CMake trees
# wore out this machine's SSD, so this script never creates a build directory when a usable one
# already exists, and never builds anywhere but inside ../cnanext.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cna_root="${CNA_ROOT:-$(cd "$here/.." && pwd)/cnanext}"
renderer="${CNA_GRAPHICS_RENDERER:-OPENGLES3}"

if [ ! -f "$cna_root/modules/c-api/include/CNA/C/abi.h" ]; then
    echo "error: CNA checkout not found at $cna_root (set CNA_ROOT)" >&2
    exit 2
fi

# A build tree for this renderer WITH compiled effects; prefer Release, then newest.
#
# CNA_EASYGL_COMPILED_EFFECTS is not optional for this campaign. XNA samples ship compiled .fx
# bytecode in their .xnb files, and a library built without it refuses the asset outright:
#
#   EffectReader could not create the compiled effect ---> The active graphics renderer does not
#   support compiled XNA/FNA Effect Framework bytecode (GraphicsCapability::CompiledEffects is false)
#
# CSSAMPLE-028 hit exactly that against cmake-build-release-capi, which is Release OPENGLES3 and
# looked like the obvious choice. Renderer and build type are not enough to pick a tree.
# Same search, without the compiled-effects requirement.
find_existing_any() {
    local d cache
    for d in "$cna_root"/cmake-build-* "$cna_root"/build "$cna_root"/build-*; do
        cache="$d/CMakeCache.txt"
        [ -f "$cache" ] || continue
        grep -q "^CNA_GRAPHICS_RENDERER:STRING=$renderer\$" "$cache" || continue
        [ -f "$d/modules/c-api/libcna_c_api.so" ] || continue
        echo "$(grep -c '^CMAKE_BUILD_TYPE:STRING=Release$' "$cache") $(stat -c %Y "$d/modules/c-api/libcna_c_api.so") $d"
    done | sort -rn | head -1 | cut -d' ' -f3-
}

find_existing() {
    local d cache
    for d in "$cna_root"/cmake-build-* "$cna_root"/build "$cna_root"/build-*; do
        cache="$d/CMakeCache.txt"
        [ -f "$cache" ] || continue
        grep -q "^CNA_GRAPHICS_RENDERER:STRING=$renderer\$" "$cache" || continue
        grep -q "^CNA_EASYGL_COMPILED_EFFECTS:BOOL=ON$" "$cache" || continue
        [ -f "$d/modules/c-api/libcna_c_api.so" ] || continue
        echo "$(grep -c '^CMAKE_BUILD_TYPE:STRING=Release$' "$cache") $(stat -c %Y "$d/modules/c-api/libcna_c_api.so") $d"
    done | sort -rn | head -1 | cut -d' ' -f3-
}

build_dir="$(find_existing || true)"

# Fall back to a tree WITHOUT compiled effects rather than stopping the campaign. Most rows do not
# load a compiled effect, and the ones that do are blocked on CNA-REPORT-002 anyway. The warning is
# the point: a silent fallback would turn "this sample needs an effect" into a confusing runtime
# error much later.
if [ -z "$build_dir" ]; then
    build_dir="$(CNA_REQUIRE_COMPILED_EFFECTS=0 find_existing_any || true)"
    if [ -n "$build_dir" ]; then
        echo "warning: no $renderer tree with CNA_EASYGL_COMPILED_EFFECTS=ON; using $build_dir," >&2
        echo "         which cannot load compiled .fx bytecode. Rows needing an effect will fail" >&2
        echo "         with GraphicsCapability::CompiledEffects is false." >&2
    fi
fi

if [ -z "$build_dir" ]; then
    build_dir="$cna_root/cmake-build-release-capi"
    echo "no existing $renderer build tree with compiled effects and a C ABI library; configuring $build_dir"
    if ! command -v ccache >/dev/null 2>&1; then
        echo "error: ccache is not installed; refusing to configure a CNA build without it" >&2
        exit 2
    fi
    cmake -S "$cna_root" -B "$build_dir" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCNA_GRAPHICS_RENDERER="$renderer" \
        -DCNA_EASYGL_COMPILED_EFFECTS=ON \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache
fi

if [ "${1:-}" = "--no-build" ]; then
    echo "$build_dir/modules/c-api/libcna_c_api.so"
    exit 0
fi

cmake --build "$build_dir" --target cna_c_api -j"$(nproc)"

lib="$build_dir/modules/c-api/libcna_c_api.so"
abi="$(awk '/#define CNA_ABI_VERSION_(MAJOR|MINOR|PATCH)/ {gsub(/[^0-9]/, "", $3); printf "%s%s", sep, $3; sep="."}' \
    "$cna_root/modules/c-api/include/CNA/C/abi.h")"

echo
echo "native library : $lib"
echo "renderer       : $renderer (compiled effects ON)"
echo "CNA C ABI      : $abi"
echo
echo "CNA.NET admits one reviewed ABI generation at a time; check that $abi is in"
echo "  \$CNA_CS_ROOT/docs/native-abi-compatibility.md before reporting a load failure as a bug."
