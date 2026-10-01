# TankOnHeightmap audit — CSSAMPLE-074 ✅

## Result

**The original C# runs unmodified and is pixel-identical to the C++ port** — 0 differing pixels of 384 000. The Windows project's sources, verbatim, build in Debug and Release with no warnings. Its terrain, like `HeightmapCollision`'s, is a `Model` tagged with the game's own type and loads through the managed `ContentReader` (CSX-089).

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/TankOnAHeightMapSample_4_0` |
| Project | `TankOnAHeightmap/TankOnAHeightmap/TankOnAHeightmapWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `TanksOnAHeightmap.Program` |
| Assembly name | `TanksOnAHeightmap` |
| Content | `terrain.xnb` (a `Model` tagged with the game's `HeightMapInfo`), `tank.xnb` and their textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  TankOnAHeightmap/Game.ico
ac67b9a0003a47fcc1821bbc6faeb566574f31b9155730fa08df46d0668097e7  TankOnAHeightmap/HeightMapInfo.cs
938eead7bbab7ce023f952437e224773e25cad244f4394df6ed9b7e40a50b074  TankOnAHeightmap/Properties/AssemblyInfo.cs
a5a15d273695a9611625fd6a159f21049f50a4dda075de46067be37af8906df8  TankOnAHeightmap/Tank.cs
812e8cea55cc2daa3b1bce987663959767d00f06e4550a9300c3e12b366e3f1d  TankOnAHeightmap/TankOnAHeightmap.cs
141f2ea1bea4806a98da2ee3f9abe3f034eebde300ebd07a0774c66e11738be3  TankOnAHeightmap/TankOnAHeightmap.png
4a9e9287d9112ef7cf702db5d7c90b8136f89d53f7cbd74c1edef15beaa5c117  TankOnAHeightmap/TankOnAHeightmapWindows.csproj
3bcff20d94b7da122fc7a723efb3a8102ee1b461589faaccceb934da8f9e5ad4  TankOnAHeightmap/TankOnAHeightmapXbox.csproj
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way (0 px). Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/TankOnHeightmap/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
