# DistortionSample audit — CSSAMPLE-032 ✅

## Result

**The original C# runs unmodified and is pixel-identical to the C++ port** — 0 differing pixels of 384 000. The Windows project's sources, verbatim, build in Debug and Release with no warnings. The sample found two CNA.NET defects, both fixed in `../cna-cs`: its `Draw` calls `base.Draw` in the middle of the frame, where its distortion component composites the scene, and then draws its HUD — the facade ran the components after the game's `Draw` instead (CSX-090); and it clears its displacement map with `Color.Transparent`, which was transparent white rather than XNA 4.0's transparent black, so the whole scene moved by half a texture (CSX-091).

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/DistortionSample_4_0` |
| Project | `Distortion/DistortionWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `DistortionSample.Program` |
| Assembly name | `DistortionSample` |
| Content | the dude, cube, cylinder and window models, the distortion effects (`Distort.xnb`, `Distorters.xnb`), the textures and `hudFont.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
cc1be3bdec24be2524868c78c57f3a3495e730ef80fdcc10c84ba82686f8061d  Distortion/Distorter.cs
5eeaafc91abe49de6da302db6a25db6886f8b5fca7e77d100774b926a4cbbb4d  Distortion/DistortionComponent.cs
e573e241724eb38208b1c0cf91d7779e73201162f96c45f4461cb1cc4a20b410  Distortion/Distortion.png
91d331ab6c51e306fb22c39c66ca114ed5becad8906da1638e78474100621896  Distortion/DistortionWindows.csproj
acdfee6f698302a6945e4def070c23cc0469ef0c663429f0d0c0348c47b8d02e  Distortion/DistortionXbox.csproj
e67cd1e90de74b1c5b4a2659c914735fb6c697086995449b2ceb1a57ad06b674  Distortion/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Distortion/Game.ico
6cf310920318d397fa5a51d7c0992578d795d404aee1a6f661b24c6c584edac8  Distortion.htm
099d5c5f5b56a048f98cab16862c494be1f735d8889f7819e0dc784d504c757c  Distortion/Properties/AssemblyInfo.cs
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way (0 px). Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/DistortionSample/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
