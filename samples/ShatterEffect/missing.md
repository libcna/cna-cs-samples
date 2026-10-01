# ShatterEffect audit — CSSAMPLE-042 ✅

## Result

**The original C# runs unmodified, and its custom effect matches the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings, load the processed tank `Model`, the compiled `ShatterEffect` and a font, and exit 0 on Escape. The first frame differs from the C++ port by 13 px of 384 000 (2% fuzz); after holding Up for 0.8 s on both, the shattered frame differs by 46 px.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ShatterEffectSample_4_0` |
| Project | `ShatterEffect/ShatterEffectWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `ShatterSample.Program` |
| Assembly name | `ShatterEffect` |
| Content | `tank.xnb` (built by upstream's `ShatterProcessor`, which is pipeline-only and not checked in), its two textures, `ShatterEffect.xnb`, `font.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  ShatterEffect/Game.ico
92e5643d40c71133d7c2ff4e4acbe0a5cc77c32a410c0c4bbef38005637a6f7a  ShatterEffect.htm
76023a5943012cf1282a21f9f34f920999ee2d4d51c33589cd25c5ba48bd81f1  ShatterEffect/Properties/AssemblyInfo.cs
715dc81c731f51c7467b81817de11e99ae9d8f01143e8158e5a4dd52858d9451  ShatterEffect/ShatterEffectGame.cs
9c6a5ec8122abc70c9dd688ef83a06964f43a77b770974335acf2bab9c1747ab  ShatterEffect/ShatterEffect.png
b2a0167c8553a738f79c5a391188af7d2ae6bcb5963cb8c0428fbd7cd2acaaa1  ShatterEffect/ShatterEffectWindows.csproj
cbb574e7222a8061693eb8c7e2bf367db40baa7c7736559daa9a73b6f59eb212  ShatterEffect/ShatterEffectXbox.csproj
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Interaction: `scripts/requalify.sh --xdotool 'keydown Up sleep 0.8 keyup Up sleep 0.3'` (`/rv/tmp/cs-samples/cssample-042-up/`). Runs against CNA.NET `8fcd961`, CNA `80572aa00`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/cssample-042/ShatterEffect/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
