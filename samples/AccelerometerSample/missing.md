# AccelerometerSample audit — CSSAMPLE-084 ✅

## Result

**Runs, as the phone game it is, pixel-identical to the original.** The original C# is checked in
verbatim and builds in its only upstream configuration, the phone one (`TRACE;WINDOWS_PHONE`), in
Debug and Release. Its first frame is **0 differing pixels of 384 000** against both the original XNA
game's emulator frame and the C++ port's own start frame from `../cna-samples` (`SAMPLE-084`
evidence); holding Right moves the asteroid right until it is clamped at the edge.

As for `CSSAMPLE-016` Bounce, the phone supplied two things that are supplied here, neither in the
sample's source:

- **Its entry point.** The XAP host constructed the game; `Program.Main` is guarded
  `#if WINDOWS || XBOX`. The project names the game class
  (`<CnaPhoneGame>AccelerometerSample.Game</CnaPhoneGame>`) and `samples/Directory.Build.targets`
  generates the stand-in host. The guarded `Main` itself constructs a `Game1` that does not exist;
  it was never compiled upstream either.
- **The Windows Phone device APIs.** `Accelerometer.cs` and `Game.cs` reach `Microsoft.Devices`
  outside their guards. `<CnaPhoneCompat>true</CnaPhoneCompat>` references CNA.PhoneCompat; on the
  desktop `DeviceType` is `Emulator`, so the sample's own emulator path reads the arrow keys.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/AccelerometerSample_4_0` |
| Solution | `Accelerometer (Phone).sln` — the only one upstream ships |
| Project | `Accelerometer/Accelerometer/Accelerometer.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, `XnaPlatform=Windows Phone`, `XnaProfile=Reach` |
| Original `DefineConstants` | `TRACE;WINDOWS_PHONE` |
| Entry point | generated host constructing `AccelerometerSample.Game` |
| Assembly name | `Accelerometer` |
| Content | `asteroid.xnb`, `space.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean. The snapshot's own `bin/` and
`obj/` (Visual Studio output, including a generated `AssemblyAttributes.cs`) are not sources and are
not checked in; `scripts/check-verbatim.sh` now excludes them on both sides.

```text
1de4601900c15c71654d98d4846a04005de747732574f823ad8c55431a28f9fc  Accelerometer/Accelerometer.cs
a700296ddd33143b3c6b915c02a47878adfbfcef6068d58b51874f7d9bf7db83  Accelerometer/Accelerometer.csproj
268420b30b9a4d9355f6e676e3be167e57cc86a8d89a29f1f00f3ff99496e3d7  Accelerometer/Background.png
435695c839af94fedaa27cba21e472f23cc9b5fe94d8e00f9bd27e0556301103  Accelerometer/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Accelerometer/Game.ico
167da4021ad23021d3fe490902df8a9b7b40b74a8e3ecfc879e80344922dd62b  Accelerometer/GameThumbnail.png
cef0c8968c023747940b5418d87185cb3b869a9ab346e44b43eb8dbffc9a998b  Accelerometer.htm
3a49a7757af232c5131b193a8adbbc2ade26c5236231f4a6ecef8d4b4b5dff8a  Accelerometer/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Accelerometer/Properties/AppManifest.xml
8605aea18e3dc6d7186b272c63265758bad6dd4756b370e30089a7b9c6d211de  Accelerometer/Properties/AssemblyInfo.cs
f3b5277426c063b3dcf3042dbb5dc3207adf4df90daa10bb327052cfd9a941e0  Accelerometer/Properties/WMAppManifest.xml
```

## Build warnings

One, in both configurations, from the original source against the phone API it targets:
`Accelerometer.cs(59,21): warning CS0618: 'Accelerometer.ReadingChanged' is obsolete` — as Bounce.

## What was verified

- Sources verbatim (`scripts/check-verbatim.sh`), content identical (`scripts/check-content.sh`).
- Debug and Release build with that one warning; runs against CNA.NET `8fcd961`, CNA `80572aa00`
  (`build-probe`, Release OPENGLES3 with compiled effects) on a private Xvfb in a 480x800 window
  titled `Accelerometer`.
- First frame 0 px from `xna-original-emulator/01-start.png` and `cna-native-opengles3-release/01-start.png`
  in `/rv/tmp/samples/SAMPLE-084-AccelerometerSample_4_0/evidence/`.
- `capture-sample.sh --xdotool 'keydown Right sleep 1 keyup Right'`: the asteroid moves right and
  stops at the clamped edge.
- `requalify.sh` measures 4.40% against today's capture of the retained C++ binary; that capture is
  drawn offset by the 100-pixel window position, as every retained C++ phone port is (see Bounce).

## Not verified

- No exit key: the sample exits only on `GamePad` Back, which a desktop does not have; the capture
  closes the window. On Android the Back button reaches it (CNA `CBIND-137`).
- No real accelerometer: the `Device` branch needs `DeviceType.Device`, which a desktop never reports.

## Artifacts

```text
/rv/tmp/cs-samples/cssample-084/AccelerometerSample/         C# capture, run and build logs
/rv/tmp/cs-samples/cssample-084/AccelerometerSample/cpp/     the C++ port through the same route
/rv/tmp/cs-samples/cssample-084/AccelerometerSample-right/   after holding Right
```
