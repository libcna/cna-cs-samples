#!/usr/bin/env bash
# Builds an unchanged XNA Game Studio 4.0 content project with XNA's own BuildContent task under
# Wine, for a game whose repository ships no compiled content. The output is official pipeline
# output in the sense rules.md requires: Microsoft's importers and processors, the project's own
# settings, the game's own pipeline extensions.
#
# Usage: scripts/build-xna-content.sh --project X.contentproj --out DIR [--obj DIR]
#            [--profile Reach|HiDef] [--platform Windows] [--compress true|false]
#            [--extension Y.csproj ...] [--font F.ttf ...] [--song-standins] [--video-standins]
#
# --extension compiles one of the game's pipeline-extension (or content-runtime) projects with mono
# against XNA's assemblies and hands it to BuildContent; list them in dependency order. XACT
# projects (.xap) are built with Game Studio's XactBld3.exe into the matching output folder. --font
# installs a font the game's developers had installed (resonance-game ships its Dot Matrix .ttf);
# Game Studio's own redistributable fonts (Kootenay, OCR A Extended, Segoe UI Mono, ...) are always
# installed, as a Game Studio installation put them on the developer's machine.
#
# Needs the XNA 4.0 Wine prefix (~/.wine-cna-xna40, CNA_XNA40_WINEPREFIX) and the Game Studio
# reference assemblies the C++ campaign unpacked (CNA_XNA40_GS). The pipeline creates a real D3D9
# device, so it gets a private Xvfb, never the desktop. Wine cannot run WmaImporter (songs) or
# VideoProcessor (videos); those assets are listed, not built, and --song-standins/--video-standins
# write labelled stand-ins for them (scripts/song-standin.sh, scripts/video-standin.sh).
# A source file the content project lists and its repository does not ship is listed as
# "skipped missing" and not built either.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
gs="${CNA_XNA40_GS:-/rv/tmp/samples/_tools/xna-game-studio-4-refresh/admin}"
refs="$gs/Program Files/Microsoft XNA/XNA Game Studio/v4.0/References/Windows/x86"
gs_bin="$gs/Program Files/Microsoft XNA/XNA Game Studio/v4.0/Bin"
wine_prefix="${CNA_XNA40_WINEPREFIX:-$HOME/.wine-cna-xna40}"
xna_native="$wine_prefix/drive_c/Program Files/Common Files/Microsoft Shared/XNA/Framework/v4.0/XnaNative.dll"
runner="$here/build-consumer/xna-content-runner"

project=""; out=""; obj=""; profile=Reach; platform=Windows; compress=false; extensions=(); fonts=(); standins=false; video_standins=false
while [ $# -gt 0 ]; do
    case "$1" in
        --project)   project="$(realpath "$2")"; shift 2 ;;
        --out)       out="$(realpath -m "$2")"; shift 2 ;;
        --obj)       obj="$(realpath -m "$2")"; shift 2 ;;
        --profile)   profile="$2"; shift 2 ;;
        --platform)  platform="$2"; shift 2 ;;
        --compress)  compress="$2"; shift 2 ;;
        --extension) extensions+=("$(realpath "$2")"); shift 2 ;;
        --font)      fonts+=("$(realpath "$2")"); shift 2 ;;
        --song-standins) standins=true; shift ;;
        --video-standins) video_standins=true; shift ;;
        -h|--help)   sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "error: unknown argument $1" >&2; exit 2 ;;
    esac
done
[ -f "$project" ] && [ -n "$out" ] || { echo "error: --project and --out are required" >&2; exit 2; }
obj="${obj:-$out.obj}"
win() { printf 'Z:%s' "$1" | sed 's#/#\\#g'; }

mkdir -p "$runner" "$out" "$obj"
for dll in Microsoft.Xna.Framework.dll Microsoft.Xna.Framework.Game.dll Microsoft.Xna.Framework.Graphics.dll \
           Microsoft.Xna.Framework.Content.Pipeline.dll Microsoft.Xna.Framework.Content.Pipeline.TextureImporter.dll \
           Microsoft.Xna.Framework.Content.Pipeline.EffectImporter.dll Microsoft.Xna.Framework.Content.Pipeline.FBXImporter.dll \
           Microsoft.Xna.Framework.Content.Pipeline.XImporter.dll Microsoft.Xna.Framework.Content.Pipeline.AudioImporters.dll \
           Microsoft.Xna.Framework.Content.Pipeline.VideoImporters.dll Microsoft.Xna.Framework.Xact.dll \
           Microsoft.Xna.Framework.Avatar.dll Microsoft.Xna.Framework.GamerServices.dll Microsoft.Xna.Framework.Net.dll \
           Microsoft.Xna.Framework.Storage.dll Microsoft.Xna.Framework.Video.dll Microsoft.Xna.Framework.Input.Touch.dll; do
    [ -f "$refs/$dll" ] && cp -u "$refs/$dll" "$runner/"
