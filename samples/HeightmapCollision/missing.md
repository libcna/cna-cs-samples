# HeightmapCollision audit — CSSAMPLE-049 ✅

## Result

**The original C# runs unmodified and is pixel-identical to the C++ port** -- 0 differing pixels of 384 000. The Windows project's sources, verbatim, build in Debug and Release with no warnings. The terrain is a `Model` whose `Tag` is the game's own `HeightMapInfo`, written with the game's `HeightMapInfoReader`: it first failed to load, because CNA.NET read root models with a parser that knows XNA's readers only. Fixed in `../cna-cs` (CSX-089: such a model is read through the managed `ContentReader`, which resolves the game's readers as XNA does).

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/HeightmapCollisionSample_4_0` |
| Project | `HeightmapCollision/HeightmapCollision/HeightmapCollisionWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `HeightmapCollision.Program` |
| Assembly name | `HeightmapCollision` |
| Content | `terrain.xnb` (a `Model` tagged with the game's `HeightMapInfo`, built by the upstream pipeline extension), the sphere and two textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  HeightmapCollision/Game.ico
8154ca35499ee859376c4016e0234439f279fbce1bd75e17f33559bb8624225d  HeightmapCollision/HeightmapCollision.cs
b4bc8c46db7ee52b35726ca66cd5056b5f0087f528994631f83f6cf475547d3c  HeightmapCollision/HeightmapCollision.png
5bb4f1cbb075011a0e820fe488b96b08e6bfe395f613060a3945b9b4f1faab13  HeightmapCollision/HeightmapCollisionWindows.csproj
d2eaa35b96ff0430fc4cdd8f7af6e8ee1969a5569019426084e362261939a7fa  HeightmapCollision/HeightmapCollisionXBox.csproj
75512064ce3b2fd7d63943bfab675b6955ab2a3d178d375ab87249b475468e1c  HeightmapCollision/HeightMapInfo.cs
5d607a211b34e109d488cd4909e2150c00f244c087e8cfa45b32b37d45a6925b  HeightmapCollision/Properties/AssemblyInfo.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0, 0 px from the C++ port. Runs against CNA.NET `64c5095`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-4/HeightmapCollision/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
