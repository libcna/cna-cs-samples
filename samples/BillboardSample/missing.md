# BillboardSample audit — CSSAMPLE-039 ✅

## Result

**The original C# runs unmodified.** The Windows project's sources, verbatim, build in Debug and Release with no warnings and draw the landscape with its billboarded grass and trees through the compiled effect. Against the C++ port the frame differs by 4.72% (2% fuzz): the billboards sway with time.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/BillboardSample_4_0` |
| Project | `Billboard/BillboardWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `Billboard.Program` |
| Assembly name | `Billboard` |
| Content | the landscape (built by upstream's pipeline-only `BillboardPipeline`, which scatters the billboards) and its grass, tree and cat textures with the `Billboard` effect — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
19d22778f2d325c741ad49c5d4c7098778bcf478068b2b4e6ab146f5c9fbb0f0  Billboard/Billboard.cs
f7bc0def02914fc4fc613df52aa23ac5c7ad9de1e41a26825192941d92a228bb  Billboard/BillboardSample.png
47dcc7f20622da91b418b2dae98c756a53ab5bb8676cebc4f108b66511435bfd  Billboard/BillboardWindows.csproj
6aba5b7c307fa64cece8e7c1b3aa663cc1dbc47658c5f4ddae735353ee81286c  Billboard/BillboardXbox.csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Billboard/Game.ico
bf4d516a24daf1f507e95f773f2c73596841832e8c585e1ca023db97aec1fd1b  Billboard.htm
5746d8f2c5f1c8fed7c83d4d5b13baa61d4885acec72634bcd2f3590dd734278  Billboard/Properties/AssemblyInfo.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-3/BillboardSample/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
