# TransformedCollisionTest audit — CSSAMPLE-020

## Result

**The original C# runs unmodified.** This is the **second runnable product** of `CSSAMPLE-020`; the first is `samples/TransformedCollision`. `rules.md` keeps it in its own directory because upstream gives it its own solution, its own `Program.cs` and its own content.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/TransformedCollisionSample_4_0` |
| Project | `TransformedCollisionTest/.../TransformedCollisionTest.csproj` |
| Configuration | `Release|x86` and `Debug|x86`, Windows, Reach |
| Entry point | `TransformedCollisionTest.Program` |
| Assembly name | `TransformedCollisionTest` |
| Content | `F.xnb`, `Point.xnb`, `R.xnb` |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  TransformedCollisionTest/Game.ico
3cd2cfcac93c3a0dcc5ceab63ad57e3b5afd0a1dcc722428e66c51031d79d0ed  TransformedCollisionTest/GameThumbnail.png
b0bdfadf8ef1602a22911bf8ac60d304f19d197a9da9d4716d32209ed141adf9  TransformedCollisionTest/Program.cs
6cd62e995ea6d4f131e82c17a3d3ed75d67249727d98f1901bb32b2c984dd471  TransformedCollisionTest/Properties/AssemblyInfo.cs
4cb7d4c5dbed2396308a3b551748d9a8d00a7792a19f201434dbc82fa00d0a0e  TransformedCollisionTest/TransformedCollisionTestGame.cs
60df219c6fed964fdef216b3459bf17d6c900b1b26e65ad3887a0f1fdd354f8b  TransformedCollisionTest/TransformedCollisionTestWindows.csproj
7969b4115f1ff83056e1e3bab3df98ee52eb365ed0f2c6aa5498866f25209720  TransformedCollisionTest/TransformedSprite.cs
```

## Native verification

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled `Transformed
Collision Test`, exiting 0 on Escape.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **A pixel comparison with the C++ port.** Not run for this product; the first product's comparison
  is in its own `missing.md`.

## Artifacts

`/rv/tmp/cs-samples/TransformedCollisionTest/evidence/release/`.
