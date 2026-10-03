#!/usr/bin/env bash
# Builds one sample as an Android app and runs it in a headless emulator.
#
# Usage: scripts/android-sample.sh <SampleDirectory> [--out DIR] [--seconds N] [--avd NAME] [--keep-emulator]
#                                  [--then 'DEVICE SHELL COMMAND'] [--keep-app]
#
# Like browser-sample.sh, the sample's own project is untouched: its evaluated identity, Compile
# items and library projects are read from MSBuild, and a net11.0-android app is generated under
# build-consumer/android/<Sample>/ with the same sources, Content as APK assets, and an activity that
# runs the sample's own Main on SDL's thread (../cna-cs/eng/android). The emulator runs with
# -no-window and a read-only AVD; one this script started is stopped at the end unless
# --keep-emulator. Screenshot and logcat land in DIR (default /rv/tmp/cs-samples/android/<Sample>).
# --then runs a command on the device after the screenshot (e.g. 'input keyevent KEYCODE_BACK')
# and reports whether the game's Main then returned. The app is uninstalled at the end unless
# --keep-app: the emulator's /data holds a few apps of this size, not a corpus of them.
#
# Needs ../cna-cs/scripts/Build-AndroidNative.sh to have staged the native libraries, the .NET 11 SDK
# with the android workload (default ~/deps/dotnet11) and the Android SDK (default ~/Android/Sdk).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cs_root="$(cd "$here/../cna-cs" && pwd)"
dotnet_root="${DOTNET_ROOT_ANDROID:-$HOME/deps/dotnet11}"
sdk="${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}"
sample=""; out=""; seconds=10; avd=Medium_Phone; keep=0; then=""; keep_app=0
while [ $# -gt 0 ]; do
    case "$1" in
        --out)           out="$2"; shift 2 ;;
        --seconds)       seconds="$2"; shift 2 ;;
        --avd)           avd="$2"; shift 2 ;;
        --keep-emulator) keep=1; shift ;;
        --then)          then="$2"; shift 2 ;;
        --keep-app)      keep_app=1; shift ;;
        -h|--help)       sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)              echo "error: unknown option $1" >&2; exit 2 ;;
        *)               sample="$1"; shift ;;
    esac
done
[ -n "$sample" ] || { echo "usage: $0 <SampleDirectory>" >&2; exit 2; }
# A gallery row is named by its directory under samples/; a real game by its path (games/<Game>).
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
out="${out:-/rv/tmp/cs-samples/android/$sample}"
mkdir -p "$out"
work="$here/build-consumer/android/$sample"
mkdir -p "$work"
adb="$sdk/platform-tools/adb"

# A game's sources are Compile items its CnaGameProjectSources target adds, so that target runs first.
targets=()
[ -n "$(DOTNET_CLI_TELEMETRY_OPTOUT=1 dotnet msbuild "$project" -getProperty:GameProject)" ] && targets=(-t:CnaGameProjectSources)
DOTNET_CLI_TELEMETRY_OPTOUT=1 dotnet msbuild "$project" "${targets[@]}" -getProperty:AssemblyName \
    -getProperty:RootNamespace -getProperty:StartupObject -getProperty:CnaSampleDefineConstants \
    -getProperty:XnaProfile -getProperty:XnaPlatform -getProperty:CnaPhoneGame \
    -getProperty:CnaPhoneCompat -getProperty:CnaWindowsFormsCompat -getProperty:CnaSampleConfiguration -getProperty:Deterministic \
    -getProperty:AllowUnsafeBlocks -getItem:Compile \
    -getItem:EmbeddedResource -getItem:ProjectReference -getItem:None -getItem:Content \
    -getItem:CnaWindowsPath -getItem:Reference -getItem:PackageReference >"$work/evaluation.json"

python3 - "$work" "$sample_dir" "$cs_root" <<'EOF'
import json, re, subprocess, sys
from pathlib import Path
from xml.sax.saxutils import escape, quoteattr

work, sample_dir, cs_root = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
evaluation = json.loads((work / "evaluation.json").read_text())
props, items = evaluation["Properties"], evaluation.get("Items", {})
# The Android SDK's MSBuild breaks on an assembly name holding an apostrophe (A Princess' Request:
# XAPSA7009), as the WebAssembly SDK does; such a game is built here without it.
if "'" in props["AssemblyName"]:
    print(f"android assembly name: {props['AssemblyName']!r} without its apostrophe", file=sys.stderr)
    props["AssemblyName"] = props["AssemblyName"].replace("'", "")
sample = work.name  # unique: a nested game is named by both its directories
package = "com.libcna.samples." + re.sub(r"[^a-z0-9]", "", sample.lower())

