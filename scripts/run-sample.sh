#!/usr/bin/env bash
# Runs one sample against the native CNA library.
#
# Usage: scripts/run-sample.sh [options] <SampleDirectory> [-- sample arguments...]
#
#   -c, --configuration <cfg>  Debug or Release (default Release)
#       --headless             run under xvfb-run on a private display
#       --frames N             forwarded to the sample as --frames N
#       --build                dotnet build the sample first
#       --lib <path>           explicit libcna_c_api.so
#
# Note on --frames: it is passed through to the sample, and almost no original XNA sample
# understands it. Deterministic-length runs are a property a sample would have to have had in
# 2010; adding one to a sample's source here would be a fidelity deviation. Use --headless with a
# timeout instead when a sample has no fixed-length mode.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
configuration=Release
headless=0
do_build=0
frames=""
lib="${CNA_NATIVE_LIBRARY:-}"
sample=""

while [ $# -gt 0 ]; do
    case "$1" in
        -c|--configuration) configuration="$2"; shift 2 ;;
        --headless)         headless=1; shift ;;
        --build)            do_build=1; shift ;;
        --frames)           frames="$2"; shift 2 ;;
        --lib)              lib="$2"; shift 2 ;;
        --)                 shift; break ;;
        -h|--help)          sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)                 echo "error: unknown option $1" >&2; exit 2 ;;
        *)                  sample="$1"; shift ;;
    esac
done

if [ -z "$sample" ]; then
    echo "error: no sample given; try: $(basename "$0") PrimitivesSample" >&2
    exit 2
fi

project_dir="$here/samples/$sample"
project="$project_dir/$sample.csproj"
if [ ! -f "$project" ]; then
    echo "error: $project does not exist" >&2
    echo "available: $(cd "$here/samples" 2>/dev/null && ls -d */ 2>/dev/null | tr -d / | tr '\n' ' ')" >&2
    exit 2
fi

if [ -z "$lib" ]; then
    lib="$("$here/scripts/build-native-cna.sh" --no-build)"
fi
if [ ! -f "$lib" ]; then
    echo "error: native CNA library not found at $lib" >&2
    echo "run scripts/build-native-cna.sh, or pass --lib" >&2
    exit 2
fi

if [ "$do_build" = 1 ]; then
    dotnet build "$project" -c "$configuration"
fi

# AppendTargetFrameworkToOutputPath is off, and AssemblyName keeps the original project's name,
# so the executable is bin/<cfg>/<AssemblyName> rather than bin/<cfg>/<SampleDirectory>.
exe="$(find "$project_dir/bin/$configuration" -maxdepth 1 -type f -executable ! -name '*.so' ! -name '*.dll' 2>/dev/null | head -1)"
if [ -z "$exe" ]; then
    echo "error: no $configuration build of $sample; re-run with --build" >&2
    exit 2
fi

set -- "$@"
if [ -n "$frames" ]; then
    set -- --frames "$frames" "$@"
fi

export CNA_NATIVE_LIBRARY="$lib"
echo "sample   : $sample"
echo "exe      : $exe"
echo "native   : $lib"
[ $# -gt 0 ] && echo "arguments: $*"
echo

cd "$(dirname "$exe")"
if [ "$headless" = 1 ]; then
    exec xvfb-run -a "$exe" "$@"
fi
exec "$exe" "$@"
