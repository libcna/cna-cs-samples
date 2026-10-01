#!/usr/bin/env bash
# Builds one sample for the browser and runs it in headless Chromium.
#
# Usage: scripts/browser-sample.sh <SampleDirectory> [--out DIR] [--seconds N] [--marker TEXT]
#
# The sample's own project is untouched. Its evaluated identity -- assembly name, root namespace,
# entry point, DefineConstants, XnaProfile, phone host -- and its Compile items are read from
# MSBuild, and a browser project that includes the same sources and Content is generated under
# build-consumer/browser/<Sample>/ (outside samples/, so the desktop glue does not apply). It is
# a Microsoft.NET.Sdk.WebAssembly project for net11.0, the first .NET whose WebAssembly toolchain
# compiles CNA, linking the archive ../cna-cs/scripts/Build-BrowserNative.sh stages; the CNA.NET
# assemblies it references are the net8.0 Release builds beside it.
#
# Needs the .NET 11 SDK with the wasm-tools workload (default ~/deps/dotnet11; DOTNET_ROOT_BROWSER
# overrides) and Playwright's Chromium under the emsdk node (NODE_PATH overrides).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cs_root="$(cd "$here/../cna-cs" && pwd)"
dotnet_root="${DOTNET_ROOT_BROWSER:-$HOME/deps/dotnet11}"
node_dir="${CNA_BROWSER_NODE_DIR:-$HOME/emsdk/node/22.16.0_64bit}"
sample=""; out=""; seconds=8; marker=""
while [ $# -gt 0 ]; do
    case "$1" in
        --out)     out="$2"; shift 2 ;;
        --seconds) seconds="$2"; shift 2 ;;
        --marker)  marker="$2"; shift 2 ;;
        -h|--help) sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)        echo "error: unknown option $1" >&2; exit 2 ;;
        *)         sample="$1"; shift ;;
    esac
done
[ -n "$sample" ] || { echo "usage: $0 <SampleDirectory>" >&2; exit 2; }
project="$here/samples/$sample/$sample.csproj"
[ -f "$project" ] || { echo "error: no $project" >&2; exit 2; }
out="${out:-/rv/tmp/cs-samples/browser/$sample}"
mkdir -p "$out"

work="$here/build-consumer/browser/$sample"
mkdir -p "$work/wwwroot"
cp "$cs_root/eng/browser/wwwroot/index.html" "$cs_root/eng/browser/wwwroot/main.js" "$work/wwwroot/"

DOTNET_CLI_TELEMETRY_OPTOUT=1 dotnet msbuild "$project" -getProperty:AssemblyName \
    -getProperty:RootNamespace -getProperty:StartupObject -getProperty:CnaSampleDefineConstants \
    -getProperty:XnaProfile -getProperty:XnaPlatform -getProperty:CnaPhoneGame \
    -getProperty:CnaPhoneCompat -getItem:Compile -getItem:EmbeddedResource >"$work/evaluation.json"

python3 - "$work" "$here/samples/$sample" "$cs_root" <<'EOF'
import json, sys
from pathlib import Path
from xml.sax.saxutils import escape, quoteattr

work, sample_dir, cs_root = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
evaluation = json.loads((work / "evaluation.json").read_text())
props = evaluation["Properties"]
items = evaluation.get("Items", {})
binaries = cs_root / "src/CNA.XnaCompat/bin/Release/net8.0"
references = ["CNA.Interop", "CNA.Framework", "CNA.XnaCompat"]
if props.get("CnaPhoneCompat") == "true":
    references.append("CNA.PhoneCompat")
    binaries_phone = cs_root / "src/CNA.PhoneCompat/bin/Release/net8.0"

lines = ['<Project Sdk="Microsoft.NET.Sdk.WebAssembly">', "  <PropertyGroup>",
         "    <TargetFramework>net11.0</TargetFramework>",
         f"    <AssemblyName>{escape(props['AssemblyName'])}</AssemblyName>",
         f"    <RootNamespace>{escape(props['RootNamespace'])}</RootNamespace>",
         "    <ImplicitUsings>disable</ImplicitUsings>",
         "    <Nullable>disable</Nullable>",
         "    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>",
         "    <EnableDefaultCompileItems>false</EnableDefaultCompileItems>",
         "    <EnableDefaultEmbeddedResourceItems>false</EnableDefaultEmbeddedResourceItems>",
         "    <TreatWarningsAsErrors>false</TreatWarningsAsErrors>",
         f"    <DefineConstants>$(DefineConstants);{escape(props.get('CnaSampleDefineConstants') or 'WINDOWS')}</DefineConstants>"]