libraries = []
for item in items.get("ProjectReference", []):
    path = item["FullPath"]
    # The XNA-named forwarders a game referencing a library compiled against XNA needs are built
    # like the game's own libraries; the rest of CNA.NET is referenced below.
    if path.startswith(str(cs_root).rstrip("/") + "/") and "/src/XnaAssemblies/" not in path:
        continue
    subprocess.run(["dotnet", "build", path, "-c", "Release", "-m:1"], check=True, stdout=subprocess.DEVNULL)
    target = subprocess.run(["dotnet", "msbuild", path, "-p:Configuration=Release", "-getProperty:TargetPath"],
                            check=True, capture_output=True, text=True).stdout.strip()
    libraries.append(Path(target))

binaries = cs_root / "src/CNA.XnaCompat/bin/Release/net8.0"
references = [(name, binaries) for name in ("CNA.Interop", "CNA.Framework", "CNA.XnaCompat")]
if props.get("CnaPhoneCompat") == "true":
    references.append(("CNA.PhoneCompat", cs_root / "src/CNA.PhoneCompat/bin/Release/net8.0"))
if props.get("CnaWindowsFormsCompat") == "true":
    references.append(("CNA.WindowsFormsCompat", cs_root / "src/CNA.WindowsFormsCompat/bin/Release/net8.0"))

constants = props.get("CnaSampleDefineConstants") or "WINDOWS"
if props.get("CnaSampleConfiguration") == "Debug":
    constants += ";DEBUG"
lines = ['<Project Sdk="Microsoft.NET.Sdk">', "  <PropertyGroup>",
         "    <TargetFramework>net11.0-android</TargetFramework>",
         "    <SupportedOSPlatformVersion>24</SupportedOSPlatformVersion>",
         "    <OutputType>Exe</OutputType>",
         f"    <ApplicationId>{package}</ApplicationId>",
         f"    <ApplicationTitle>{escape(sample)}</ApplicationTitle>",
         f"    <AssemblyName>{escape(props['AssemblyName'])}</AssemblyName>",
         f"    <RootNamespace>{escape(props['RootNamespace'])}</RootNamespace>",
         "    <RuntimeIdentifier>android-x64</RuntimeIdentifier>",
         "    <ImplicitUsings>disable</ImplicitUsings>",
         "    <Nullable>disable</Nullable>",
         "    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>",
         # A game's code sees its own DefineConstants only, as XNA's build gave it: the SDK's own
         # ANDROID/BROWSER symbols switched on cocos2d-x for XNA's MonoGame-for-Android code.
         "    <DisableImplicitFrameworkDefines>true</DisableImplicitFrameworkDefines>",
         "    <EnableDefaultCompileItems>false</EnableDefaultCompileItems>",
         "    <EnableDefaultEmbeddedResourceItems>false</EnableDefaultEmbeddedResourceItems>",
         "    <TreatWarningsAsErrors>false</TreatWarningsAsErrors>",
         # The Android SDK generates a Resource class in the root namespace; a game may have one of
         # its own there (Speedy Blupi does). The generated one goes elsewhere.
         "    <AndroidResgenNamespace>CnaAndroidResources</AndroidResgenNamespace>",
         f"    <DefineConstants>$(DefineConstants);{escape(constants)}</DefineConstants>"]
# A 2010 project could version itself "3.5.0.*", which a deterministic build refuses (the games'
# own Directory.Build.props turns determinism off); and some compile unsafe code.
if props.get("Deterministic") == "false":
    lines.append("    <Deterministic>false</Deterministic>")
if props.get("AllowUnsafeBlocks") == "true":
    lines.append("    <AllowUnsafeBlocks>true</AllowUnsafeBlocks>")
if props.get("XnaProfile"):
    lines.append(f"    <XnaProfile>{escape(props['XnaProfile'])}</XnaProfile>")
if props.get("XnaPlatform"):
    lines.append(f"    <XnaPlatform>{escape(props['XnaPlatform'])}</XnaPlatform>")
# An Android app assembly is compiled as a library, so no StartupObject; the activity calls Main.
startup = props.get("StartupObject")
lines += ["  </PropertyGroup>", "  <ItemGroup>"]
for item in items.get("Compile", []):
    if "/obj/" not in item["FullPath"]:
        lines.append(f"    <Compile Include={quoteattr(item['FullPath'])} />")
for item in items.get("EmbeddedResource", []):
    logical = item.get("LogicalName", "")
    attr = f" LogicalName={quoteattr(logical)}" if logical else ""
    lines.append(f"    <EmbeddedResource Include={quoteattr(item['FullPath'])}{attr} />")
