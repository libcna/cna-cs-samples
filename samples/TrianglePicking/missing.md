# TrianglePicking audit — CSSAMPLE-048 ✅

## Result

**The original C# runs unmodified and matches the C++ port** — 1 differing pixel of 384 000. The Windows project's sources, verbatim, build in Debug and Release with no warnings. It first died in its first `Update`: each model's `Tag` is a `Dictionary<string, object>` holding a `BoundingSphere` and a `Vector3[]`, and CNA.NET handed the game CNA.Framework's `CNA.BoundingSphere`. Fixed in `../cna-cs` (CSX-093: a model whose tags hold CNA.Framework types is read through the managed `ContentReader`, which also gained XNA's `ObjectReader` for `System.Object`).

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/TrianglePickingSample_4_0` |
| Project | `TrianglePickingSample/TrianglePickingWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `TrianglePicking.Program` |
| Assembly name | `TrianglePicking` |
| Content | the table, cats, sphere, cylinder and wedge models (each tagged by the sample's `TrianglePickingProcessor`), their textures, the cursor and `hudFont.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
cafb49d22b19268bfb687e749f324747bb31cb0027903030990c126949e29efe  TrianglePicking.htm
589dd1bb95632f8adc74f0d2ec8a880e669be93db27c965c35bd57a2dff47040  TrianglePickingSample/Cursor.cs
5af09362beb8837620a9ba6dcb8717514d4648aa9e6e4385a550738712c3e30f  TrianglePickingSample/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  TrianglePickingSample/Game.ico
7be5d18089694aefbedd42b326acd5039f07434627de8620c738d488f08917f3  TrianglePickingSample/Properties/AssemblyInfo.cs
b6fad5e915378e5a28a42b686b4a8e380207233182eacdb597ca318ebad8d570  TrianglePickingSample/TrianglePickingSample.png
7e66ca246c6f2e2429a048e4407d139cfa986ce5c43ed1cf1d5e0d3b57b76fc7  TrianglePickingSample/TrianglePickingWindows.csproj
edb332d4731c79cce0023013ad7f779abdbcae4a0ba73dfb04feab9ca26e3244  TrianglePickingSample/TrianglePickingXBox.csproj
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way (`/rv/tmp/cs-samples/gallery-batch-58b/`). Runs against CNA.NET `590d007`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-58b/TrianglePicking/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
