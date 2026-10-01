# ShadowMapping audit — CSSAMPLE-038 ✅

## Result

**The original C# runs unmodified and matches the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings and render the shadow-mapped scene through its compiled `DrawModel` effect and a shadow render target. The first frame differs from the C++ port by 1 px of 384 000 (2% fuzz). Holding Left turns the camera on both; the angle differs by the frames each run had in 0.8 s, since the turn is per elapsed millisecond.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ShadowMappingSample_4_0` |
| Project | `ShadowMapping/ShadowMappingWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `ShadowMapping.Program` |
| Assembly name | `ShadowMapping` |
| Content | the grid and dude models with their textures and `DrawModel` effect (built by upstream's pipeline-only `CustomEffectPipeline`) — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  ShadowMapping/Game.ico
d14ca3b53a7faaaa8a693dd05abc637cd56d768e13b1c3acfc9e854e45ec69e2  ShadowMapping.htm
7e6560df2f5cf8d90e5924ee0b75453e615327fc287bb5f04d2a72cac5bf3f54  ShadowMapping/Properties/AssemblyInfo.cs
f8f79da4970ea7e406acd661d226047788e90a7bef230197ed93603d0b718e8d  ShadowMapping/ShadowMapping.cs
b2a0831633026e825e3937608377746362b131fe9cb45a3c959ecf7ae6213b79  ShadowMapping/ShadowMapping.png
660eac65545aa00cb1203e08255b7f5c24da2ac075613f7275912f9ec9afabf4  ShadowMapping/ShadowMappingWindows.csproj
ae3bacdb2db18affc8214789eb74a3f46a388af822d1c396db18849a1327d967  ShadowMapping/ShadowMappingXbox.csproj
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. `CustomEffectPipeline` is a Content Pipeline extension and is not checked in. Interaction: `requalify.sh --xdotool 'keydown Left sleep 0.8 keyup Left sleep 0.3'`. Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-1/ShadowMapping/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
