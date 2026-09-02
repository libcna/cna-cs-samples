# ContentManifestExtensions audit — CSSAMPLE-092

## Result

**The original C# runs unmodified and renders pixel-for-pixel identically to the C++ port** —
0 differing pixels of 384 000, with the static-scene control to back it. No `../cna-cs` change was
needed.

The row's point is `Content.Load<List<string>>("manifest")`, and it works: the window lists all nine
content items and all five copied files, read from the manifest rather than hard-coded.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ContentManifestExtensions_4_0` |
| Solution | `ContentManifestExtensions (Windows).sln` |
| Project | `SampleGame/SampleGame/SampleGame (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, **HiDef** |
| Original `DefineConstants` | `TRACE;WINDOWS` (Release), `DEBUG;TRACE;WINDOWS` (Debug) |
| Entry point | `SampleGame.Program.Main` in `Program.cs` |
| Assembly name | `SampleGame` |
| Content | 15 files — 10 `.xnb` plus 5 copied files |

## The second upstream project is design-time and is not built

`ContentManifestExtensions/ContentManifestExtensions.csproj` is an `OutputType=Library` Content
Pipeline importer/processor: it is what *produces* `manifest.xnb` at content-build time. It is not
part of the running game, this repository does not run the pipeline, and `../cna-samples` reached
the same boundary under the owner's `SAMPLES-DEC-002` ruling — its `SAMPLE-092` row audits the
assembly rather than claiming it as a port.

So this row builds the runnable `SampleGame` only, and consumes the manifest that assembly already
produced. The design-time project is not checked in.

## Source deviations

**None** in the game project. `diff -r` against `SampleGame/SampleGame` is clean.

```text
276007cef177175d85b56bb0eda9c5a6b24eaddaf1921f076ed502e874940505  ContentManifestExtensions.htm
4eb7659a26c4cdca1d056626fdc0a8c9f8a6425dda56368bfe99c223778696f7  SampleGame/Background.png
2367af3625fad5ed1553b9c7aa58670e70f04de1f84c13a9b08b61a85014f0d0  SampleGame/Game1.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  SampleGame/Game.ico
2f416a60d631aa29afe3152e008629b461826ce15a8d54bf21770daaeaafceab  SampleGame/GameThumbnail.png
4401bc06128bbb93136150b0d39cd16153978b16d6d9a10203aa1f406e02dbdc  SampleGame/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  SampleGame/Properties/AppManifest.xml
74e27650659655d34f9d449e779b94578031ee81566cf9de1b21605f9ab002d5  SampleGame/Properties/AssemblyInfo.cs
e0375a51bc3e5aa64dc1b9c371d5a6feb5e483e130b99ab0904ad79f675d7578  SampleGame/Properties/WMAppManifest.xml
bba5555c49421e222ee71a830d8560712bc259f1f007a25e355f2ff9eac8be56  SampleGame/SampleGame (Phone).csproj
62306d42cb7304bd5242acaed513aca6914216c32a0c16cd7610efb18f168f04  SampleGame/SampleGame (Windows).csproj
```

## Content provenance — five files that are not `.xnb`, correctly

`scripts/inspect-upstream.sh` warns when a C++ port ships non-`.xnb` assets, because `CSSAMPLE-002`
showed that can mean a CNA-native substitute. **Here it does not**, and the distinction matters.

The content tree copied from `../cna-samples/samples/ContentManifestExtensions/Content/` holds:

- **10 `.xnb`** — `Characters/{Bear,Cardinal,Dog,Duck}`, `clock`, `flashlight`, `heart`,
  `heart_grey`, `Font`, `manifest`;
- **5 copied files** — `Characters/Duck.png` and `CopiedFile{1,2,3,4}.txt`.

Those five are the content project's own **copy** build action, not compiled assets, and the sample
exists to demonstrate exactly that: the manifest distinguishes built content from copied files and
the game prints the two lists separately. Dropping them would delete half of what the sample shows.
`../cna-samples`' row records them as "the five exact copied files".

## Native verification

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window, exiting 0 on Escape.
The frame reads:

```text
CONTENT:                        COPIED FILES:
  Characters\Bear                 Content\Characters\Duck.png
  Characters\Cardinal             Content\CopiedFile1.txt
  Characters\Dog                  Content\CopiedFile2.txt
  Characters\Duck                 Content\CopiedFile3.txt
  clock                           Content\CopiedFile4.txt
  flashlight
  heart
  heart_grey
  Font
```

That is the manifest's own content, so `Content.Load<List<string>>` returned all fourteen entries
and the `SpriteFont` rendered them. `../cna-samples` needed a CNA fix (`e5ae0820e`) to register
XNA's standard `ListReader<string>` pair; whatever that established is reachable through this
binding unchanged.

## Comparison with the C++ port

| comparison | differing pixels |
|---|---:|
| C# on CNA.NET vs the C++ port | **0** of 384 000 |
| C# settle 5 s vs settle 9 s | 0 |

Four distinct colours in both. The second row establishes the scene is static, so the first is
frame-independent rather than a lucky capture — the control `CSSAMPLE-008` made routine.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The design-time assembly.** Audited as a boundary, not built; see above.
- **`XnaProfile=HiDef`.** As with `CSSAMPLE-008`, the original embeds a runtime-profile resource
  with no .NET 8 equivalent and the game never sets `GraphicsProfile` in code, so this build does
  not request HiDef. It plainly does not need it.

## Artifacts

```text
/rv/tmp/cs-samples/CSSAMPLE-092-ContentManifestExtensions/evidence/
├── release/          window capture, run log, window geometry, sha256
├── settle9/          the static-scene control
└── cpp-reference.png the C++ port through the same route
```