done
cp -u "$xna_native" "$runner/"
cp -u "$gs_bin/XnaMediaHelper_1.dll" "$runner/"
cp -u /usr/lib/mono/4.5/Microsoft.Build.Framework.dll /usr/lib/mono/4.5/Microsoft.Build.Utilities.v4.0.dll "$runner/"
mcs -nologo -platform:x86 -target:exe -out:"$runner/XnaContentBuilder.exe" \
    -r:"$runner/Microsoft.Build.Framework.dll" -r:"$runner/Microsoft.Build.Utilities.v4.0.dll" \
    -r:"$runner/Microsoft.Xna.Framework.Content.Pipeline.dll" "$here/scripts/xna/XnaContentBuilder.cs"
# Large-address-aware, as Visual Studio 2010 and its MSBuild were: a 32-bit content build then has
# 4 GB on a 64-bit host instead of 2 (resonance-game's model importer needs more than 2).
python3 - "$runner/XnaContentBuilder.exe" <<'PYEOF'
import struct, sys
path = sys.argv[1]
data = bytearray(open(path, "rb").read())
pe = struct.unpack_from("<I", data, 0x3C)[0]
characteristics = pe + 4 + 18
flags = struct.unpack_from("<H", data, characteristics)[0]
struct.pack_into("<H", data, characteristics, flags | 0x0020)
open(path, "wb").write(data)
PYEOF

