# FlockingSample audit — CSSAMPLE-024

## Result

**The original C# runs unmodified.** No `../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/FlockingSample_4_0` |
| Project | `Flocking/Flocking/Flocking (Windows).csproj` |
| Configuration | `Release|x86` and `Debug|x86`, Windows, Reach |
| Entry point | `Flocking.Program` |
| Assembly name | `Flocking` |
| Content | `cat.xnb`, `HUDFont.xnb`, `mouse.xnb`, `xboxControllerButtonB.xnb` |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
e8296ccfa1a80c4619739a96e233fb9d618fb925b2ca08e6e3c83a1f7d02f8b0  Flocking/Animals/Animal.cs
5db909dfe0ab122960bbe623628e85c99415590ebf0fc6669fb2c49f0661c686  Flocking/Animals/Bird.cs
37d5704f1f96195b86cb17d1946139c3515c34bdd6515c305cea6c0ec4fd1d81  Flocking/Animals/Cat.cs
f193a5e8f09bbfa9f1d871cfb3c5704486fb6bf6e3e932d0c1bfc3b3a225a4fa  Flocking/Background.png
ffd5796c5162fabb3d87a51b3a02e5ce715fcb53b5676850a19ebfdbb3292bdf  Flocking/Behaviors/AlignBehavior.cs
7b0e9c102a7f3cb19322e871826c0c62ae402b23cbd03265e54724cb33d55bac  Flocking/Behaviors/Behavior.cs
0916d908ccee5f3dd7d71a08d63f5813d55d8f918fc12e0f3babc55b833da7af  Flocking/Behaviors/Behaviors.cs
cab294997d13c7a6be3ac82afe70364ff6aed7a6e490773825d94e42de127362  Flocking/Behaviors/CohesionBehavior.cs
abd1827695b27a24664226df1e9f75b097b58779fa583f7f06bc290578424ae7  Flocking/Behaviors/FleeBehavior.cs
189382d20645b01984c3095ebf4cd7e2153ac6d1d7bc3818a5c12475d27cb6c4  Flocking/Behaviors/SeparationBehavior.cs
ae02234291ceba0a9185399180dacb84944c1f8c754419af1ad1d2900d22f4eb  Flocking/Flock.cs
fd7c60c4a54e13453bbe8f4d9f41dec6176fadebadbf36693f27ae7e64b4cf91  Flocking/FlockingSample.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Flocking/Game.ico
a4502377104f5c76e705c8a1cb7ae7187cf602ac35482b8c6facf44ad0387a8c  Flocking/GameThumbnail.png
fc50f8a2579ec699155269055c5c71a2dab308df2441e43e7f0fe3db68f49826  Flocking.htm
48f2bc6bde21aeb58290f1b94caee945c6dafa32bfcd07770594d18c8e8882e8  Flocking/InputState.cs
64168ed7e38a2855756421d16e43efd7cdd80e56932d308ac74cd35100b0ae6c  Flocking/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Flocking/Properties/AppManifest.xml
b72c428493916c7f9490e0ec90467654e552276bdf2b9c4ace930ca5430cff3f  Flocking/Properties/AssemblyInfo.cs
24001fbcd29223ad607e6b21489efbbd8184c7af0c8e744d540db1a152bd8b2a  Flocking/Properties/WMAppManifest.xml
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled `Flocking`,
exiting 0 on Escape. 4 282 distinct colours.

Against the C++ port: 11 552 differing pixels of 384 000 — and the control says that is the boids
moving, not the engines disagreeing. Two runs of **this** build at settles of 5 s and 9 s differ by
**11 385**, the same band. A residue no larger than the build's own frame-to-frame variation is not
evidence about the other engine.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The flocking behaviour.** Only a single frame was compared.

## Artifacts

`/rv/tmp/cs-samples/FlockingSample/evidence/` — `release/`, `settle9/` and `cpp-reference.png`.
