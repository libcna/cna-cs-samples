# SpriteSheet audit — CSSAMPLE-007

## Result

**The original C# runs unmodified.** No `../cna-cs` change was needed. The sample's custom content
reader — the point of the row — resolves and loads.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SpriteSheetSample_4_0` |
| Projects | `SpriteSheetSample/SpriteSheetSample/SpriteSheetSample (Windows).csproj` **and** `SpriteSheetRuntime/SpriteSheetRuntime (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows |
| Entry point | `SpriteSheetSampleWindowsPhone.Program.Main` |
| Assembly names | `SpriteSheetSample` and `SpriteSheetRuntime` |
| Content | `Checker.xnb`, `hudFont.xnb`, `SpriteSheet.xnb` |

The namespace really is `SpriteSheetSampleWindowsPhone` in the Windows project too — upstream's,
preserved rather than corrected.

Upstream's third project, `SpriteSheetPipeline`, is a Content Pipeline extension: design-time only,
not part of the running game, not built here. Same boundary as `CSSAMPLE-092` and `CSSAMPLE-078`.

## Why the runtime library stays a separate assembly

`SpriteSheet.xnb` was produced by `SpriteSheetPipeline` and names its reader by **assembly-qualified
type name**, so the assembly must be called `SpriteSheetRuntime` or the content cannot resolve.
Folding the two source trees into one assembly would have compiled and then failed at load.

That it runs and exits 0 is the evidence the mechanism works: the sample's whole subject is a custom
content type read through a reader in a second assembly.

Both projects set `EnableDefaultCompileItems=false` and list their own tree, because the two upstream
source trees live side by side under one directory.

## Source deviations

**None.** `diff -r` against both upstream project directories is clean.

```text
7676a64ea65aac48577d1b0896cb0a4d92df979e6f3d67ab5db5f1ea6d69ce28  SpriteSheet.htm
49e439dc1728066735ba463b22eaaf01c2c338a021a4473f39097be84ea77c63  SpriteSheetRuntime/Properties/AssemblyInfo.cs
122b1055973909da72507b2edac26e551d9bddf940a6615489a6f883f7690bef  SpriteSheetRuntime/SpriteSheet.cs
16f790d46f4501b974af72b92ff9703b73d1024fe597298f1cfc746a759997b2  SpriteSheetSample/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  SpriteSheetSample/Game.ico
fd810c8a5463be4df6b3b8dc17b5ac93c63dafeb70e5093bfc8990988bfaa27c  SpriteSheetSample/GameThumbnail.png
2326c5ab83e4559c390f4b457524949edb838839d4a7af83cd488139d1a804c2  SpriteSheetSample/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  SpriteSheetSample/Properties/AppManifest.xml
c01801e60f9f0e8bfe0e1301390ebb66f4b07fc815d2d19509cf2072a2df13e2  SpriteSheetSample/Properties/AssemblyInfo.cs
920247abcacbd612cdcc4326959dc0b1c65ecaea0a110967fd716cd7b7374c28  SpriteSheetSample/Properties/WMAppManifest.xml
f20506b2d941279f296030167c3d1fddb464a8b2898f8d39764778d174697e2f  SpriteSheetSample/SpriteSheetGame.cs
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 853x480 window titled
`SpriteSheetSample`, exiting 0 on Escape. 8 876 distinct colours.

Against the C++ port: 32 763 differing pixels of 384 000 — and the control says that is animation.
Two runs of **this** build at settles of 5 s and 9 s differ by **35 974**, more than the cross-engine
pair does. The sample animates its sprites from `gameTime`, so a single frame is not comparable
between runs.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The sprite-sheet animation over time.** Only a single frame was compared.

## Artifacts

`/rv/tmp/cs-samples/SpriteSheet/evidence/` — `release/`, `settle9/` and `cpp-reference.png`.
