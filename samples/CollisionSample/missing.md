# CollisionSample audit — CSSAMPLE-017 ✅

## Result

**The original C# runs unmodified and matches the C++ port** — 0.65%. The Windows project's sources, verbatim, build in Debug and Release with no warnings; it exits 0 on Escape. The upstream `UnitTests` project is a separate test assembly and not part of this row. The retained C++ directory holds that test runner beside the game, and `requalify.sh` had been capturing it; it now picks `<Port>_cna_samples`.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/CollisionSample_4_0` |
| Project | `Collision/Collision (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `CollisionSample.Program` |
| Assembly name | `CollisionWindows` |
| Content | the font — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
5a2a4bcf04fc8b38b3c5d0f3265d8c4ef97bff7294d312c0d01c78c505898dce  Collision/App.config
ec154b1868605fbd763700c265491102c2ca12101a9d70a9583bc795c9b9e11d  Collision/Background.png
22e90fafb2c1e81b29bc9bf10e41897c0a3eed9c6f22dfbae16fada8b8b5577b  Collision/BoundingOrientedBox.cs
1efeac68ae8b54540e4199593f4aeed134e4f03ae4d60cd83ed3f21571a6eee6  Collision/Collision (Phone).csproj
674793be82def41ce33bde2ea86e4f07823719a1d4fd87bd2fb56662d6a428c8  Collision/CollisionSample.cs
9aea2aab67660cfdbd7d4769839df0b711897d64c661a82058571b48e182ed2f  Collision/Collision (Windows).csproj
52adf0fc6220ceb19ed49da9ea4a006c8618833aac5c19fd4b38852a25ec78a8  Collision/DebugDraw.cs
bd8f7adcdb417b3d4541bddd339faf6501d0357a006ed22a9ecbefa596f292ad  Collision/FrameRateCounter.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Collision/Game.ico
5dd30da9b0aaedd82d25d61e5803c052f5bc2fe8c9b3daebdc184764b1b26d74  Collision/GameThumbnail.png
6a3e148b71447c36618f0be8bdd0894fb855ccb9009da444edecacc8045770b5  Collision/GeomUtil.cs
d18c6e62b8ea93ba007f4fe797bdb2cd13c22f95db28d8a9b83c98bf7f43f4fd  Collision/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Collision/Properties/AppManifest.xml
b6e15ceda5c9620d4c066cfdda96bd28f90202bd73868bb3372d4f9e307cd1c9  Collision/Properties/AssemblyInfo.cs
d9916a968c3c4845aef72cc34c34015073bbbc805471ab547f1cd4ece160b7dd  Collision/Properties/WindowsPhoneManifest.xml
fedcb7a4c2a09cb22ea62670a18c6f8004377052911b810ba3d4b310db537242  CollisionSample.htm
0b5551f6b15b84f4b7e9ecebe4480c90960dbae8e925a547172ea4a7de0523d7  Collision/TriangleTest.cs
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way (`/rv/tmp/cs-samples/gallery-batch-59b/`). Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-59b/CollisionSample/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
