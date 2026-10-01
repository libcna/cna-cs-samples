# SkinnedModelExtensions audit — CSSAMPLE-055 ✅

## Result

**The original C# runs unmodified and animates the skinned model with the bat in its hand.** The game and its `SkinnedModel` library, both verbatim, build in Debug and Release with no warnings. The first frame differs from the C++ port by 9.17%, the walk cycle's phase at capture time; model, bat and lighting are the same.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SkinnedModelExtensions_4_0` |
| Project | `SkinningSample/SkinningSampleWindows.csproj` with `SkinnedModel/SkinnedModelWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `SkinningSample.Program` |
| Assembly name | `SkinningSample` |
| Content | `dude.xnb` (tagged with the library's `SkinningData`), the baseball bat, `CollisionSpheres.xnb` and the textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `SkinnedModel/`) is clean.

```text
88517d0dbb54d9d263196b60e1c647f5c1e4a6600ade8acb26b48230779cb669  SkinnedModel/AnimationClip.cs
3d550beb3a7c69ccb8b58161dde51d2a12d2252f6ed4c42a4b965acf7cb3cd8d  SkinnedModel/AnimationPlayer.cs
690a2f13c812dadeb1d855be4d47b0f49280c005317c13daae77074527bfc7ee  SkinnedModel/Keyframe.cs
4c80662bb94862911448be1db3f301805efe90f894218cff39e0cadbd304c248  SkinnedModel/Properties/AssemblyInfo.cs
95a0bb8a8542cbb0557af992c055300f7668ad9f10a4bb0e67146d80b0a7bad4  SkinnedModel/SkinnedModelWindows.csproj
3f55d71541c109af5a7ea78e36f4ff569ab6769b18b3758bf9cc5f9b991402a5  SkinnedModel/SkinnedModelXbox.csproj
2abca6b32f8e169fbb7ff8a91bf804e98dcc6d6b246c4989c9f86d00ed8bb7e5  SkinnedModel/SkinnedSphere.cs
defc9c16fe1c1016ca9c740c9796f379ea8718251fb2f700dfc1853949faa0d3  SkinnedModel/SkinningData.cs
c711c0d63499bc4a9c09b41bd2c4df612a64cbbfed4959525ed4f76a4886185c  SkinnedModelExtensions.htm
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  SkinningSample/Game.ico
42be1aa3308a2783e4f3e69dac428c734a50cbc0e76df7ca462cf61bb357c205  SkinningSample/Primitives3D/GeometricPrimitive.cs
d8426267a6aeea48673e092ba5bbf4104dd7aeeb891252ef178701de9b52da70  SkinningSample/Primitives3D/SpherePrimitive.cs
fcc00bbcf02e1dbeba1f39945b73d552bb90ab18181daa94c8c5a8b37af69579  SkinningSample/Primitives3D/VertexPositionNormal.cs
cc8878ad079948aa3ad2f7de04543f6f9876e168950ec6b9dd51ec5561f26cea  SkinningSample/Properties/AssemblyInfo.cs
ecdacca49f72e6c4da12c126bce8ee9f231ab7c4decdc8d730bf76c666c5a0e8  SkinningSample/SkinningSample.cs
767ea652b4b648ec06d9cef7d569bdb45808d51e69f8e204f3520212ec416911  SkinningSample/SkinningSample.png
4440b38fc2b34c7096505ca04200da1bf71ab0bc1cb63f18588001d2b19ad16f  SkinningSample/SkinningSampleWindows.csproj
fc02ff3e8fa1388db7d4e1fee92f87f359d02116479da450a5eb0cfad2cad6e0  SkinningSample/SkinningSampleXbox.csproj
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way, and the two frames compared by eye. Runs against CNA.NET `590d007`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-58/SkinnedModelExtensions/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
