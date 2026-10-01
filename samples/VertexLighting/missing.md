# VertexLighting audit — CSSAMPLE-036 ✅

## Result

**The original C# runs unmodified and matches the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings. The first frame differs by 1.08% (4 130 px), all of it in the reference grid's horizon band (y 160–191); the lit model is pixel-identical. That band is the older CNA in the retained C++ binary, as `TexturesAndColors` (CSSAMPLE-003) records from an apitrace of the same grid.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/VertexLightingSample_4_0` |
| Project | `VertexLighting/VertexLightingWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `VertexLightingSample.VertexLighting` |
| Assembly name | `VertexLighting` |
| Content | the five primitive models and the `VertexLighting` and `FlatShaded` effects — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  VertexLighting/Game.ico
8fc8b7cd80e9f90f0c223a854fe8884ae7a29f1d07c2443dd12776be4f371f84  VertexLighting.htm
4d197443e9c952e0e2591d87ee941242cad6df37bdf646347606d6c7857fe003  VertexLighting/Properties/AssemblyInfo.cs
658c53a131ce4cc73e649ecb411e626d10f0bd0dfc012eff5d6e3943fd446e99  VertexLighting/SampleCamera.cs
f367f5dc88f1084bccdf66af16c1561244f150d88bf080343879dd6b410e7b05  VertexLighting/SampleGrid.cs
59ffed3177d41fb05dbb7467892487cf8b8ec07084a92aadd466a37455ac6c91  VertexLighting/VertexLighting.cs
8256285d9a75cedc1218f5d7a4f732398316c012bfd7a24f8d97bafd799fd053  VertexLighting/VertexLightingSample.PNG
14c8211bde1ecdc156ad39bffaf10ffe9d7e30a70f39529c67c8aca321329dfb  VertexLighting/VertexLightingWindows.csproj
c46b6f1ad239961de9049a72afa3648850710f746509f6bbb292c422015ea6ae  VertexLighting/VertexLightingXBox.csproj
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way, with the differing pixels located. Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/VertexLighting/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
