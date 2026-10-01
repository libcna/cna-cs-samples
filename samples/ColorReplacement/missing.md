# ColorReplacement audit — CSSAMPLE-028 ✅

## Result

**Runs.** The original C# is checked in verbatim, builds 0/0 in Debug and Release, loads all four
official XNBs including the compiled `ReplaceColor` effect, renders the car with its replaced body
colour, tyres and headlights, and exits 0 through Escape. The car spins on `TotalGameTime`, so the
comparison with the C++ port differs only at the model's edges.

Two defects stood in the way, both in `../cna-cs`:

- `CNA-REPORT-002` — `ModelMesh.Draw` disposed the effect's technique views each draw, so frame 2
  had nothing to draw with. Fixed in `5f6c212`.
- `CSX-083` — the tyres and headlights were missing. The device's managed state cache did not see
  that native `SpriteBatch.End` had applied `AlphaBlend`, so the sample's next
  `BlendState = BlendState.Opaque` was skipped as already set, and the tyre texels (alpha 0 in
  `Car_0`, whose alpha is the replacement mask) blended away. Fixed in `b48db04`, with a pixel test
  that reads CornflowerBlue without the fix.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ColorReplacementSample_4_0` |
| Solution | `ColorReplacement (Windows).sln` |
| Project | `ColorReplacement/ColorReplacementWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Original `DefineConstants` | `TRACE;WINDOWS` (Release), `DEBUG;TRACE;WINDOWS` (Debug) |
| Entry point | `ColorReplacement.Program.Main`, a static `Program` class at the bottom of `Game.cs` |
| Assembly name | `ColorReplacement` |
| Content | `Car.xnb`, `Car_0.xnb`, `ReplaceColor.xnb`, `SpriteFont.xnb` |

The Xbox solution is a platform variant and is not this row's target.

## Source deviations

**None** in any `.cs` file; `diff -r` over the code is clean. The upstream `Content/` inputs
(`Car.tga`, `Car.x`, `ReplaceColor.fx`, `SpriteFont.spritefont`) are excluded as pipeline sources.

## What was verified

- Sources verbatim (`scripts/check-verbatim.sh`); every `.xnb` identical to the C++ port's
  (`scripts/check-content.sh`).
- Debug and Release build with 0 warnings and 0 errors.
- Runs against CNA.NET `496858b`, CNA `e9dd5d879` (`build-probe`, OPENGLES3 with compiled effects) on a private Xvfb; Escape exits with code 0.
- Compared with the C++ port captured through the same route (`scripts/requalify.sh`): 3.0% of pixels differ, along the spinning model's silhouette at 800x480.

## Not verified

- The colour controls (hold R/G/B or X/A/B and press Up/Down) were not driven; no interaction
  harness. Gamepad: no controller attached.

## Artifacts

```text
/rv/tmp/cs-samples/requal-20261001-cs496858b/ColorReplacement/        C# capture, run and build logs
/rv/tmp/cs-samples/requal-20261001-cs496858b/ColorReplacement/cpp/    the C++ port through the same route
```
