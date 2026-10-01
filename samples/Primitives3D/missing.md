# Primitives3D audit — CSSAMPLE-002 ✅

## Result

**The original C# runs unmodified with the official compiled font, and its HUD is pixel-identical
to the C++ port's.** Both configurations build with no warnings; the sample renders the shaded cube
and the three-line HUD and exits 0 on Escape.

The row was `🛠` from 2026-09-02 until 2026-10-01 for its font alone: the `hudfont.xnb` it carried
had been script-synthesized, not built by XNA's pipeline (`../cna-samples` `2782faa`). The C++
campaign closed that on 2026-09-06 by running the unchanged content project through XNA 4.0's own
`BuildContent` for Windows/Reach; its port ships the product, `hudFont.xnb`, and so does this row
now, byte-identical (`scripts/check-content.sh`: 319 identical, nothing sourced elsewhere).

The source asks for `"hudfont"` and the pipeline names the file `hudFont.xnb`, as XNA does on a
case-insensitive Windows file system; CNA's loader resolves it the same way. One trap on the way:
the old `hudfont.xnb` stayed in `bin/*/Content/` after the swap, and an exact-case match beats a
case-insensitive one, so the first capture still drew the synthesized font (smaller glyphs, 14-px
line pitch). With the stale output removed the HUD is **0 differing pixels of 26 400** against the
C++ port; the whole frame differs by 14.53%, the cube's rotation.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/Primitives3DSample_4_0` |
| Solution | `Primitives3D (Windows).sln` |
| Project | `Primitives3D/Primitives3DWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Original `DefineConstants` | `TRACE;WINDOWS` (Release), `DEBUG;TRACE;WINDOWS` (Debug) |
| Entry point | `Primitives3D.Program.Main` — a separate `Program` class in `Primitives3DGame.cs`, not the game class |
| Assembly name | `Primitives3D` |
| Content | `hudFont.xnb` — official pipeline output, identical to `../cna-samples` |

The Phone solution is a platform variant and is not this row's target; its two `#if WINDOWS_PHONE`
branches are present in the checked-in source unchanged.

## Content provenance

```text
../cna-samples/samples/Primitives3D/Content/hudFont.xnb
sha256 d944c80be4eb2bd3a4e8cb53945406401e59674f1a6d4a5261ff05513f5a59a7   13 486 bytes
```

The same file as `xna4-original/Primitives3D/bin/x86/Release/Content/hudFont.xnb` and
`xna4-build/Content-windows/hudFont.xnb` in `/rv/tmp/samples/SAMPLE-002-Primitives3DSample_4_0/`:
an `XNBw` container with a 128x64 DXT3 sheet, 95 glyphs and `LineSpacing = 18`. The superseded
synthesized file (`f9ec42ce…`, 70 830 bytes) is kept there as
`evidence/hudfont-synthesized-superseded.xnb`.

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
5a2a4bcf04fc8b38b3c5d0f3265d8c4ef97bff7294d312c0d01c78c505898dce  Primitives3D/App.config
e9a9c3cf5e93a847424a4488427e3bca8a80933f3b3bc7f6334a5a8d0f770718  Primitives3D/BezierPrimitive.cs
dfcd98c66244fb7936ee1c4eedfe4b93df4ecd768404d48866eee5414ce89330  Primitives3D/CubePrimitive.cs
a96b46ea7742c718d6f7ab3eab6cf88a510a2568f60ec7fcd6218d57db141e86  Primitives3D/CylinderPrimitive.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Primitives3D/Game.ico
67b88fbec96fc7301aaf4c468f39fcf33e65e384b1856f7dee78609bb961b35f  Primitives3D/GameThumbnail.png
42be1aa3308a2783e4f3e69dac428c734a50cbc0e76df7ca462cf61bb357c205  Primitives3D/GeometricPrimitive.cs
8212d62e3dd13312914f38172fd4fdba351cb9017e0cb0e098f2822c65c8c173  Primitives3D.htm
936834e98279dde4acadf8561a46000f0394efb17b0489aac521d64cdf2fa375  Primitives3D/Primitives3DGame.cs
79bb5705acdb41bda48036cd5dc30baf30dc447483733c92a0dfaf6f0c94996a  Primitives3D/Primitives3DWindows.csproj
01dfabe953144da8e59a3f932027996cbca4810dc9ea5b1ebed45489e23cfda5  Primitives3D/Primitives3DWindowsPhone.csproj
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Primitives3D/Properties/AppManifest.xml
f8a4232a3110d66e8aa4ae818f1e8e7a37985c6a5303d3a0af8e9aec7c42d332  Primitives3D/Properties/AssemblyInfo.cs
aadae9cc923df629a4d23d2ac7e02ddbcd59010089016af34186c8575b5b3a92  Primitives3D/Properties/WindowsPhoneManifest.xml
d8426267a6aeea48673e092ba5bbf4104dd7aeeb891252ef178701de9b52da70  Primitives3D/SpherePrimitive.cs
9434072ef354ec0dbb58a20c1c4f7314d7fa0e7d602868f003f19e0d3a95bacd  Primitives3D/TeapotPrimitive.cs
bdf77d88ee57ee5496a114795ea644db9c4e32275ad7408d7378ded8c4e62bff  Primitives3D/TorusPrimitive.cs
fcc00bbcf02e1dbeba1f39945b73d552bb90ab18181daa94c8c5a8b37af69579  Primitives3D/VertexPositionNormal.cs
```

One project-file mistake is worth recording because the next sample can repeat it: `Main` lives in
a separate `static class Program` at the bottom of `Primitives3DGame.cs`, not in the game class.
Pointing `StartupObject` at `Primitives3D.Primitives3DGame` fails with
`CS1558: 'Primitives3DGame' does not have a suitable static 'Main' method`. **Read where `Main`
actually is; do not assume it is in the game class or in a `Program.cs`.**

## Native verification

Debug and Release both build with 0 warnings and 0 errors and run on `OPENGLES3` in an 800x480
window titled `Primitives3D`, exiting 0 on Escape. The frame shows the shaded red cube on
`CornflowerBlue` and the three-line HUD:

```text
A or tap top of screen = Change primitive
B or tap bottom left of screen = Change color
Y or tap bottom right of screen = Toggle wireframe
```

## Comparison with the C++ port

Captured through the same Xvfb/crop route (`scripts/requalify.sh`):

| region | result |
|---|---|
| HUD text, `(30,30)`–`(360,110)` | **0 differing pixels of 26 400** |
| whole frame | 14.53% (55 811 px), the cube |

## Not verified

- **Browser and Android with this font.** Both corpus runs of 2026-10-01 (NEXT.md) predate the
  font change and drew the synthesized font.
- **The other five primitives and the colour and wireframe modes.** The sample cycles cube, sphere,
  cylinder, torus, teapot and a Bezier shape with A/B/Y, and only the default cube was captured.
  Input-driven coverage needs the interaction harness the capture script does not yet have.
- **Gamepad.** Present in the source, no controller attached; Escape was exercised.

## Artifacts

`/rv/tmp/cs-samples/primitives3d-official-font-3/Primitives3D/` (C# capture and logs) and `.../cpp/`
(the C++ port through the same route); the stale-font capture is `primitives3d-official-font-2/`.
