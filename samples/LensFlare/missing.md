# LensFlare audit — CSSAMPLE-041 ✅

## Result

**The original C# runs unmodified and matches the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings; the lens flare relies on occlusion queries against the sun. The first frame differs from the C++ port by 104 px of 384 000 (2% fuzz).

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/LensFlareSample_4_0` |
| Project | `LensFlare/LensFlareWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `LensFlare.Program` |
| Assembly name | `LensFlare` |
| Content | the terrain and its texture, three flare sprites and the glow — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
cdbeceecd1bd9e44c3721684738f1130e1f1ed4375d240ecefa5bf990064abb7  LensFlare/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  LensFlare/Game.ico
a11191dfba87f6fa02d47ab797743568aee1d75805debf7243326704c20906db  LensFlare.htm
558e37b0cc867aa4f7e6cbccef7aa71cbb6debe7c1dc64cfadfeb14d55b48d2b  LensFlare/LensFlareComponent.cs
232a2dbdb8e5fd0a3bb2ad388cb8917696d1123c489acea40c310d1fd9a0abd2  LensFlare/LensFlare.png
7c27856662d2f4e621463ac946738a1729c5cf1e94c40c335528e59f0372d5ae  LensFlare/LensFlareWindows.csproj
4b890a4ff302299362e28e8f839ac36bcf7732a417fbeff624e59dcae48d2968  LensFlare/LensFlareXbox.csproj
2287480041e6ec79e37adf8521bc5d18f7169a39ded3a51d6d124665ed5f14b4  LensFlare/Properties/AssemblyInfo.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-2/LensFlare/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
