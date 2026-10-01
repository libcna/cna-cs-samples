# CustomModelClass audit — CSSAMPLE-052 ✅

## Result

**The original C# runs unmodified.** The Windows project's sources, verbatim, build in Debug and Release with no warnings. The tank is not a `Model`: it is the sample's own `CustomModel` class, read back by XNA's `ReflectiveReader` into the game's type -- the managed content path end to end -- and drawn with its own `BasicEffect`. Escape exits 0. Against the C++ port the frame differs by 6.39% (24 555 px at 2% fuzz): the same tank at another moment of its time-driven rotation.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/CustomModelClassSample_4_0` |
| Project | `CustomModelSample/CustomModelSampleWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `CustomModelSample.Program` |
| Assembly name | `CustomModelSample` |
| Content | `tank.xnb` (written by upstream's pipeline-only `CustomModelPipeline` as XNA's `ReflectiveReader<CustomModelSample.CustomModel>`) and its two textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
d20139d654ecf430437369647c1d52d51c63dca2192c1449c0a6eeee51f8b3ae  CustomModel.htm
7f6efe1b57f486a4d9902e49aed765b5ea5ea47343c50264bc94aa5cbc72e46b  CustomModelSample/CustomModel.cs
e0ea1274fd78cfe29e4f3374e22db16df849bad15b218a5747ab907fbcb12eac  CustomModelSample/CustomModelSampleGame.cs
9c7de3f17c7b02953fef46070df2d04c3413066ea62c4677fcf7eb99eb3abbc3  CustomModelSample/CustomModelSample.png
e9eb04dab8989d1b6c51307612ba104e46203c34de0b667d4a9f2f64b12cd07c  CustomModelSample/CustomModelSampleWindows.csproj
7594eab8998d6e5b523b74e317f678177d534a033d5e074eceb88d56e3644006  CustomModelSample/CustomModelSampleXbox.csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  CustomModelSample/Game.ico
977f77489c6f7d240cbdcfe81bcf8502e8d1d69f8ee35efe0bc7e520de9c02c3  CustomModelSample/Properties/AssemblyInfo.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. `CustomModelPipeline` is a Content Pipeline extension (build time only) and is not checked in. Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/cssample-052/CustomModelClass/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
