# BloomSample audit — CSSAMPLE-031 ✅

## Result

**The original C# runs unmodified.** The Windows project's sources, verbatim, build in Debug and Release with no warnings and run the three-pass bloom through render targets. Against the C++ port the frame differs by 22.70% (2% fuzz), the tank's time-driven rotation under the bloom; after B on both, both show bloom off, differing by 26.09%.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/BloomSample_4_0` |
| Project | `BloomPostprocess/BloomPostprocessWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `BloomPostprocess.Program` |
| Assembly name | `BloomPostprocess` |
| Content | the tank and its textures, the sunset, the HUD font and the `BloomExtract`, `GaussianBlur` and `BloomCombine` effects — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
75cfbf2e4855ca32eef74f2bcf8d50ba75173738f9ac36a20330c85b357ff261  BloomPostprocess/BloomComponent.cs
20cc2659d07b07ebc89fd569b21a7729de281e5c8b4fc4e53bb1e3bf2477ce38  BloomPostprocess/BloomPostprocessWindows.csproj
2e4f64b0419e1b2731ba0228b8ed2ea7a35e2248223b91bf58a7735fa63a6c52  BloomPostprocess/BloomPostprocessXbox.csproj
d738f6968404b3c39c813ebb34fab3bf9fb5524dec5e52220bd0d8fb592c4dc2  BloomPostprocess/BloomSample.PNG
082f35e45091a4b77bb0eb4036c808bbebd99551f29a88bdcc422357f3f0b86c  BloomPostprocess/BloomSettings.cs
fdcc1a77514463ad04cd3dfc6017304edf965b3385e10400f2c3a2d6480a51e9  BloomPostprocess/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  BloomPostprocess/Game.ico
e841bee1d0a2fffa19d06825716852c5924dacfe755f2f68df3170e582f4b1bd  BloomPostprocess.htm
df4dd78022f797928f1cf40f0adc48067e403323cfc0d3071929e29443f2fd66  BloomPostprocess/Properties/AssemblyInfo.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Interaction: `requalify.sh --xdotool 'keydown b sleep 0.3 keyup b sleep 0.5'` (`/rv/tmp/cs-samples/gallery-batch-2-input/`). Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-2/BloomSample/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