for name, folder in references:
    lines.append(f'    <Reference Include="{name}"><HintPath>{folder / (name + ".dll")}</HintPath></Reference>')
# NuGet packages the game's project glue adds (ConfigurationManager, CodeDom: .NET Framework's own
# assemblies, packages on .NET).
for item in items.get("PackageReference", []):
    if item.get("Version"):
        lines.append(f'    <PackageReference Include={quoteattr(item["Identity"])} Version={quoteattr(item["Version"])} />')
# A prebuilt library the game ships (BEPUphysics, DPSF, ...) is referenced where it lies.
for item in items.get("Reference", []):
    hint = item.get("HintPath", "")
    if hint:
        lines.append(f'    <Reference Include={quoteattr(item["Identity"])}><HintPath>{escape(hint)}</HintPath></Reference>')
        lines.append(f'    <TrimmerRootAssembly Include={quoteattr(Path(hint).stem)} />')
# A library's own prebuilt dependencies (XPF's Rx) are copied beside it by its build and referenced
# from there, once each; CNA.NET's assemblies and the XNA-named forwarders are referenced elsewhere.
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
lines.append(f'    <TrimmerRootAssembly Include="{escape(props["AssemblyName"])}" />')
content = sample_dir / "Content"
title_roots = ["Content"]
if content.is_dir():
    lines.append(f'    <AndroidAsset Include="{content}/**" Link="Assets/Content/%(RecursiveDir)%(Filename)%(Extension)" />')
# Every other file the build copies beside the game (Spacewar's settings.xml) is a title asset as
# well, extracted beside it on the device.
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
    if content.is_dir() and relative.startswith("Content/"):
        continue
    lines.append(f'    <AndroidAsset Include={quoteattr(item["FullPath"])} Link={quoteattr("Assets/" + relative)} />')
    if relative.split("/")[0] not in title_roots:
        title_roots.append(relative.split("/")[0])
lines += ["    <Compile Include=\"GameApplication.g.cs\" />", "  </ItemGroup>",
          f'  <Import Project="{cs_root}/src/CNA.XnaCompat/build/CNA.XnaCompat.targets" />',
          f'  <Import Project="{cs_root}/eng/android/CNA.Android.targets" />', "</Project>", ""]
(work / f"{sample}.Android.csproj").write_text("\n".join(lines))

# The phone's XAP host constructed a phone-only game; anything else runs its own Main.
if props.get("CnaPhoneGame"):
    body = f"using (var game = new global::{props['CnaPhoneGame']}()) {{ game.Run(); }}"
else:
    # Found by name: an entry point may be a private nested class (NetRumbleGame.Program), which
    # typeof() cannot name from here; each '.' from the right may be a nesting '+'.
    flags = ("System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public | "
             "System.Reflection.BindingFlags.NonPublic")
    if startup:
        find = (f"var name = {json.dumps(startup)}; System.Type type; "
                "while ((type = typeof(GameApplication).Assembly.GetType(name)) == null) { "
                "int dot = name.LastIndexOf('.'); name = name.Substring(0, dot) + \"+\" + name.Substring(dot + 1); } "
                f"var main = type.GetMethod(\"Main\", {flags}); ")
    else:
        # No StartupObject: the compiler found the one static Main; so does this.
        find = ("System.Reflection.MethodInfo main = null; "
                "foreach (var type in typeof(GameApplication).Assembly.GetTypes()) { "
                f"if (type != typeof(GameApplication) && (main = type.GetMethod(\"Main\", {flags})) != null) break; }} ")
    body = find + "main.Invoke(null, main.GetParameters().Length == 0 ? null : new object[] { new string[0] });"
# The Windows-spelled paths the game opens through the BCL (samples/Directory.Build.targets'
# CnaWindowsPath), linked beside the extracted title before its Main runs.
links = "".join(
    f"Link({json.dumps(item['Path'])}, {json.dumps(item['LinksTo'])}); "
    for item in items.get("CnaWindowsPath", []))
