# RectangleCollision audit — CSSAMPLE-019

## Result

**The original C# runs unmodified.** It did not at first: it crashed inside the initialize
callback, and the cause was a real XNA lifecycle divergence in the binding, fixed in `../cna-cs`
with a test. Both configurations now build 0/0 and the sample runs and exits cleanly.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/RectangleCollisionSample_4_0` |
| Solution | `RectangleCollision (Windows).sln` |
| Project | `RectangleCollision/RectangleCollision/RectangleCollisionWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Original `DefineConstants` | `TRACE;WINDOWS` (Release), `DEBUG;TRACE;WINDOWS` (Debug) |
| Entry point | `RectangleCollision.Program.Main` in `Program.cs` |
| Assembly name | `RectangleCollision` |
| Content | `Block.xnb`, `Person.xnb` |

The Xbox solution is a platform variant and is not this row's target.

## Binding fix — `Game.Initialize` did not load content

The first run crashed:

```text
Unhandled exception. CNA.CnaException: cna_game_run failed with native result Callback:
Object reference not set to an instance of an object.
   at CNA.Game.Run() ... at RectangleCollision.Program.Main() ... Program.cs:line 25
```

The sample is written the way the whole XNA sample collection is written:

```csharp
protected override void Initialize()
{
    base.Initialize();
    ...
    personPosition.X = (safeBounds.Width - personTexture.Width) / 2;   // loaded by now
}
```

XNA's `Game.Initialize` ends by calling `LoadContent`, so after `base.Initialize()` the textures
exist. FNA is the authority (`src/Game.cs:623`): its `Initialize` initializes the components and
then calls `LoadContent()` directly when a graphics device exists, or defers it to `DeviceCreated`.

`Microsoft.Xna.Framework.Game.Initialize` in CNA.NET was **empty**. Content arrived only through the
separate native `load_content` callback, which the C ABI delivers *after* `initialize`. So
`personTexture` was null and the sample died with nothing but an `NullReferenceException` message to
go on.

Fixed in `../cna-cs`: the XNA facade's `Initialize` now calls `LoadContent` through a once-guard,
and the native `load_content` callback goes through the same guard rather than straight to the
override. A game that does **not** call `base.Initialize()` — legal XNA — still loads exactly once,
at the native callback, as before.

The fix is in the XNA facade rather than in `CNA.Game`, deliberately. The lifecycle `CNA.Game`
presents is the C ABI's own, with the five callbacks delivered separately, and that is a coherent
contract for a CNA-first game. XNA's contract is a different one, and the facade is the layer that
owes it.

Pinned by `tests/CNA.Integration.Tests/XnaInitializeLoadsContentTests.cs`, two tests: one asserts
the order `Initialize.before-base -> LoadContent -> Initialize.after-base` and exactly one
`LoadContent` call; the other asserts that a game skipping `base.Initialize()` still loads exactly
once. Confirmed red with the fix reverted, green with it. Suites after the change: 622 framework,
225 XnaCompat, 210 native integration.

This one is likely to have been costing more than this sample. Any game using the documented
`base.Initialize()` pattern would have hit it.

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
b509da3d04de79e10f074a2481f6c1858d1f6814c36e750c505db6b57def667f  Content/Block.xnb
7e9cff8ab0f5a5bc0e06282bed455d7783d7425589fea564400243c70d4c6a72  Content/Person.xnb
a486ae1416ee2b0af0c2c19ad549012f3f42d5e4df522bfb62304651a0fcc7c7  RectangleCollision/Game1.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  RectangleCollision/Game.ico
3cd2cfcac93c3a0dcc5ceab63ad57e3b5afd0a1dcc722428e66c51031d79d0ed  RectangleCollision/GameThumbnail.png
aac8070bcccd38f8cb9ff5371fe376a4bb6eb2214742e9d3ccb885263df7ead7  RectangleCollision.htm
e78dd4e6e4c2a2261420c477e9bc5e8282e6eda617f64d4f02145472b2e3c9db  RectangleCollision/Program.cs
27e271b3af3905daba3ad79134e22eb2874e90ae6554da41c2a72f8f9a9593d1  RectangleCollision/Properties/AssemblyInfo.cs
a1b738992a1301fe489f83f9e482a92a4b1860715ff68fd5c1a9e23292385cf8  RectangleCollision/RectangleCollisionWindows.csproj
ecbe9c240592149d32a163adfcb20e9077dac0c31b3ffe38e47527fb65d9db85  RectangleCollision/RectangleCollisionXbox.csproj
```

## Content provenance

`Block.xnb` and `Person.xnb` copied byte-for-byte from
`../cna-samples/samples/RectangleCollision/Content/`. Both begin `XNBw`, the XNA container magic
for Windows. Unlike `CSSAMPLE-002`, this port does ship the compiled content, so the usual source
was the right one.

## Native verification

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled
`Rectangle Collision`, exiting 0 on Escape.

## Comparison with the C++ port

| | C# on CNA.NET | C++ port |
|---|---:|---:|
| pure-white pixels (the person sprite) | 30 | 30 |
| person sprite bounding box | x 357..362, y 405..411 | x 356..361, y 404..410 |
| pure-black pixels (falling blocks) | 726 | 2 924 |
| distinct colours | 7 | 15 |

The block counts differ because they should: `Game1.cs:48` constructs `new Random()` with a
time-based seed and `Game1.cs:139` spawns a block per frame with a probability, so how many are on
screen depends on the seed and on how long the run had been going when the frame was caught. The
same non-determinism as `CSSAMPLE-001`'s star field.

The person sprite is the deterministic anchor, and it agrees on size exactly — 30 pure-white
pixels in both — but sits **one pixel left and one pixel up** in the C++ port.

That one-pixel offset is recorded as an open difference rather than explained away. Nothing here
establishes which of the two is right: the sample computes `personPosition` from
`Viewport.Width/Height` and the texture size with integer arithmetic, so both engines should agree,
and the residue is small enough to come from the sprite-batch pixel-centre convention, the safe-area
rounding, or the capture. Settling it needs a comparison against the real XNA original, which
`../cna-samples`' `SAMPLE-019` audit has and this row does not.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **Collision behaviour.** The sample's point is that the person is blocked by falling blocks; only
  a static frame was captured, and driving the arrow keys through a collision needs an interaction
  harness the capture script does not yet have.
- **Gamepad.** Present in the source, no controller attached; Escape was exercised.

## Artifacts

```text
/rv/tmp/cs-samples/CSSAMPLE-019-RectangleCollision/evidence/
├── release/          window capture, run log, window geometry, sha256
└── cpp-reference.png the C++ port through the same route
```
