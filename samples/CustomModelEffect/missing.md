# CustomModelEffect audit — CSSAMPLE-053 ✅

## Result

**The original C# runs unmodified.** The Windows project's sources, verbatim, build in Debug and Release with no warnings and draw the saucer through the environment-mapping effect its pipeline put on the model. Against the C++ port the frame differs by 11.45% (2% fuzz): the saucer's time-driven rotation.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/CustomModelEffectSample_4_0` |
| Project | `CustomModelEffect/CustomModelEffectWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `CustomModelEffect.Program` |
| Assembly name | `CustomModelEffect` |
| Content | the saucer, its texture, the environment map and the Seattle cube (built by upstream's pipeline-only `CustomModelEffectPipeline`, which swaps the model's effect) — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
1032f6b11fbbdc5a74591e9c7bc9f76daf6edd29b7dbe37e4a5e2501dccb25e5  CustomModelEffect/CustomModelEffect.cs
f93eb6cfa69c063cf5bc0873568976124befcdf1b6b6ce10997f2a7269d58944  CustomModelEffect/CustomModelEffectSample.png
83e7fd6c75f1fe6f91be101bc8188e95425454906298cef3d7304b850617e3e0  CustomModelEffect/CustomModelEffectWindows.csproj
d4deeb42ccd09bcebfdf1c953b38a8488a2b90daac4650dad61077583720f4a0  CustomModelEffect/CustomModelEffectXbox.csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  CustomModelEffect/Game.ico
3d12f2f094f0e4878b09df78bae7b78d1b219b388de98a29004ddacc6e6ca23c  CustomModelEffect.htm
9e82c9c0ccfe554a7f4646b7dbdd05d35016f0d7295de7fa4d52393e110dc569  CustomModelEffect/Properties/AssemblyInfo.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-2/CustomModelEffect/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
