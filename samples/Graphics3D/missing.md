# Graphics3D audit — CSSAMPLE-046 ✅

## Result

**Runs, as the phone game it is, matching the original.** Upstream ships only the phone project; its sources are checked in verbatim and build in Debug and Release. The first frame is **35 px of 384 000** from the original XNA game's 800×480 frame and **1 px** from the C++ port's start frame (`SAMPLE-046` evidence). `Buttons/Button.cs` is upstream's but outside its project's Compile list and does not compile against the rest; `Graphics3D.csproj` leaves it out as the original project did. The retained C++ phone binary asks for full screen, which a bare Xvfb cannot grant (SDL: "no window becoming fullscreen"), so its requalify capture is black; the comparison is against the C++ campaign's own start frame instead.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/Graphics3DSample_4_0` |
| Project | `Sample3DGraphics/Sample3DGraphics/Graphics3DSample.csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `Graphics3DSample.Graphics3DSampleGame` (the guarded `Main` names a `Sample3DGraphics` class that does not exist) |
| Assembly name | `Graphics3DSample` |
| Content | the UFO models, textures and button art, and `AnimationDef.xml`, a raw file the content project copies to the output — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
b78decfd9215de8b152ea5b6dd25c377ece6f294790ca02fe14e2324d4ef6efb  3DGraphics.htm
b379165ccbe6e46644a2416b1cc12d79e7609ab5d170b367f3d11ead494d4380  Sample3DGraphics/Animation/Animation.cs
290f07af59090abf8c87504948d9d463c1aa02ffe6793ab96f71774ee7009651  Sample3DGraphics/Background.png
d8399f9655c58d0202b784296ba4d0c0f138b516a73ba5954987e4bdd14a34aa  Sample3DGraphics/Buttons/Button.cs
49ceba4abf74e6a27560cc0880895694cd10e44e9345caa88ca568a4e53ae29b  Sample3DGraphics/Buttons/Checkbox.cs
11e0ea0a1f8eb300a5c8006a81a9a858bcb6306f2ba07f7f04924cf3446ff66a  Sample3DGraphics/Buttons/Clickable.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Sample3DGraphics/Game.ico
28b62ab4bb9618a186e0bbe78090566ec02744402aeb9ff872f6728ffba70669  Sample3DGraphics/GameMain.cs
10eb209d55d7dd0a3eb2607dec6ec7fc4112cd9d979e6332f39dabee268b9b34  Sample3DGraphics/GameThumbnail.png
84e8aef26fb7081455fa6e7a78e0ae3d01cb3eb14c67b56e397883605fbf7bc3  Sample3DGraphics/Graphics3DSample.csproj
aff23241a38b50d3a5711ea76a2262af50c9e15c4027580aa42426b3f595b7c2  Sample3DGraphics/Models/Spaceship.cs
a1d0e80426580ef4ae5cff66536f7f6594196c741f8b688893e6a0dcb03d3d0c  Sample3DGraphics/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Sample3DGraphics/Properties/AppManifest.xml
191401bb904ae53f71a69931d21522a1edfafc29f3be88c5eb7951c8d29eba7c  Sample3DGraphics/Properties/AssemblyInfo.cs
b20ca17a4e3240bc9b5beb0f3af4bb9aa14dd9343c7481ef02f6c5e71fdabe8b  Sample3DGraphics/Properties/WMAppManifest.xml
```

## What was verified

The first frame at 2% fuzz against `xna-original-800x480/g3d-xna-1-start.png` and `cna-native-opengles3/g3d-cna-1-start.png` under `/rv/tmp/samples/SAMPLE-046-Graphics3DSample_4_0/evidence/`. Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/Graphics3D/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