if props.get("XnaProfile"):
    lines.append(f"    <XnaProfile>{escape(props['XnaProfile'])}</XnaProfile>")
if props.get("XnaPlatform"):
    lines.append(f"    <XnaPlatform>{escape(props['XnaPlatform'])}</XnaPlatform>")
startup = "CnaPhoneHost" if props.get("CnaPhoneGame") else props.get("StartupObject")
if startup:
    lines.append(f"    <StartupObject>{escape(startup)}</StartupObject>")
lines += ["  </PropertyGroup>", "  <ItemGroup>"]
for item in items.get("Compile", []):
    path = item["FullPath"]
    if "/obj/" in path:
        continue
    lines.append(f"    <Compile Include={quoteattr(path)} />")
for item in items.get("EmbeddedResource", []):
    logical = item.get("LogicalName", "")
    attr = f" LogicalName={quoteattr(logical)}" if logical else ""
    lines.append(f"    <EmbeddedResource Include={quoteattr(item['FullPath'])}{attr} />")
for name in references:
    folder = binaries_phone if name == "CNA.PhoneCompat" else binaries
    lines.append(f'    <Reference Include="{name}"><HintPath>{folder / (name + ".dll")}</HintPath></Reference>')
# The SDK puts only static web assets into the virtual filesystem, matched by their path under
# wwwroot; Content is linked there rather than copied.
content = sample_dir / "Content"
if content.is_dir():
    link = work / "wwwroot" / "Content"
    if link.is_symlink() or link.exists():
        link.unlink()
    link.symlink_to(content, target_is_directory=True)
    for file in sorted(content.rglob("*")):
        if file.is_file():
            relative = (Path("Content") / file.relative_to(content)).as_posix()
            lines.append(f"    <WasmFilesToIncludeInFileSystem Include={quoteattr(relative)} TargetPath={quoteattr(relative)} />")
lines.append("  </ItemGroup>")
if props.get("CnaPhoneGame"):
    (work / "CnaPhoneHost.g.cs").write_text(
        "// The XAP host's stand-in, as samples/Directory.Build.targets generates it.\n"
        "static class CnaPhoneHost { static void Main() { using (var game = new global::"
        + props["CnaPhoneGame"] + "()) { game.Run(); } } }\n")
    lines.append('  <ItemGroup><Compile Include="CnaPhoneHost.g.cs" /></ItemGroup>')
lines += [f'  <Import Project="{cs_root}/src/CNA.XnaCompat/build/CNA.XnaCompat.targets" />',
          f'  <Import Project="{cs_root}/eng/browser/CNA.Browser.targets" />', "</Project>", ""]
(work / f"{sample_dir.name}.Browser.csproj").write_text("\n".join(lines))
EOF

export DOTNET_ROOT="$dotnet_root" DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1
# A publish over a previous obj/ has left index.html with its placeholders unsubstituted.
rm -rf "$work/publish" "$work/obj" "$work/bin"
if ! "$dotnet_root/dotnet" publish "$work/$sample.Browser.csproj" -c Release -o "$work/publish" \
        >"$out/publish.log" 2>&1; then
    grep -E " error " "$out/publish.log" | sort -u | head -20 >&2
    echo "error: the browser build failed; see $out/publish.log" >&2
    exit 1
fi

env -u DISPLAY -u WAYLAND_DISPLAY CNA_RUN_SECONDS="$seconds" NODE_PATH="$node_dir/lib/node_modules" \
    "$node_dir/bin/node" "$cs_root/scripts/Run-BrowserPage.mjs" "$work/publish/wwwroot" \
    "$out/$sample.png" "$marker" >"$out/run.log" 2>&1 || status=$?
grep -v "^\s*$\|GL Driver Message\|WEBGL_polygon_mode" "$out/run.log" | tail -25
echo "capture  : $out/$sample.png"
exit "${status:-0}"
