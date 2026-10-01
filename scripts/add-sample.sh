#!/usr/bin/env bash
# Scaffolds one manifest row: the upstream project directory checked in verbatim (without its
# pipeline inputs and build output), the upstream .htm beside it, the official compiled content the
# C++ campaign holds, the manifest line and the solution entry. The .csproj is the row's own
# decision (entry point, profile, phone host) and is written by hand afterwards.
#
# Usage: scripts/add-sample.sh <SampleDirectory> <UpstreamDirectory> <UpstreamSubpath> <CppPort|->
#   e.g. scripts/add-sample.sh SimpleAnimation SimpleAnimation_4_0 SimpleAnimation SimpleAnimation
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
upstream_root="${XNA_SAMPLES_ROOT:-/rv/tmp/XNAGameStudio/Samples}"
ports="${CNA_SAMPLES_ROOT:-$(cd "$here/.." && pwd)/cna-samples}/samples"
[ $# -eq 4 ] || { sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
sample=$1; upstream=$2; subpath=$3; port=$4

src="$upstream_root/$upstream/$subpath"
dst="$here/samples/$sample"
[ -d "$src" ] || { echo "error: no upstream directory $src" >&2; exit 2; }
[ ! -e "$dst" ] || { echo "error: $dst already exists" >&2; exit 2; }
grep -q "^$sample	" "$here/samples/manifest.tsv" && { echo "error: $sample is already in the manifest" >&2; exit 2; }

mkdir -p "$dst"
# The same exclusions scripts/check-verbatim.sh makes: pipeline inputs and Visual Studio output.
rsync -a --exclude Content --exclude bin --exclude obj "$src/" "$dst/$(basename "$subpath")/"
find "$upstream_root/$upstream" -maxdepth 1 -name '*.htm' -exec cp {} "$dst/" \;

if [ "$port" != "-" ]; then
    [ -d "$ports/$port/Content" ] || { echo "error: no content at $ports/$port/Content" >&2; exit 2; }
    mkdir -p "$dst/Content"
    # Only the compiled assets; the port's own CNA-native files (.cnj and the like) are not XNA's.
    (cd "$ports/$port/Content" && find . -name '*.xnb' -print0 | cpio -0pdm --quiet "$dst/Content")
fi

printf '%s\t%s\t%s\t%s\n' "$sample" "$upstream" "$subpath" "$port" >>"$here/samples/manifest.tsv"
echo "scaffolded $dst; write $sample.csproj, then:"
echo "  dotnet sln $here/CnaCsSamples.sln add samples/$sample/$sample.csproj"
echo "  scripts/check-verbatim.sh $sample && scripts/check-content.sh"
