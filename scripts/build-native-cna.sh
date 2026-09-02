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

# Any build tree already configured for this renderer will do; prefer Release, newest first.
find_existing() {
    local d cache
    for d in "$cna_root"/cmake-build-* "$cna_root"/build "$cna_root"/build-*; do
        cache="$d/CMakeCache.txt"
        [ -f "$cache" ] || continue
        grep -q "^CNA_GRAPHICS_RENDERER:STRING=$renderer\$" "$cache" || continue
        [ -f "$d/modules/c-api/libcna_c_api.so" ] || continue
        echo "$(grep -c '^CMAKE_BUILD_TYPE:STRING=Release$' "$cache") $(stat -c %Y "$d/modules/c-api/libcna_c_api.so") $d"
    done | sort -rn | head -1 | cut -d' ' -f3-
}

build_dir="$(find_existing || true)"

if [ -z "$build_dir" ]; then
    build_dir="$cna_root/cmake-build-release-capi"
    echo "no existing $renderer build tree with a C ABI library; configuring $build_dir"
    if ! command -v ccache >/dev/null 2>&1; then
        echo "error: ccache is not installed; refusing to configure a CNA build without it" >&2
        exit 2
    fi
    cmake -S "$cna_root" -B "$build_dir" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCNA_GRAPHICS_RENDERER="$renderer" \
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
echo "renderer       : $renderer"
echo "CNA C ABI      : $abi"
echo
echo "CNA.NET admits one reviewed ABI generation at a time; check that $abi is in"
echo "  \$CNA_CS_ROOT/docs/native-abi-compatibility.md before reporting a load failure as a bug."
