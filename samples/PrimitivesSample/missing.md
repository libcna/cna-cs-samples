# PrimitivesSample audit — CSSAMPLE-001

## Result

**The original C# runs unmodified.** Every checked-in `.cs` file is byte-identical to
`/rv/tmp/XNAGameStudio/Samples/PrimitivesSample_4_0/`; there are no source deviations, and nothing
in the sample compensates for the binding or the runtime.

One real defect was found and fixed in `../cna-cs` on the way — see *Binding fix* below. Without
it, this sample rendered a completely black window.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/PrimitivesSample_4_0` |
| Solution | `Primitives (Windows).sln` |
| Project | `Primitives/PrimitivesWindows.csproj` |
| Configuration | `Release\|x86` (and `Debug\|x86`), `XnaPlatform=Windows`, `XnaProfile=Reach` |
| Original `DefineConstants` | `TRACE;WINDOWS` (Release), `DEBUG;TRACE;WINDOWS` (Debug) |
| Entry point | `PrimitivesSample.PrimitivesSampleGame.Main` |
| Assembly name | `Primitives` |
| Content | none — the sample draws everything procedurally |

`Primitives (Phone).sln` / `PrimitivesWindowsPhone.csproj` is the platform variant and is not this
row's target. Its `WINDOWS_PHONE` branch is present in the checked-in source, unbuilt, exactly as
upstream ships it.

## Source deviations

**None.** `diff -r` against the upstream project directory reports no differences:

```text
5a2a4bcf04fc8b38b3c5d0f3265d8c4ef97bff7294d312c0d01c78c505898dce  Primitives/App.config
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Primitives/Game.ico
807f9def5f258b4d7d17d93f9ea2e72801a9361cc0e184bd9a27b551dc736ea1  Primitives/GameThumbnail.png
91acf354d05573d3e715378bc83a2dbd533138be7ec1e323363c19a9ea261ba1  Primitives/PrimitiveBatch.cs
a815aea69c03dd99ce443e694261e4a59c87d5eb6c0379cdc454f47c496440d1  Primitives/PrimitivesSampleGame.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Primitives/Properties/AppManifest.xml
6819f7001cb9066c484a6b36f770e1d4be6368d0786a7cfe8e03ec7c3e812871  Primitives/Properties/AssemblyInfo.cs
619b3168024b663280209771d32d5b6d73c7d7ffe9f331ad4a9e6cf1e67c5a57  Primitives/Properties/WindowsPhoneManifest.xml
67737591ef879a54f99bbbd22519f4edef4eb69ac2f2d195b903f672ec0fd990  PrimitivesSample.htm
```

The two `.sln` files, `Microsoft Permissive License.rtf` and the empty `PrimitivesContent/`
content project are not checked in. They carry no runnable code, and `PrimitivesContent` declares
no content items at all. The upstream directory retains them.

### What the project file absorbs instead

Everything the original Visual Studio 2010 project stated that .NET 8 needs stated differently
lives in `PrimitivesSample.csproj` and `samples/Directory.Build.props`:

| Original project said | Here |
|---|---|
| `TargetFrameworkVersion v4.0`, `Client` profile | `TargetFramework net8.0` |
| `OutputType WinExe` | same, from the shared props |
| `RootNamespace`/`AssemblyName` `Primitives` | same, in this sample's `.csproj` |
| `DefineConstants TRACE;WINDOWS` | `WINDOWS` from the shared props; `TRACE` is a .NET SDK default |
| `Compile Include` of the three `.cs` files | the SDK's default glob, which selects exactly those three |
| implicit assembly attributes off (they were in `AssemblyInfo.cs`) | `GenerateAssemblyInfo=false` |
| XNA references, `XnaPlatform`, `XnaProfile`, `.xap`, thumbnail, icon | supplied or made meaningless by `CNA.XnaCompat` |

`ImplicitUsings` and `Nullable` are disabled repository-wide so the 2010 `using` lists stay
authoritative.

## Binding fix — `GraphicsDevice.Clear(Color)` did not clear depth

The faithful build compiled and ran on the first attempt, and drew **nothing**: an 853x480 window
with 0 non-black pixels, while the C++ port of the same sample drew 1,191 on the same CNA build.

`CNA.Framework.Graphics.GraphicsDevice.Clear(Color)` selected `CnaClearOptions.Target` alone, on a
documented but incorrect belief that XNA's one-argument overload is colour-only. XNA and FNA both
define it as `Clear(ClearOptions.Target | ClearOptions.DepthBuffer | ClearOptions.Stencil, color,
Viewport.MaxDepth, 0)` — FNA `src/Graphics/GraphicsDevice.cs:791`. CNA's own C++ layer already had
this right (`modules/graphics/src/Xna/GraphicsDevice.cpp:419`, Task 928, citing the same FNA line),
so the divergence existed only on the managed side. That is why the C++ port was unaffected.

The consequence is invisible until a game draws with depth testing on, which every XNA `Game` does
by default: the colour cleared every frame, so the device was plainly alive, while the depth buffer
kept whatever it was created with. Here that was 0 — the most hostile possible value under
`LessEqual` — so every star, ship and sun line was rejected from the very first frame.

Isolated with a probe under `../cna-cs/build-probe/primitives-batch/`, which drives the sample's own
unmodified `PrimitiveBatch.cs` and reads the result back instead of trusting a screenshot:

| Case | Non-black pixels |
|---|---:|
| `Clear(Color.Black)` then draw, into the **backbuffer** | 0 |
| `Clear(Target\|DepthBuffer\|Stencil, black, 1.0f, 0)` then the same draw | 20 219 |
| `Clear(Color.Black)` with `DepthStencilState.None` | 20 219 |
| depth-only clear, then `Clear(Color.Black)`, then the same draw | 20 219 |
| control: `Clear(Color.CornflowerBlue)` alone | 409 440 (the whole surface) |
| the same draw into a depth-less `RenderTarget2D` | 20 219 |

The last row is what made the defect legible: identical geometry, identical effect, visible on a
target with no depth buffer and invisible on one with.

Fixed in `../cna-cs` — `src/CNA.Framework/Graphics/GraphicsDevice.cs`. Passing the depth and
stencil bits is safe on a target that has neither: CNA's C++ `GraphicsDevice::Clear` asks each
attachment independently and masks the bits it cannot honour (GDI-050).

Pinned by `tests/CNA.Integration.Tests/ClearColorDepthTests.cs`, which pre-loads a depth-bearing
render target with a depth of 0, then compares three clears. It was confirmed to fail with the fix
reverted (`Clear(Color)` 0 of 64 lit) and to pass with it (64 of 64). Its third case — a
target-only clear, which must stay dark — is what stops a pass from being vacuous.

## Native verification

```bash
scripts/build-native-cna.sh          # reused ../cnanext/cmake-build-release-capi
dotnet build samples/PrimitivesSample/PrimitivesSample.csproj -c Release
scripts/capture-sample.sh PrimitivesSample --window '^Primitives$' --out <evidence>
```

Both configurations build with **0 warnings and 0 errors** and run on `OPENGLES3` (EasyGL, OpenGL
ES 3.2, Mesa 25.0.7 under Xvfb with `LIBGL_ALWAYS_SOFTWARE=1`).

| | Release | Debug |
|---|---:|---:|
| window | 853x480 "Primitives" | 853x480 "Primitives" |
| non-black pixels | 1 174 | 1 159 |
| pure white (ships + sun cross) | 273 | 276 |
| `Color.Gray` 128 (sun diagonals) | 91 | 84 |
| Escape → exit code | 0 | 0 |

The 853x480 client size is the original's `PreferredBackBufferWidth/Height`. Grey values span
56..254, which is `MinimumStarBrightness` to `MaximumStarBrightness` exclusive — exactly
`random.Next(56, 255)`.

## Comparison with the C++ port

`../cna-samples/samples/PrimitivesSample`, captured through the same Xvfb/crop route:

| | C# on CNA.NET | C++ port |
|---|---:|---:|
| pure-white pixels | 273 | 273 |
| `Color.Gray` pixels | 91 | 91 |
| grey range | 56..255 | 56..255 |
| white x-clusters | 90–110, 397–456, 743–763 | 90–110, 397–456, 743–763 |
| non-black total | 1 174 | 1 191 |

The three white clusters are the left ship at x=100 (±`ShipSizeX` 10), the sun cross at x=426
(±`SunSize` 30) and the right ship at x=753 — the original's own geometry, in both engines, to the
pixel column.

Only the non-black total differs, and it is expected to: `CreateStars` uses `new Random()` with a
time-based seed, so the star field is different on every launch by design. `../cna-samples`'
`SAMPLE-001` audit records the same non-determinism against the real XNA original (1,144 non-black
there, 1,169 for the C++ port).

## Not verified

- **No browser result.** There is no .NET route to CNA's WEBGL2 backend; `../cna-samples` remains
  the only repository making that claim for this sample.
- **Gamepad Back.** The original's second exit path,
  `GamePad.GetState(PlayerIndex.One).Buttons.Back`, is present in the source and compiles, but no
  controller was attached. Escape was exercised instead, and both are the same `this.Exit()` call.
- **The Windows Phone project.** Not this row's configuration; see above.

## Artifacts

```text
/rv/tmp/cs-samples/CSSAMPLE-001-PrimitivesSample/evidence/
├── cna-native-opengles3/        Release window capture, run log, window geometry, sha256
├── cna-native-opengles3-debug/  the same for Debug
└── primitives-cpp-reference.png the C++ port captured through the same route
```

The upstream snapshot and the original XNA reference build are not duplicated here; they are
retained by the C++ campaign at
`/rv/tmp/samples/SAMPLE-001-PrimitivesSample_4_0/xna4-original/`.
