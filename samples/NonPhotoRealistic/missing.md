# NonPhotoRealistic audit — CSSAMPLE-033 ✅

## Result

**The original C# runs unmodified, its two compiled effects matching the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings and draw the ship through the cartoon effect, with the post-process edge pass and the HUD font. Against the C++ port the first frame differs by 8.73% (33 541 px at 2% fuzz), the ship's time-driven rotation; after A on both, both show the Pencil setting, differing by 46.64%, the sketch overlay's random jitter.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/NonPhotoRealisticSample_4_0` |
| Project | `NonPhotoRealistic/NonPhotoRealisticWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `NonPhotoRealistic.Program` |
| Assembly name | `NonPhotoRealistic` |
| Content | the ship model and texture, `CartoonEffect.xnb`, `PostprocessEffect.xnb`, `SketchTexture.xnb`, `hudFont.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
3272c964c5b84ef27fe16c4fcc1d5748aac551bfddf12ae1734ae1321e077348  NonPhotoRealistic/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  NonPhotoRealistic/Game.ico
51c9cb2932c0a2a092e654a9add32f660c835e556cbfef4b2f309c70168867fb  NonPhotoRealistic.htm
6cb778ed3d84eb5f664acca17c161b0203721427bec3ecd14882714f88246c8a  NonPhotoRealistic/NonPhotoRealistic.png
0bd5dbbb855694d2a8f403db7ad0bf2e5e63a2c5ff6b3c93a2ca603f0707918d  NonPhotoRealistic/NonPhotoRealisticSettings.cs
c8c10f0383ac8cd67041e68b888257f8f3a72bcbd91fdfda3819dce866d065d8  NonPhotoRealistic/NonPhotoRealisticWindows.csproj
6e46c72554e7178e02b5b68f19fcb6912dd83fdb43e1f16902c253242d971fd6  NonPhotoRealistic/NonPhotoRealisticXBox.csproj
c20d173006cb5139d069954971420518c319d5d1cf7e8e378364b5db9a6dde14  NonPhotoRealistic/Properties/AssemblyInfo.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Interaction: `requalify.sh --xdotool 'keydown a sleep 0.3 keyup a sleep 0.5'` (`/rv/tmp/cs-samples/gallery-batch-1-input/`). Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-1/NonPhotoRealistic/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
