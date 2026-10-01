# InstancedModel audit — CSSAMPLE-040 ✅

## Result

**The original C# runs unmodified.** The Windows project's sources, verbatim, build in Debug and Release with no warnings and draw 1 000 spinning cats with hardware instancing (a per-instance matrix stream and `DrawInstancedPrimitives`). Against the C++ port the frame differs by 13.95% (2% fuzz): the spin and the frame-rate text. The C# run reports about 60 frames per second and the retained C++ port about 350: sampled, the C# process spends its time in llvmpipe's rasteriser threads, not in managed code or interop, and the C++ binary was built against an older CNA, so the two numbers are not like for like.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/InstancedModelSample_4_0` |
| Project | `InstancedModelSample/InstancedModelSample/InstancedModelSampleWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `InstancedModelSample.Program` |
| Assembly name | `InstancedModelSample` |
| Content | `Cats.xnb` and its texture with the `InstancedModel` effect (built by upstream's pipeline-only `InstancedModelPipeline`) and `Font.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  InstancedModelSample/Game.ico
3a1ed343072f5e40768f3db56a6feb3866a3e384dcad1a67761d245458375cfd  InstancedModelSample/InstancedModelSampleGame.cs
8f0c11a9ffbfadfd4defe48e25872c4be18be56c9573611d80d38bd6cac752a2  InstancedModelSample/InstancedModelSample.png
e28caa9a375767d41813a704d1f7a29233a2bb74d8ced069863910ef6af79f7d  InstancedModelSample/InstancedModelSampleWindows.csproj
cf349bf10f491027bfda651607615df128a21a84dbe97c68775ea5e0a73214f0  InstancedModelSample/InstancedModelSampleXbox.csproj
1c4d06fe566f395cc68c0aaacbcc93c62d08e6593748a732201fc059c35f3aed  InstancedModelSample/Properties/AssemblyInfo.cs
1e3df32eaceac51f6ba604d794e94395266424697af6d623090b72c3b3455d7e  InstancedModelSample/SpinningInstance.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Frame rate: `dotnet-trace` (97% of samples in native code, 18% inside the game's Draw) and gdb samples of the game thread (waiting in libgallium). Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-3/InstancedModel/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
