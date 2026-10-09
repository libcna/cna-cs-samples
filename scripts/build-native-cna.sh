#!/usr/bin/env bash
# Builds (or finds) the CNA C ABI library the samples load at runtime.
#
# Reuse is the point. The openeggbert build rules exist because repeated from-scratch CMake trees
# wore out this machine's SSD, so this script never creates a build directory when a usable one
# already exists, and never builds anywhere but inside ../cna.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cna_root="${CNA_ROOT:-$(cd "$here/.." && pwd)/cna}"

# CNA plans/plan_apple_m4.md AM4-228: macOS has no OpenGL ES, names its library .dylib, and runs
# samples off the desktop under SDL's dummy video driver (run-sample.sh), which only a windowless
# renderer draws under -- so there the default is SOFTWARE, with its own compiled-effects option.
case "$(uname -s)" in
    Darwin) library_suffix=dylib; default_renderer=SOFTWARE ;;
    *)      library_suffix=so;    default_renderer=OPENGLES3 ;;
esac
renderer="${CNA_GRAPHICS_RENDERER:-$default_renderer}"
capi_library="libcna_c_api.$library_suffix"
case "$renderer" in
    SOFTWARE) compiled_effects_option=CNA_SOFTWARE_COMPILED_EFFECTS ;;
    METAL)    compiled_effects_option=CNA_METAL_COMPILED_EFFECTS ;;
    *)        compiled_effects_option=CNA_EASYGL_COMPILED_EFFECTS ;;
esac

# Modification time, GNU stat or BSD stat.
mtime() { stat -c %Y "$1" 2>/dev/null || stat -f %m "$1"; }

# Build trees are looked for inside the CNA checkout, and also under CNA_BUILD_ROOT when a host keeps
# them out of source (as the Apple-silicon campaign machine does, ~/Desktop/build).
candidate_trees() {
    local d
    for d in "$cna_root"/cmake-build-* "$cna_root"/build "$cna_root"/build-* \
             ${CNA_BUILD_ROOT:+"$CNA_BUILD_ROOT"/*}; do
        [ -d "$d" ] && echo "$d"
    done
}

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
    while read -r d; do
        cache="$d/CMakeCache.txt"
        [ -f "$cache" ] || continue
        grep -q "^CNA_GRAPHICS_RENDERER:STRING=$renderer\$" "$cache" || continue
        grep -q "^CMAKE_TOOLCHAIN_FILE:" "$cache" && continue
        [ -f "$d/modules/c-api/$capi_library" ] || continue
        echo "$(grep -c '^CMAKE_BUILD_TYPE:STRING=Release$' "$cache") $(mtime "$d/modules/c-api/$capi_library") $d"
    done < <(candidate_trees) | sort -rn | head -1 | cut -d' ' -f3-
}

find_existing() {
    local d cache
    while read -r d; do
        cache="$d/CMakeCache.txt"
        [ -f "$cache" ] || continue
        grep -q "^CNA_GRAPHICS_RENDERER:STRING=$renderer\$" "$cache" || continue
        grep -q "^$compiled_effects_option:BOOL=ON$" "$cache" || continue
        # A cross-compiled tree (../cna-dotnet's cmake-build-android-<abi>) is the newest Release
        # OPENGLES3 tree with compiled effects too, and this host cannot load what it builds.
        grep -q "^CMAKE_TOOLCHAIN_FILE:" "$cache" && continue
        [ -f "$d/modules/c-api/$capi_library" ] || continue
        echo "$(grep -c '^CMAKE_BUILD_TYPE:STRING=Release$' "$cache") $(mtime "$d/modules/c-api/$capi_library") $d"
    done < <(candidate_trees) | sort -rn | head -1 | cut -d' ' -f3-
}

build_dir="$(find_existing || true)"

# Fall back to a tree WITHOUT compiled effects rather than stopping. Most rows do not load a
# compiled effect. The warning is the point: a silent fallback would turn "this sample needs an
# effect" into a confusing runtime error much later.
if [ -z "$build_dir" ]; then
    build_dir="$(CNA_REQUIRE_COMPILED_EFFECTS=0 find_existing_any || true)"
    if [ -n "$build_dir" ]; then
        echo "warning: no $renderer tree with $compiled_effects_option=ON; using $build_dir," >&2
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
    # CNA_BUILD_C_API defaults to OFF, so without it the configure succeeds and the cna_c_api
    # target simply does not exist -- the build then fails with "No rule to make target".
    cmake -S "$cna_root" -B "$build_dir" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCNA_BUILD_C_API=ON \
        -DCNA_GRAPHICS_RENDERER="$renderer" \
        -D"$compiled_effects_option"=ON \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache
fi

if [ "${1:-}" = "--no-build" ]; then
    echo "$build_dir/modules/c-api/$capi_library"
    exit 0
fi

cmake --build "$build_dir" --target cna_c_api -j"${CNA_BUILD_JOBS:-8}"

lib="$build_dir/modules/c-api/$capi_library"
abi="$(awk '/#define CNA_ABI_VERSION_(MAJOR|MINOR|PATCH)/ {gsub(/[^0-9]/, "", $3); printf "%s%s", sep, $3; sep="."}' \
    "$cna_root/modules/c-api/include/CNA/C/abi.h")"

echo
echo "native library : $lib"
echo "renderer       : $renderer (compiled effects ON)"
echo "CNA C ABI      : $abi"
echo
echo "CNA.NET admits one reviewed ABI generation at a time; check that $abi is in"
echo "  \$CNA_DOTNET_ROOT/docs/native-abi-compatibility.md before reporting a load failure as a bug."