# The game's own pipeline extensions, compiled from their projects' Compile items.
xna_refs=()
for dll in "$runner"/Microsoft.Xna.Framework*.dll; do xna_refs+=("-r:$dll"); done
pipeline=()
built=()
for csproj in "${extensions[@]}"; do
    dir="$(dirname "$csproj")"
    name="$(sed -n 's:.*<AssemblyName>\(.*\)</AssemblyName>.*:\1:p' "$csproj" | head -1)"
    # Its Compile items, and the references its project names: framework assemblies by name, and
    # prebuilt libraries by HintPath (copied beside the pipeline, which loads them too).
    sources=(); extra=()
    api=/usr/lib/mono/4.0-api
    while IFS= read -r line; do
        case "$line" in
            SRC:*)  sources+=("${line#SRC:}") ;;
            UNSAFE) extra+=("-unsafe") ;;
            KEY:*)  extra+=("-keyfile:${line#KEY:}") ;;
            DEF:*)  extra+=("-define:${line#DEF:}") ;;
            RESX:*) resx="${line#RESX:}"; resx_file="${resx%%|*}"; resx_name="${resx##*|}"
                    resgen "$resx_file" "$runner/$resx_name" >/dev/null
                    extra+=("-resource:$runner/$resx_name,$resx_name") ;;
            FW:*)   [ -f "$api/${line#FW:}.dll" ] && extra+=("-r:$api/${line#FW:}.dll") ;;
            HINT:*) cp -u "${line#HINT:}" "$runner/"
                    extra+=("-r:$runner/$(basename "${line#HINT:}")")
                    pipeline+=("$(win "$runner/$(basename "${line#HINT:}")")") ;;
        esac
    done < <(python3 - "$csproj" <<'PYEOF'
import re, sys, os
p = sys.argv[1]
text = open(p, encoding="utf-8-sig").read()
here = os.path.dirname(p)
for inc in re.findall(r'<Compile Include="([^"]+)"', text):
    print("SRC:" + os.path.join(here, inc.replace("\\", "/")))
if re.search(r'<AllowUnsafeBlocks>\s*true', text, re.I):
    print("UNSAFE")
# The symbols of its first (Debug) configuration: ProjectMercury's code is all #if WINDOWS.
defines = re.search(r'<DefineConstants>([^<]*)</DefineConstants>', text)
if defines:
    names = [d for d in re.split(r'[;, ]+', defines.group(1)) if d]
    if names:
        print("DEF:" + ";".join(names))
# Its .resx resources, under the name its build gave them (<RootNamespace>.<folders>.<name>.resources;
# XNAnimationPipeline reads its messages from Resources.resx).
root = re.search(r'<RootNamespace>([^<]+)</RootNamespace>', text)
for inc in re.findall(r'<EmbeddedResource Include="([^"]+\.resx)"', text):
    name = (root.group(1) + "." if root else "") + os.path.splitext(inc)[0].replace("\\", ".").replace("/", ".") + ".resources"
    print("RESX:" + os.path.join(here, inc.replace("\\", "/")) + "|" + name)
# Signed as its project signed it (XNAnimation grants its internals to a signed XNAnimationPipeline).
key = re.search(r'<AssemblyOriginatorKeyFile>([^<]+)</AssemblyOriginatorKeyFile>', text)
if re.search(r'<SignAssembly>\s*true', text, re.I) and key:
    path = os.path.join(here, key.group(1).replace("\\", "/"))
    if os.path.isfile(path):
        print("KEY:" + path)
for name in re.findall(r'<Reference Include="(System[^",]*)', text):
    print("FW:" + name)
for hint in re.findall(r'<HintPath>([^<]+)</HintPath>', text):
    path = os.path.normpath(os.path.join(here, hint.replace("\\", "/")))
    if "Microsoft.Xna" not in path and os.path.isfile(path):
        print("HINT:" + path)
PYEOF
)
    for b in "${built[@]}"; do extra+=("-r:$b"); done
    # Against .NET Framework 4.0's reference assemblies, as Visual Studio 2010 compiled them: mono's
    # own mscorlib offers newer overloads (String.Split(char, StringSplitOptions)) that bind and
    # then do not exist when XNA's pipeline runs the extension under .NET 4.0.
    mcs -nologo -target:library -nostdlib -out:"$runner/$name.dll" -r:"$api/mscorlib.dll" -r:"$api/System.dll" \
        -r:"$api/System.Core.dll" -r:"$api/System.Xml.dll" -r:"$api/System.Xml.Linq.dll" \
        "${xna_refs[@]}" "${extra[@]}" "${sources[@]}"
    built+=("$runner/$name.dll")
    pipeline+=("$(win "$runner/$name.dll")")
    echo "extension: $name ($((${#sources[@]})) sources)"
done
# The content project's own references with a HintPath -- prebuilt pipeline extensions and the
# runtime libraries they need -- are pipeline assemblies too, as MSBuild handed them over.
while IFS= read -r dll; do
    [ -n "$dll" ] || continue
    cp -u "$dll" "$runner/"
    pipeline+=("$(win "$runner/$(basename "$dll")")")
    echo "pipeline reference: $(basename "$dll")"
done < <(python3 - "$project" <<'PYEOF'
import os, re, sys
project = sys.argv[1]
text = open(project, encoding="utf-8-sig").read()
seen = set()
for hint in re.findall(r'<Reference Include="[^"]*">\s*<HintPath>([^<]+)</HintPath>', text):
    path = os.path.normpath(os.path.join(os.path.dirname(project), hint.replace("\\", "/")))
    # Game Studio's own assemblies under C:\Program Files are the ones this script supplies; and of
    # two references with one name (NePlus names its Windows and Xbox 360 builds alike) the first
    # loaded is the one the pipeline used.
    if os.path.isfile(path) and os.path.basename(path).lower() not in seen:
        seen.add(os.path.basename(path).lower())
        print(path)
PYEOF
)
for dll in TextureImporter EffectImporter FBXImporter XImporter AudioImporters VideoImporters; do
    pipeline+=("$(win "$runner/Microsoft.Xna.Framework.Content.Pipeline.$dll.dll")")
done

display=":${CNA_XNA_CONTENT_DISPLAY:-119}"
Xvfb "$display" -screen 0 1280x1024x24 +extension GLX >/dev/null 2>&1 &
xvfb_pid=$!
trap 'kill "$xvfb_pid" 2>/dev/null || true' EXIT
for _ in $(seq 1 100); do DISPLAY="$display" xdpyinfo >/dev/null 2>&1 && break; sleep 0.1; done

# After the display exists and under it: the first Wine process of a session starts the session's
# desktop, and a desktop started without a display leaves the pipeline's D3D device no window.
# Fonts, registered by family name the way a font installer leaves them.
for font in "$gs"/Fonts/*.[tT][tT][fF] "${fonts[@]}"; do
    file="$(basename "$font")"
    target="$wine_prefix/drive_c/windows/Fonts/$file"
    [ -f "$target" ] || cp "$font" "$target"
    family="$(fc-scan --format '%{fullname[0]}' "$font" 2>/dev/null || true)"
    [ -n "$family" ] || continue
    if ! grep -qF "\"$family (TrueType)\"" "$wine_prefix/system.reg"; then
        env -u WAYLAND_DISPLAY DISPLAY="$display" WINEPREFIX="$wine_prefix" WINEDEBUG=-all wine reg add \
            'HKLM\Software\Microsoft\Windows NT\CurrentVersion\Fonts' \
            /v "$family (TrueType)" /t REG_SZ /d "$file" /f >/dev/null 2>&1 || true
    fi
done


# From the content project's directory, as MSBuild runs it: custom processors open their own
# files by relative path (TIE Fighter Forever's opens Shaders\MothershipEffect1.fx).
cd "$(dirname "$project")"
status=0
env -u WAYLAND_DISPLAY -u DBUS_SESSION_BUS_ADDRESS DISPLAY="$display" WINEPREFIX="$wine_prefix" \
    WINEDLLOVERRIDES=d3d9=b WINEDEBUG=-all \
    wine "$(win "$runner/XnaContentBuilder.exe")" "$(win "$project")" "$(win "$out")" "$(win "$obj")" \
    "$platform" "$profile" "$compress" "${pipeline[@]}" | tee "$obj/build.log" || status=$?

if $standins; then
    sed -n 's/^skipped song: \(.*\) as \([^\r]*\)\r\{0,1\}$/\1\t\2/p' "$obj/build.log" | while IFS=$'\t' read -r source name; do
        source="${source//\\//}"
        "$here/scripts/song-standin.sh" "$(dirname "$project")/$source" "$out/$(dirname "$source")" "$name"
    done
fi
if $video_standins; then
    sed -n 's/^skipped video: \(.*\) as \([^\r]*\)\r\{0,1\}$/\1\t\2/p' "$obj/build.log" | while IFS=$'\t' read -r source name; do
        source="${source//\\//}"
        "$here/scripts/video-standin.sh" "$(dirname "$project")/$source" "$out/$(dirname "$source")" "$name"
    done
fi

# Plain files the content project copies beside the built content (MSBuild's part, not BuildContent's):
# None and Content items alike, as MSBuild copies either when CopyToOutputDirectory says so.
python3 - "$project" "$out" <<'PYEOF'
import os, re, shutil, sys
project, out = sys.argv[1], sys.argv[2]
text = open(project, encoding="utf-8-sig").read()
for kind, inc, body in re.findall(r'<(None|Content) Include="([^"]+)">(.*?)</\1>', text, re.S):
    if re.search(r'<CopyToOutputDirectory>(PreserveNewest|Always)</CopyToOutputDirectory>', body):
        rel = inc.replace("\\", "/")
        os.makedirs(os.path.join(out, os.path.dirname(rel)), exist_ok=True)
        shutil.copy2(os.path.join(os.path.dirname(project), rel), os.path.join(out, rel))
        print("copied: " + rel)
PYEOF

# The XACT projects, with the tool XNA's XACT importer runs, into the folder BuildContent would use.
tools="$gs/Program Files/Microsoft XNA/XNA Game Studio/v4.0/Tools"
cp -u "$tools/XactBld3.exe" "$tools/XactEngineA3_6.dll" "$tools/XactInterop3.dll" "$runner/"
python3 - "$project" <<'PYEOF' | while IFS= read -r xap; do
import re, sys
for inc in re.findall(r'<Compile Include="([^"]+\.xap)"', open(sys.argv[1], encoding="utf-8-sig").read(), re.I):
    print(inc.replace("\\", "/"))
PYEOF
    mkdir -p "$out/$(dirname "$xap")"
    # A wave named by its author's absolute path (C:\csdev\...\x.wav) was found there on the
    # author's machine. The same file beside the project is linked at that path in the XNA prefix,
    # so the project builds as written.
    python3 - "$(dirname "$project")/$xap" "$wine_prefix" <<'PYEOF'
import os, re, sys
xap, prefix = sys.argv[1], sys.argv[2]
for drive, rest in re.findall(r'^\s*File = ([A-Za-z]):\\(.+\.wav);', open(xap, encoding="utf-8-sig", errors="replace").read(), re.M):
    target = os.path.join(prefix, "drive_" + drive.lower(), *rest.split("\\"))
    name = rest.split("\\")[-1]
    # Found without regard to case, as Windows found it (step2soft.wav names step2Soft.wav).
    local = next((os.path.join(os.path.dirname(xap), f) for f in os.listdir(os.path.dirname(xap) or ".")
                  if f.lower() == name.lower()), "")
    if not os.path.lexists(target) and os.path.isfile(local):
        os.makedirs(os.path.dirname(target), exist_ok=True)
        os.symlink(os.path.abspath(local), target)
        print("xact wave at its author's path: " + drive + ":\\" + rest)
PYEOF
    env -u WAYLAND_DISPLAY DISPLAY="$display" WINEPREFIX="$wine_prefix" WINEDEBUG=-all \
        wine "$(win "$runner/XactBld3.exe")" /F /WINDOWS /X:HEADER /X:CUELIST /X:REPORT \
        "$(win "$(dirname "$project")/$xap")" "$(win "$out/$(dirname "$xap")")"
    echo "xact: $xap"
done
# BuildContent stops at its first failed asset, so a nonzero status means the content is incomplete.
exit "$status"
