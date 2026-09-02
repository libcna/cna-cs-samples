#!/usr/bin/env bash
# Reports everything needed to write a sample's .csproj, in one shot.
# Usage: scripts/inspect-upstream.sh <UpstreamDirectoryName> [CppPortName]
set -euo pipefail
U="/rv/tmp/XNAGameStudio/Samples/$1"
PORT="${2:-}"
[ -d "$U" ] || { echo "no such upstream: $U" >&2; exit 2; }

echo "### solutions"; find "$U" -maxdepth 1 -name "*.sln" -printf "  %f\n" | sort
echo "### projects"; find "$U" -name "*.csproj" -printf "  %P\n" | sort
echo "### Windows/Xbox project settings"
for p in $(find "$U" -name "*.csproj" | grep -viE "phone|mango|silverlight" | sort); do
    echo "  -- ${p#$U/}"
    grep -hE "<(OutputType|RootNamespace|AssemblyName|XnaPlatform|XnaProfile|DefineConstants)>" "$p" \
        | sed 's/^[[:space:]]*/     /'
done
echo "### entry points"
grep -rn "static void Main" "$U" --include=*.cs | sed "s#$U/#  #"
echo "### the class each Main constructs"
grep -rn -A 3 "static void Main" "$U" --include=*.cs | grep -oE "new [A-Za-z0-9_]+\(\)" | sort -u | sed 's/^/  /'
echo "### Content.Load calls"
grep -rhn "Content\.Load<" "$U" --include=*.cs | sed 's/^[[:space:]]*/  /' | sort -u | head -20
echo "### unguarded Microsoft.Devices (blocks the build)"
python3 - "$U" <<'PY'
import sys, pathlib
root = pathlib.Path(sys.argv[1]); hits = []
for f in root.rglob("*.cs"):
    stack = []
    for n, line in enumerate(f.read_text(errors="replace").splitlines(), 1):
        s = line.strip()
        if s.startswith("#if"):    stack.append("WINDOWS_PHONE" in s and "!" not in s)
        elif s.startswith("#elif"):
            if stack: stack[-1] = "WINDOWS_PHONE" in s and "!" not in s
        elif s.startswith("#else"):
            if stack: stack[-1] = not stack[-1]
        elif s.startswith("#endif"):
            if stack: stack.pop()
        elif "Microsoft.Devices" in line and not any(stack):
            hits.append(f"  {f.relative_to(root)}:{n}")
print("\n".join(hits) if hits else "  none")
PY
if [ -n "$PORT" ]; then
    C="/rv/data/development/github.com/openeggbert/cna-samples/samples/$PORT/Content"
    echo "### C++ port content ($PORT)"
    if [ -d "$C" ]; then
        find "$C" -type f -printf "  %P\n" | sort | head -30
        n=$(find "$C" -name '*.xnb' | wc -l); t=$(find "$C" -type f | wc -l)
        echo "  -> $n of $t files are .xnb"
        [ "$n" -lt "$t" ] && echo "  !! the port ships non-.xnb assets; see rules.md on content provenance" || true
    else
        echo "  (no Content directory)"
    fi
fi
