# ColorReplacement audit — CSSAMPLE-028 ⛔

## Result

**Blocked by a CNA defect below the C ABI.** The original C# is checked in verbatim, builds with
0 warnings and 0 errors in both configurations, loads all four official XNBs including the compiled
`ReplaceColor` effect, and renders its **first** frame. The second frame throws, and the cause is
`CNA-REPORT-002`: destroying the technique view the C ABI documents as owned invalidates the
effect's real technique.

Nothing about this row is a source deviation or a binding gap. The project is in
`CnaCsSamples.sln` and builds clean; only the run is blocked.

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

**None** in any `.cs` file; `diff -r` over the code is clean.

**One omission, by policy:** the upstream project's own `Content/` subdirectory is not checked in.
It holds the Content Pipeline's *inputs*, not its outputs:

| file | size |
|---|---:|
| `Car.tga` | 16 777 260 |
| `Car.x` | 1 884 939 |
| `ColorReplacementContent.contentproj` | 5 428 |
| `ReplaceColor.fx` | 2 481 |
| `SpriteFont.spritefont` | 1 592 |

18 MB of assets for a pipeline this repository does not run, and `rules.md` excludes exactly these.
The compiled output is checked in instead, under `samples/ColorReplacement/Content/`, copied
byte-for-byte from `../cna-samples/samples/ColorReplacement/Content/` — all four begin `XNBw`. The
upstream directory retains the sources.

## Two things that had to be got right before the real defect appeared

### The native library needs `CNA_EASYGL_COMPILED_EFFECTS=ON`

The first run failed with:

```text
'ReplaceColor': EffectReader could not create the compiled effect ---> The active graphics renderer
does not support compiled XNA/FNA Effect Framework bytecode (GraphicsCapability::CompiledEffects is false)
```

That is **not** a CNA defect. `../cnanext/cmake-build-release-capi` — Release, `OPENGLES3`, and the
tree the first three rows used — is configured `CNA_EASYGL_COMPILED_EFFECTS=OFF`. XNA samples ship
compiled `.fx` bytecode inside their `.xnb` files, so renderer and build type are not enough to
choose a library. `cmake-build-debug` has it ON, and `scripts/build-native-cna.sh` now requires it
when selecting a tree and passes it when configuring one.

### `Main` is in a `Program` class inside `Game.cs`

Third distinct location in five rows. Nothing to do but read it.

## Blocked on CNA — see `cna-bugs.md` `CNA-REPORT-002`

With compiled effects available, the sample loads everything and draws frame 1. Frame 2:

```text
CNA.CnaException: cna_game_run failed with native result Callback: Passes failed with native
result InvalidHandle: The EffectTechnique handle is invalid for this call.
```

`ModelMesh.Draw` destroys the technique and pass-collection views each frame, which the C ABI
header says it may — both are documented as owned views with their own `*_destroy` entry points.
Destroying either one invalidates the effect's real technique, so the second frame has nothing to
draw with.

Isolated by editing the binding three ways and re-running (the edits were reverted):

| disposed | result |
|---|---|
| technique + passes + each pass (as shipped) | frame 1 OK, frame 2 invalid **technique** |
| technique only | frame 1 OK, frame 2 invalid **technique** |
| pass collection and passes only | frame 1 OK, frame 2 invalid **pass collection** |
| nothing | 6 of 6 frames OK |

Reproduce with `scripts/repro-cna-report-002.sh`, which prints how many frames survived; the defect
is present when that number is 1.

**This blocks 32 of the 78 eligible rows** — every one that draws a `Model`. It is the campaign's
highest-value fix and the reason this row stops here rather than working around it.

## What was verified

- Sources verbatim; both configurations build 0/0.
- All four XNBs load, including the compiled effect and the model with its external texture.
- The window opens at 800x480 and renders one frame before the failure.

## Artifacts

```text
/rv/tmp/cs-samples/CSSAMPLE-028-ColorReplacement/evidence/release/run.log
/rv/tmp/cs-samples/CNA-REPORT-002/                                        (reproduction output)
```
