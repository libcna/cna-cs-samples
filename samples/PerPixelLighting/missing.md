# PerPixelLighting audit — CSSAMPLE-035 ✅

## Result

**The original C# runs unmodified and matches the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings. The first frame differs by 1.08% (4 130 px), all of it in the reference grid's horizon band (y 160–191); the lit model is pixel-identical. That band is the older CNA in the retained C++ binary, as `TexturesAndColors` (CSSAMPLE-003) records from an apitrace of the same grid.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/PerPixelLightingSample_4_0` |
| Project | `PerPixelLighting/PerPixelLightingWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `PerPixelLightingSample.PerPixelLighting` |
| Assembly name | `PerPixelLighting` |
| Content | the five primitive models and the `PerPixelLighting` and `VertexLighting` effects — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  PerPixelLighting/Game.ico
e73a566e92c667cef7519435999e0ffff5428a2803763d327cd032f31c682ec9  PerPixelLighting.htm
cc841ff2b32c792530f938084c9c718fda1ba565e3020f29aa4e6c1ff48193d8  PerPixelLighting/PerPixelLighting.cs
7da10fc9d054c042482b309314d2df0fe251736298b24b4d0c84301f44327dc0  PerPixelLighting/PerPixelLighting.png
a65c80da7b19964b23969a484496eb52866362a6a37a88dd08dca4fe73fbfbb3  PerPixelLighting/PerPixelLightingWindows.csproj
c41d3200f19dec6737bec75f401f4e566334f9a50b0f4dd9e53dbe05b854dfb6  PerPixelLighting/PerPixelLightingXbox.csproj
55d72f367f2b6c84c69c7114d33a6f278685c0856b44153c168d641828bb3eaf  PerPixelLighting/Properties/AssemblyInfo.cs
97e0e869afc6cfb1ca89b8c1a337906b8319c55af781805373c92668e1222511  PerPixelLighting/SampleCamera.cs
a372e5f2ca8eccfde422d1ce9325e35036d3e4c4c106cb51714f88376e72b688  PerPixelLighting/SampleGrid.cs
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way, with the differing pixels located. Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/PerPixelLighting/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
