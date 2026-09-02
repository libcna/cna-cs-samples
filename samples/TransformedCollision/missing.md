# TransformedCollision audit — CSSAMPLE-020

## Result

**The original C# runs unmodified.** No `../cna-cs` change was needed. This row has **two runnable products**; the second is `samples/TransformedCollisionTest`, which has its own `missing.md`.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/TransformedCollisionSample_4_0` |
| Project | `TransformedCollision/TransformedCollisionWindows.csproj` |
| Configuration | `Release|x86` and `Debug|x86`, Windows, Reach |
| Entry point | `TransformedCollision.Program` |
| Assembly name | `TransformedCollision` |
| Content | `Block.xnb`, `Person.xnb`, `SpinnerBlock.xnb` |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
59dc035917ea86670caecea145a2589544b250d5441ea5faf11acc2e582577c5  TransformedCollision/Block.cs
5fde5a05866eae5257d46dab53ce00a5e81371aba2023017b0f4ed65f332a3b4  TransformedCollision/Game1.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  TransformedCollision/Game.ico
3cd2cfcac93c3a0dcc5ceab63ad57e3b5afd0a1dcc722428e66c51031d79d0ed  TransformedCollision/GameThumbnail.png
0ec6366b47a40b3c6a82cfb8249c4adc3a03490d57135d04c259736d8070bb07  TransformedCollision.htm
8a62b292e9b6e2d232d752739ea3142f737a2b03ed8fabdd8bd389ee650b97c8  TransformedCollision/Program.cs
0e69fc9560126e65a3436c5e576e3a1b8864e6f4575055379f8b1335794a4891  TransformedCollision/Properties/AssemblyInfo.cs
d7d2423f277b585d37eee1aaeb5551e21832b21f7e55a15a23dd72afd991e96e  TransformedCollision/TransformedCollisionWindows.csproj
61c315d608088963cbb6d190e78a82d96943a68629f0eba5f7a6502a2ae6d548  TransformedCollision/TransformedCollisionXbox.csproj
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled `Transformed
Collision`, exiting 0 on Escape. 251 distinct colours.

Against the C++ port: 24 374 differing pixels of 384 000. **The scene animates**, and the control
says so: two runs of *this* build at settles of 5 s and 9 s differ by **30 621** pixels — more than
the cross-engine pair does. The sample spins a block and drops others from a `Random` in
`Game1.cs`, so a single frame is not comparable between runs, and a residue smaller than the
build's own frame-to-frame variation is not evidence of an engine difference.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The transformed collision itself.** The sample's point is per-pixel collision under rotation and
  scale; driving it needs input the capture script does not have.

## Artifacts

`/rv/tmp/cs-samples/TransformedCollision/evidence/` — `release/`, `settle9/` and `cpp-reference.png`.
