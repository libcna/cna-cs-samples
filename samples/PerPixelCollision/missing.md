# PerPixelCollision audit — CSSAMPLE-018

## Result

**The original C# runs unmodified.** No `../cna-cs` change was needed; the `Game.Initialize`
lifetime fix that `CSSAMPLE-019` bought covers this sample too, which is written the same way.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/PerPixelCollisionSample_4_0` |
| Solution | `PerPixelCollision (Windows).sln` |
| Project | `PerPixelCollision/PerPixelCollision/PerPixelCollisionWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Original `DefineConstants` | `TRACE;WINDOWS` (Release), `DEBUG;TRACE;WINDOWS` (Debug) |
| Entry point | `PerPixelCollision.Program.Main` in `Program.cs` |
| Assembly name | `PerPixelCollision` |
| Content | `Block.xnb`, `Person.xnb` |
| Native library | `cmake-build-release-capi` — see *Native library choice* |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
b509da3d04de79e10f074a2481f6c1858d1f6814c36e750c505db6b57def667f  Content/Block.xnb
7e9cff8ab0f5a5bc0e06282bed455d7783d7425589fea564400243c70d4c6a72  Content/Person.xnb
8e21adab24c0ef49de833c57dbb9a54b8d1eaf4b80e9c38f5d06207c8f16befc  PerPixelCollision/Game1.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  PerPixelCollision/Game.ico
3cd2cfcac93c3a0dcc5ceab63ad57e3b5afd0a1dcc722428e66c51031d79d0ed  PerPixelCollision/GameThumbnail.png
9090500120c5a58404f9e4d6ea035b917af8987bc6b643a3d5546c32344bc580  PerPixelCollision.htm
ef04051f34529f64b16c172893007f6c2bbf2e820aa1770704cd49dabd42c424  PerPixelCollision/PerPixelCollisionWindows.csproj
6b7b9a3f4953c91a2b38a0f47c9676d110c17b3c2f0a271abf5c5811449f1b13  PerPixelCollision/PerPixelCollisionXbox.csproj
44caa41c2f33b515e9ee53bfa9f6a8f271ddd1c4b29823a957fb837e5ad05e4b  PerPixelCollision/Program.cs
983c07a3203c4c8cbe86eefa24a955dac5b6540beaa7b16b97e026d493a4dab5  PerPixelCollision/Properties/AssemblyInfo.cs
```

## Native library choice, and a shutdown crash that is not this sample's

This row exposed that "OPENGLES3 Release" is not enough to name a native library, and then that the
obvious alternative has a problem of its own. Measured with this sample and `CSSAMPLE-019`, driving
each to its Escape exit:

| `../cnanext` tree | type | `CNA_EASYGL_COMPILED_EFFECTS` | exit code |
|---|---|---|---:|
| `cmake-build-release-capi` | Release | OFF | 0 |
| `cmake-build-opengles3` | Debug | OFF | 0 |
| `cmake-build-debug` | Debug | **ON** | **139 (SIGSEGV)** |
| `cmake-build-opengl33` (diagnostic only, wrong renderer) | Debug | ON | 0 |

Both samples crash on the third and neither uses a compiled effect — `PerPixelCollision` loads two
textures and nothing else — so the crash is a property of that build, not of the sample. It is also
not "compiled effects crash on shutdown" in general, because the `OPENGL33` tree has them on and
exits cleanly.

That leaves a stale `cmake-build-debug` as the likeliest explanation, and an OPENGLES3-specific
teardown defect as the alternative. An incremental rebuild of that tree is what separates them, and
until it has run this is **not** filed as a CNA report — an unrebuilt tree is not evidence.

This sample needs no compiled effect, so it was measured on `cmake-build-release-capi`, which exits
0. `CSSAMPLE-028`, which does need one, is blocked on `CNA-REPORT-002` regardless.

## Native verification

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled
`Per Pixel Collision`, exiting 0 on Escape.

## Comparison with the C++ port

| | C# on CNA.NET | C++ port |
|---|---:|---:|
| distinct colours | 9 | 9 |
| pure-white pixels (the person sprite) | 30 | 30 |
| person sprite bounding box | x 357..362, y 405..411 | x 356..361, y 404..410 |
| pure-black pixels (falling blocks) | 1 752 | 1 438 |

The block count is not comparable — the sample spawns from a time-seeded `Random`, as
`CSSAMPLE-019` and `CSSAMPLE-001` do.

**The person sprite reproduces `CSSAMPLE-019`'s one-pixel offset exactly**: 30 pixels in both
engines, one pixel left and one pixel up in the C++ port, at the same coordinates. Two samples that
share this sprite and this positioning code now show the same displacement, which makes it a
systematic difference in one of the two engines rather than a rounding accident in one sample.
Attributing it still needs the real XNA original, which `../cna-samples` has evidence for and these
rows do not.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The per-pixel collision itself.** The sample's point is that the person is blocked by the
  *opaque pixels* of a block rather than its bounding box, and that needs driven input the capture
  script does not yet have. `Texture2D.GetData` — the call the whole sample rests on — demonstrably
  works, since `LoadContent` reads both textures into `Color[]` arrays without throwing.
- **Gamepad.** Present in the source, no controller attached; Escape was exercised.

## Artifacts

```text
/rv/tmp/cs-samples/CSSAMPLE-018-PerPixelCollision/evidence/
├── release/          window capture, run log, window geometry, sha256
└── cpp-reference.png the C++ port through the same route
/rv/tmp/cs-samples/exitcheck/                 the four-library exit-code comparison
```
