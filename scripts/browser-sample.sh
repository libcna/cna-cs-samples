#!/usr/bin/env bash
# Builds one sample for the browser and runs it in headless Chromium.
#
# Usage: scripts/browser-sample.sh <SampleDirectory|games/Game> [--out DIR] [--seconds N] [--marker TEXT] [--threads]
#
# A gallery row is named by its directory under samples/; a real game by its path (games/<Game>),
# whose sources its <GameProject> target supplies and whose Content its LinkBase items link.
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
sample=""; out=""; seconds=8; marker=""; threads=0
while [ $# -gt 0 ]; do
    case "$1" in
        --out)     out="$2"; shift 2 ;;
        --seconds) seconds="$2"; shift 2 ;;
        --marker)  marker="$2"; shift 2 ;;
        --threads) threads=1; shift ;;
        -h|--help) sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)        echo "error: unknown option $1" >&2; exit 2 ;;
        *)         sample="$1"; shift ;;
    esac
done
[ -n "$sample" ] || { echo "usage: $0 <SampleDirectory>" >&2; exit 2; }
# A game one directory deeper (games/Xen/Platformer) is named by both directories, so it never
# shares a generated project with a gallery row of the same name (samples/Platformer), and its
# project is the one .csproj in its directory whatever that is called.
case "$sample" in
    */*) sample_dir="$here/${sample%/}"; rel="${sample%/}"; rel="${rel#games/}"; sample="${rel//\//-}" ;;
    *)   sample_dir="$here/samples/$sample" ;;
esac
project="$sample_dir/$(basename "$sample_dir").csproj"
if [ ! -f "$project" ] && [ "$(ls "$sample_dir"/*.csproj 2>/dev/null | wc -l)" = 1 ]; then
    project="$(ls "$sample_dir"/*.csproj)"
fi
[ -f "$project" ] || { echo "error: no $project" >&2; exit 2; }
out="${out:-/rv/tmp/cs-samples/browser/$sample}"
mkdir -p "$out"

# --threads: a multithreaded bundle (WasmEnableThreads, shared-memory CNA) for a game that starts
# threads; its own generated project, so the two runtime packs never share an obj directory.
work="$here/build-consumer/browser/$sample"
if [ "$threads" = 1 ]; then work="$work-threads"; fi
export CNA_BROWSER_THREADS="$threads"
mkdir -p "$work/wwwroot"
cp "$cs_root/eng/browser/wwwroot/index.html" "$cs_root/eng/browser/wwwroot/main.js" "$work/wwwroot/"

# A game's sources are Compile items its CnaGameProjectSources target adds, so that target runs first.
targets=()
[ -n "$(DOTNET_CLI_TELEMETRY_OPTOUT=1 dotnet msbuild "$project" -getProperty:GameProject)" ] && targets=(-t:CnaGameProjectSources)
DOTNET_CLI_TELEMETRY_OPTOUT=1 dotnet msbuild "$project" "${targets[@]}" -getProperty:AssemblyName \
    -getProperty:RootNamespace -getProperty:StartupObject -getProperty:CnaSampleDefineConstants \
    -getProperty:XnaProfile -getProperty:XnaPlatform -getProperty:CnaPhoneGame \
    -getProperty:CnaPhoneCompat -getProperty:CnaWindowsFormsCompat -getProperty:CnaSampleConfiguration -getItem:Compile \
    -getItem:EmbeddedResource -getItem:ProjectReference -getItem:Reference -getItem:PackageReference -getItem:None -getItem:Content -getItem:CnaWindowsPath >"$work/evaluation.json"

# Library projects beside the sample (Pathfinding's MapData, SpriteSheet's runtime) are referenced
# as their own Release builds, not merged in: content names their readers by assembly. So are the
# XNA-named forwarders a game referencing a library compiled against XNA names (src/XnaAssemblies).
python3 - "$work/evaluation.json" "$cs_root" <<'PYEOF' >"$work/libraries.txt"
import json, sys
items = json.load(open(sys.argv[1]))["Items"].get("ProjectReference", [])
for item in items:
    if not item["FullPath"].startswith(sys.argv[2].rstrip("/") + "/") or "/src/XnaAssemblies/" in item["FullPath"]:
        print(item["FullPath"])
PYEOF
: >"$work/library-paths.txt"
while read -r library; do
    [ -n "$library" ] || continue
    dotnet build "$library" -c Release -m:1 >/dev/null
    DOTNET_CLI_TELEMETRY_OPTOUT=1 dotnet msbuild "$library" -p:Configuration=Release \
        -getProperty:TargetPath >>"$work/library-paths.txt"
done <"$work/libraries.txt"

python3 - "$work" "$sample_dir" "$cs_root" <<'EOF'
import json, os, sys
from pathlib import Path
from xml.sax.saxutils import escape, quoteattr

work, sample_dir, cs_root = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
def msbuild(value):
    return escape(value.replace("%", "%25").replace(";", "%3B"))
libraries = [Path(line.strip()) for line in (work / "library-paths.txt").read_text().splitlines() if line.strip()]
evaluation = json.loads((work / "evaluation.json").read_text())
props = evaluation["Properties"]
# .NET's browser runtime cannot load an assembly whose name holds an apostrophe: the WebAssembly SDK's
# conditions and its asset loader both split the name there (A Princess' Request). Such a game is
# built for the browser without it -- its project's name, not its source; content naming its own
# readers by that assembly would then not find them, which is said here when it happens.
if "'" in props["AssemblyName"]:
    print(f"browser assembly name: {props['AssemblyName']!r} without its apostrophe", file=sys.stderr)
    props["AssemblyName"] = props["AssemblyName"].replace("'", "")
items = evaluation.get("Items", {})
binaries = cs_root / "src/CNA.XnaCompat/bin/Release/net8.0"
references = ["CNA.Interop", "CNA.Framework", "CNA.XnaCompat"]
folders = {}
if props.get("CnaPhoneCompat") == "true":
    references.append("CNA.PhoneCompat")
    folders["CNA.PhoneCompat"] = cs_root / "src/CNA.PhoneCompat/bin/Release/net8.0"
if props.get("CnaWindowsFormsCompat") == "true":
    references.append("CNA.WindowsFormsCompat")
    folders["CNA.WindowsFormsCompat"] = cs_root / "src/CNA.WindowsFormsCompat/bin/Release/net8.0"

lines = ['<Project Sdk="Microsoft.NET.Sdk.WebAssembly">', "  <PropertyGroup>",
         "    <TargetFramework>net11.0</TargetFramework>",
         f"    <AssemblyName>{msbuild(props['AssemblyName'])}</AssemblyName>",
         f"    <RootNamespace>{escape(props['RootNamespace'])}</RootNamespace>",
         "    <ImplicitUsings>disable</ImplicitUsings>",
         "    <Nullable>disable</Nullable>",
         "    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>",
         "    <EnableDefaultCompileItems>false</EnableDefaultCompileItems>",
         "    <EnableDefaultEmbeddedResourceItems>false</EnableDefaultEmbeddedResourceItems>",
         "    <TreatWarningsAsErrors>false</TreatWarningsAsErrors>",
         f"    <DefineConstants>$(DefineConstants);{escape(props.get('CnaSampleDefineConstants') or 'WINDOWS')}</DefineConstants>"]
# A row qualified in Debug keeps its DEBUG-only code ([Conditional("DEBUG")] drawing, say).
if props.get("CnaSampleConfiguration") == "Debug":
    lines.append("    <DefineConstants>$(DefineConstants);DEBUG</DefineConstants>")
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
# A prebuilt library the game ships (BEPUphysics, DPSF, ...) is referenced where it lies.
for item in items.get("Reference", []):
    hint = item.get("HintPath", "")
    if hint:
        lines.append(f'    <Reference Include={quoteattr(item["Identity"])}><HintPath>{escape(hint)}</HintPath></Reference>')
        lines.append(f'    <TrimmerRootAssembly Include={quoteattr(Path(hint).stem)} />')
# A library's own prebuilt dependencies (XPF's Rx) are copied beside it by its build and referenced
# from there; CNA.NET's assemblies, the XNA-named forwarders and other libraries are referenced above
# or below, so they are not taken twice.
referenced = {Path(item.get("HintPath", "")).stem for item in items.get("Reference", [])} | {l.stem for l in libraries}
for library in libraries:
    lines.append(f'    <Reference Include="{library.stem}"><HintPath>{library}</HintPath></Reference>')
    lines.append(f'    <TrimmerRootAssembly Include="{library.stem}" />')
    for dependency in sorted(library.parent.glob("*.dll")):
        name = dependency.stem
        if name in referenced or name.startswith(("CNA.", "Microsoft.Xna.Framework")):
            continue
        referenced.add(name)
        lines.append(f'    <Reference Include="{name}"><HintPath>{dependency}</HintPath></Reference>')
        lines.append(f'    <TrimmerRootAssembly Include="{name}" />')
lines.append(f'    <TrimmerRootAssembly Include="{msbuild(props["AssemblyName"])}" />')
for name in folders:
    lines.append(f'    <TrimmerRootAssembly Include="{name}" />')
# NuGet packages the game's project glue adds (ConfigurationManager, CodeDom: .NET Framework's own
# assemblies, packages on .NET).
for item in items.get("PackageReference", []):
    if item.get("Version"):
        lines.append(f'    <PackageReference Include={quoteattr(item["Identity"])} Version={quoteattr(item["Version"])} />')
for name in references:
    folder = folders.get(name, binaries)
    lines.append(f'    <Reference Include="{name}"><HintPath>{folder / (name + ".dll")}</HintPath></Reference>')
# The SDK puts only static web assets into the virtual filesystem, matched by their path under
# wwwroot; Content is linked there rather than copied.
content = sample_dir / "Content"
whole_content = content.is_dir()
if whole_content:
    link = work / "wwwroot" / "Content"
    if link.is_symlink() or link.exists():
        link.unlink()
    link.symlink_to(content, target_is_directory=True)
    for file in sorted(content.rglob("*")):
        if file.is_file():
            relative = (Path("Content") / file.relative_to(content)).as_posix()
            lines.append(f"    <WasmFilesToIncludeInFileSystem Include={quoteattr(relative)} TargetPath={quoteattr(relative)} />")
# Every other file the build copies beside the game goes where the game looks for it: a game's
# Content linked under Content/ (LinkBase), and files such as Spacewar's settings.xml (Link).
for item in items.get("None", []) + items.get("Content", []):
    if item.get("CopyToOutputDirectory", "") not in ("PreserveNewest", "Always"):
        continue
    if item.get("Link"):
        relative = item["Link"].replace("\\", "/")
    elif item.get("LinkBase"):
        relative = (Path(item["LinkBase"]) / item.get("RecursiveDir", "").replace("\\", "/") / (item["Filename"] + item["Extension"])).as_posix()
    elif Path(item["FullPath"]).is_relative_to(sample_dir):
        relative = Path(item["FullPath"]).relative_to(sample_dir).as_posix()
    else:
        continue
    if whole_content and relative.startswith("Content/"):
        continue
    target = work / "wwwroot" / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.is_symlink() or target.exists():
        target.unlink()
    target.symlink_to(item["FullPath"])
    lines.append(f"    <WasmFilesToIncludeInFileSystem Include={quoteattr(relative)} TargetPath={quoteattr(relative)} />")
lines.append("  </ItemGroup>")
if props.get("CnaPhoneGame"):
    (work / "CnaPhoneHost.g.cs").write_text(
        "// The XAP host's stand-in, as samples/Directory.Build.targets generates it.\n"
        "static class CnaPhoneHost { static void Main() { using (var game = new global::"
        + props["CnaPhoneGame"] + "()) { game.Run(); } } }\n")
    lines.append('  <ItemGroup><Compile Include="CnaPhoneHost.g.cs" /></ItemGroup>')
# The Windows-spelled paths the game opens through the BCL (samples/Directory.Build.targets'
# CnaWindowsPath), linked in the browser's file system before its Main runs.
windows_paths = [(item["Path"], item["LinksTo"]) for item in items.get("CnaWindowsPath", [])]
if windows_paths:
    calls = "\n".join(f"        Link({json.dumps(path)}, {json.dumps(target)});" for path, target in windows_paths)
    (work / "CnaWindowsPaths.g.cs").write_text(
        "// Generated by scripts/browser-sample.sh from the game's CnaWindowsPath items.\n"
        "static class CnaWindowsPaths\n{\n"
        "#pragma warning disable CA2255\n"
        "    [System.Runtime.CompilerServices.ModuleInitializer]\n"
        "#pragma warning restore CA2255\n"
        "    internal static void LinkAll()\n    {\n" + calls + "\n    }\n\n"
        "    private static void Link(string path, string target)\n    {\n"
        "        if (!System.IO.File.Exists(path) && !System.IO.Directory.Exists(path))\n"
        "            System.IO.File.CreateSymbolicLink(path, target);\n"
        "    }\n}\n")
    lines.append('  <ItemGroup><Compile Include="CnaWindowsPaths.g.cs" /></ItemGroup>')
if os.environ.get("CNA_BROWSER_THREADS") == "1":
    lines.append("  <PropertyGroup><WasmEnableThreads>true</WasmEnableThreads></PropertyGroup>")
lines += [f'  <Import Project="{cs_root}/src/CNA.XnaCompat/build/CNA.XnaCompat.targets" />',
          f'  <Import Project="{cs_root}/eng/browser/CNA.Browser.targets" />', "</Project>", ""]
(work / f"{sample_dir.name}.Browser.csproj").write_text("\n".join(lines))
EOF

export DOTNET_ROOT="$dotnet_root" DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1
# A publish over a previous obj/ has left index.html with its placeholders unsubstituted.
rm -rf "$work/publish" "$work/obj" "$work/bin"
if ! "$dotnet_root/dotnet" publish "$work/$(basename "$sample_dir").Browser.csproj" -c Release -o "$work/publish" \
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
