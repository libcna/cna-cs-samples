# ModelImporterSample audit — CSSAMPLE-099 ✅

## Result

**The original C# runs unmodified.** The Windows project's sources, verbatim, build in Debug and Release with no warnings and draw the tank the custom importer produced. Against the C++ port the frame differs by 11.80% (2% fuzz): the tank's time-driven rotation.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ModelImporterSample_4_0` |
| Project | `ModelImporterSample/ObjImporterGame/ObjImporterGameWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `ObjImporterSample.Program` |
| Assembly name | `ObjImporterSample` |
| Content | `Tank.xnb` (imported from .obj by upstream's pipeline-only `ObjImporter`) and its two textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
3400d1f16fc9474653860879cd23563b5de8cbdbb65d4ea0d32c43d8db59d756  ObjImporterGame/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  ObjImporterGame/Game.ico
3a9ede11b3887bb7d69fa0a6c1021234c731bc7a80bac42f586bc6c37aebe2c5  ObjImporterGame/MeshImporterSample.png
244bb5f0f3d77f91f41a74bde98b2fc9ab80c4785cdf7b0c20cf3a44a3f7f18b  ObjImporterGame/ObjImporterGameWindows.csproj
4268dd63fb16a018a747d9057e2ff329a6b6305543f4e18e1ca40de7d90bb646  ObjImporterGame/ObjImporterGameXBox.csproj
9c1492b01e210d472f1ff06fa8941c36c45f7cb465a3b8edec80f93e8409f8d9  ObjImporterGame/Properties/AssemblyInfo.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-3/ModelImporterSample/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