(work / "GameApplication.g.cs").write_text(f'''// Generated by scripts/android-sample.sh.
[Android.App.Application]
public class GameApplication : CNA.Android.CnaGameApplication
{{
    public GameApplication(System.IntPtr handle, Android.Runtime.JniHandleOwnership transfer) : base(handle, transfer) {{ }}

    protected override System.Collections.Generic.IEnumerable<string> TitleAssetDirectories => new[] {{ {", ".join(json.dumps(r) for r in title_roots)} }};

    protected override void RunGame() {{ {links}{body} }}

    private static void Link(string path, string target)
    {{
        string link = System.IO.Path.Combine(System.AppContext.BaseDirectory, path);
        if (!System.IO.File.Exists(link) && !System.IO.Directory.Exists(link))
            System.IO.File.CreateSymbolicLink(link, target);
    }}
}}
''')
# SDL's activity, unchanged, is the launcher, declared as SDL's own project declares it: no fixed
# orientation (SDL sets it from the game's back buffer and SupportedOrientations) and its theme (no
# title bar drawn over the game). GLES 3 is what the OPENGLES3 renderer needs.
(work / "AndroidManifest.xml").write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <uses-feature android:glEsVersion="0x00030000" android:required="true" />
  <application android:label="{escape(sample)}" android:hardwareAccelerated="true"
               android:theme="@android:style/Theme.NoTitleBar.Fullscreen">
    <activity android:name="com.libcna.cna.CnaGameActivity" android:exported="true"
              android:launchMode="singleTop" android:alwaysRetainTaskState="true"
              android:configChanges="layoutDirection|locale|grammaticalGender|fontScale|fontWeightAdjustment|orientation|uiMode|screenLayout|screenSize|smallestScreenSize|keyboard|keyboardHidden|navigation">
      <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
      </intent-filter>
    </activity>
  </application>
</manifest>
''')
(work / "package.txt").write_text(package)
EOF
package="$(cat "$work/package.txt")"

export DOTNET_ROOT="$dotnet_root" DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1 ANDROID_HOME="$sdk"
rm -rf "$work/bin" "$work/obj"
if ! "$dotnet_root/dotnet" build "$work/$sample.Android.csproj" -c Release \
        -p:AndroidSdkDirectory="$sdk" -p:AndroidPackageFormat=apk >"$out/build.log" 2>&1; then
    grep -E " error " "$out/build.log" | sort -u | head -20 >&2
    echo "error: the Android build failed; see $out/build.log" >&2
    exit 1
fi
apk="$(ls "$work"/bin/Release/net11.0-android/android-x64/*-Signed.apk | head -1)"

started=0
if ! "$adb" devices | grep -q '^emulator-[0-9]*[[:space:]]*device$'; then
    # -read-only keeps the AVD untouched, so -wipe-data only gives this instance an empty /data:
    # the AVD's own userdata leaves less free space than Android's install threshold.
    env -u DISPLAY -u WAYLAND_DISPLAY "$sdk/emulator/emulator" -avd "$avd" -no-window -no-audio \
        -no-boot-anim -read-only -wipe-data -gpu "${CNA_ANDROID_GPU:-swiftshader_indirect}" \
        >"$out/emulator.log" 2>&1 &
    started=1
fi
"$adb" wait-for-device
until [ "$("$adb" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = 1 ]; do sleep 2; done
# A wiped device explains immersive full screen the first time a game asks for it, in a dialog that
# takes the Back key; a phone game (IsFullScreen) would then never see it.
"$adb" shell settings put secure immersive_mode_confirmations confirmed >/dev/null 2>&1 || true
cleanup() { [ "$started" = 1 ] && [ "$keep" = 0 ] && "$adb" emu kill >/dev/null 2>&1 || true; }
trap cleanup EXIT

# A fresh install each run: no state left by an earlier one, and the emulator's small /data does not
# have to hold two copies of the app while it is replaced.
"$adb" uninstall "$package" >/dev/null 2>&1 || true
"$adb" install --no-incremental "$apk" >"$out/install.log" 2>&1 || { tail -3 "$out/install.log" >&2; exit 1; }
"$adb" logcat -c
"$adb" shell am start -W -n "$package/com.libcna.cna.CnaGameActivity" >"$out/start.log" 2>&1
sleep "$seconds"
"$adb" exec-out screencap -p >"$out/$sample.png"
if [ -n "$then" ]; then
    "$adb" shell "$then"
    sleep 3
fi
"$adb" logcat -d >"$out/logcat.txt"
"$adb" shell am force-stop "$package"
[ "$keep_app" = 1 ] || "$adb" uninstall "$package" >/dev/null 2>&1 || true
# monodroid warns for every P/Invoke into the library CNA.Interop's resolver loads; that is noise.
grep -E " (CNA|SDL|DOTNET|MonoDroid|monodroid|AndroidRuntime)" "$out/logcat.txt" | grep -v "not loaded, p/invoke" \
    | grep -iE "error|exception|fatal|CNA" | tail -20 || true
echo "capture  : $out/$sample.png"
if [ -n "$then" ]; then
    if grep -q "SDL *: Finished main function" "$out/logcat.txt"; then echo "run ended: yes"; else echo "run ended: no"; fi
fi
