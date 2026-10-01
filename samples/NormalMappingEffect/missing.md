# NormalMappingEffect audit — CSSAMPLE-034 ✅

## Result

**The original C# runs unmodified and matches the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings and normal-map the lizard and rock through the compiled effect. The first frame differs from the C++ port by 0.54% (2 091 px at 2% fuzz).

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/NormalMappingSample_4_0` |
| Project | `NormalMappingEffect/NormalMappingEffectWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `NormalMappingEffect.Program` |
| Assembly name | `NormalMappingEffect` |
| Content | the lizard and rock with their diffuse and normal maps and the compiled `NormalMapping` effect (built by upstream's pipeline-only `NormalMappingEffectPipeline`) — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  NormalMappingEffect/Game.ico
c2c2e4835896108f22f8664acdd5f352feb428a4540407ded78e6802cf5582fe  NormalMappingEffect.htm
23e1d66b67a8762395e862aa86cdea0b7147956c9e23a6fecab01a176b9d1ed0  NormalMappingEffect/NormalMappingEffect.cs
ea3a62152e75231650e1397807b8649e8d5c3f13de3d0128b91874ac67b55597  NormalMappingEffect/NormalMappingEffectSample.png
69050784377106ca1f6853530a7cb48c5aa698eb46667a3a3406ec0a095fd8b5  NormalMappingEffect/NormalMappingEffectWindows.csproj
2d7d43cf92bf8278331743083427b975c8e27dad7581ed8c92b931df319ae979  NormalMappingEffect/NormalMappingEffectXbox.csproj
6f7ad7c1e6f8cce7beb20fb613352217840df746ed1581f1245bc74ddce7072a  NormalMappingEffect/Properties/AssemblyInfo.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-2/NormalMappingEffect/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
