# ShapeRendering audit — CSSAMPLE-008

## Result

**The original C# runs unmodified.** Every checked-in file is byte-identical to
`/rv/tmp/XNAGameStudio/Samples/ShapeRenderingSample_4_0/`; there are no source deviations, and no
`../cna-cs` change was needed. Debug and Release both build with 0 warnings and 0 errors.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ShapeRenderingSample_4_0` |
| Solution | `ShapeRenderingSample (Windows).sln` |
| Project | `ShapeRenderingSample/ShapeRenderingSample (Windows).csproj` |
| Configuration | **`Debug\|x86`**, `XnaPlatform=Windows`, `XnaProfile=HiDef` |
| Original `DefineConstants` | `DEBUG;TRACE;WINDOWS` (Debug), `TRACE;WINDOWS` (Release) |
| Entry point | `ShapeRenderingSample.Program.Main` |
| Assembly name | `ShapeRenderingSample` |
| Content | none — the shapes are generated in code |

Debug is the configuration under test, and that is a property of the sample rather than a
preference. See the next section.

The Phone and Xbox solutions are platform variants and are not this row's target; their
conditional branches are present in the checked-in source exactly as upstream ships them.
`Background.png` is shipped in the upstream project directory but is not a `Content` item of the
Windows project, so nothing loads it. It is retained beside the sources.

## `[Conditional("DEBUG")]` — where C# needs nothing and the C++ port needed a macro

Every public method of `DebugShapeRenderer` carries `[Conditional("DEBUG")]`. The attribute elides
the **call sites**, so in a Release build the game draws nothing but its `CornflowerBlue` clear.
That is the original's behaviour, not a defect, and it is why this row is measured in Debug.

Nothing was needed to preserve it: the .NET SDK defines `DEBUG` for Debug configurations, and Roslyn
honours the attribute. Measured — Release really is empty:

| | distinct colours | non-background pixels |
|---|---:|---:|
| Debug | 6 | 5 998 |
| Release | 1 | 0 |

This is worth recording because the C++ port could not do it. `../cna-samples/samples/ShapeRendering`
had to define a sample-local `SHAPE_RENDERING_SAMPLE_DEBUG` and conditionally compile the original
call sites by hand, because C++ has no call-site-eliding attribute — and it could not simply use
`DEBUG`, which collides with CNA's own `LogLevel::DEBUG` token. Here the upstream source expresses
it directly and the project file says nothing about it.

## Source deviations

**None.** `diff -r` against the upstream project directory reports no differences.

```text
72fa8ce2f2d4f19baedccdcd038bd84bd07e72cec7bfde39d160d7b4e86f103b  ShapeRenderingSample/Background.png
c6113c0571ef1040e4e73d21db9390fac4a53f38ac3a28e49b0f0ae7c1e15cfa  ShapeRenderingSample/DebugShapeRenderer.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  ShapeRenderingSample/Game.ico
651979d3654821194d726826c1551d4794259162ce27442dc1646d60029e14c9  ShapeRenderingSample/GameThumbnail.png
7c684e93cb96d94485453d2df6f4306b961ed255c64a521534666627707e8dd4  ShapeRenderingSample.htm
fa8939cfb83cbce9521c37824286d707600d6e3496449879f7b042a93cb3cfbf  ShapeRenderingSample/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  ShapeRenderingSample/Properties/AppManifest.xml
2627ab9feb971237598b4b3d2c39e67e934041c5dd0293688ee53ed38bc30140  ShapeRenderingSample/Properties/AssemblyInfo.cs
4b77b5dcc4b7e8747b9546de663b0f1b10633dc0764072a7ffd89301527d042f  ShapeRenderingSample/Properties/WMAppManifest.xml
df611be4c016c26a8508ddac68db9ea70f14463ba2bb6645538d79d48a6c273e  ShapeRenderingSample/ShapeRenderingSampleGame.cs
6a4769ceae8de69f7b9f9335e97883b384aeb1b1662f14aa1f56ad73c1fc49df  ShapeRenderingSample/ShapeRenderingSample (Phone).csproj
9d29a7011464419f90421fde6943a60eaf5f826f415a7a109148b42161692e93  ShapeRenderingSample/ShapeRenderingSample (Windows).csproj
de8a34302ef071e7237a6ce9340f34fd4cf6605b0b33e7743ac631df11ba07f0  ShapeRenderingSample/ShapeRenderingSample (Xbox).csproj
```

The three upstream `.csproj` files and both phone manifests are checked in unchanged and unused:
they are part of the project directory, and removing them would itself be an edit to it.

The `.sln` files and the licence RTF are not checked in — no runnable code. The project file
supplies only `RootNamespace`, `AssemblyName` and `StartupObject`; everything else comes from
`samples/Directory.Build.props`.

## Native verification

Both configurations build clean and run on `OPENGLES3` (EasyGL, OpenGL ES 3.2, Mesa 25.0.7 under
Xvfb with `LIBGL_ALWAYS_SOFTWARE=1`), in an 800x480 window titled `ShapeRenderingSample`, exiting 0
on the original's Escape path.

The Debug frame contains the five shape colours the sample draws, on `CornflowerBlue`:

```text
(255,255,0) yellow   (255,0,0) red   (0,128,0) green   (128,0,128) purple   (165,42,42) brown
```

## Comparison with the C++ port

`../cna-samples/samples/ShapeRendering`, captured through the same Xvfb/crop route:

| | palette | non-background pixels |
|---|---|---:|
| C# on CNA.NET, run 1 | the five colours above | 5 998 |
| C# on CNA.NET, run 2 | the same five | 5 981 |
| C++ port | the same five | 5 998 |

**Run 1 and the C++ port are byte-identical: 0 differing pixels of 384 000.** That is a real result
and it is also partly luck, so it is stated with its limit: the sample's camera orbits from
`gameTime.TotalGameTime.TotalSeconds` (`ShapeRenderingSampleGame.cs:90`), and the capture is not
frame-locked, so which frame a run is caught on depends on start-up timing.

The check that establishes this rather than a coincidence: a **second** C# run at the same settle
differs from the first by 5 076 pixels — and from the C++ port by exactly 5 076 as well. Two
independent runs of the *same* build differ by the same amount as a cross-engine pair, which is what
a frame offset looks like and is not what an engine difference looks like. The honest claim is
therefore:

> When both engines land on the same game-time frame, they produce identical pixels. The residual
> between runs is the frame the capture caught, not a rendering difference.

Frame-locking the comparison would need a deterministic-frame mode, which the original sample does
not have and which `rules.md` forbids adding to its source.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **`XnaProfile=HiDef`.** The original project embeds an XNA runtime-profile resource that has no
  .NET 8 equivalent, and the sample never sets `GraphicsDeviceManager.GraphicsProfile` in code, so
  this build does not request HiDef. Nothing here needs it — the sample draws `LineList` primitives
  through `BasicEffect`, which Reach supports — but a sample that does need HiDef will have to
  establish how the profile is selected. Recorded now so that row does not rediscover it.
- **Gamepad Back.** Present in the source and compiled; no controller attached. Escape was
  exercised and both reach the same `Exit()`.

## Artifacts

```text
/rv/tmp/cs-samples/CSSAMPLE-008-ShapeRendering/evidence/
├── debug/           Debug capture, run log, window geometry, sha256
├── debug-repeat/    a second Debug run at the same settle -- the frame-offset control
├── debug-settle9/   a third at a longer settle, which establishes that the scene animates
├── release/         Release capture: the clear alone, proving the Conditional elision
└── cpp-reference.png the C++ port through the same route
```
