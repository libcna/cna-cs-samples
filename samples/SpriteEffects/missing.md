# SpriteEffects audit — CSSAMPLE-006 ✅

## Result

**Runs.** The original C# is checked in verbatim, builds 0/0 in Debug and Release, runs on
OPENGLES3 with its three compiled effects (`desaturate`, `disappear`, `normalmap`) and exits 0
through Escape. Its four panels animate on `GameTime`, so the comparison with the C++ port differs
only where the effects are at a different phase.

Until 2026-10-01 no OPENGLES3 library with compiled effects could be built; `build-probe` has them
now, and the shutdown crash once suspected there (`CNA-REPORT-003`) does not reproduce.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SpriteEffectsSample_4_0` |
| Solution | `SpriteEffects (Windows).sln` |
| Project | `SpriteEffects/SpriteEffectsWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `SpriteEffects.Program.Main`, a static `Program` class at the bottom of `SpriteEffects.cs` |
| Assembly name | `SpriteEffects` |
| Content | 8 official pipeline XNBs, three of them compiled effects: `desaturate`, `disappear`, `normalmap` |

The upstream project's own `Content/` subdirectory — `normalmap.fx`, `disappear.fx`,
`desaturate.fx`, `cat_depth.jpg`, `waterfall.jpg`, `glacier.jpg` and the rest — is excluded per
`rules.md`: those are pipeline inputs, and the compiled output is checked in instead.

## Source deviations

**None** in any `.cs` file. `diff -r` over the code is clean; the upstream `Content/` inputs
are excluded as pipeline sources (`rules.md`).

## What was verified

- Sources verbatim (`scripts/check-verbatim.sh`); every `.xnb` identical to the C++ port's
  (`scripts/check-content.sh`).
- Debug and Release build with 0 warnings and 0 errors.
- Runs against CNA.NET `496858b`, CNA `e9dd5d879` (`build-probe`, OPENGLES3 with compiled effects) on a private Xvfb; Escape exits with code 0.
- Compared with the C++ port captured through the same route (`scripts/requalify.sh`): 7.4% of pixels differ, inside the animated panels at 800x480.

## Not verified

- The panel switching keys were not driven; no interaction harness. Gamepad: no controller attached.

## Artifacts

```text
/rv/tmp/cs-samples/requal-20261001-cs496858b/SpriteEffects/        C# capture, run and build logs
/rv/tmp/cs-samples/requal-20261001-cs496858b/SpriteEffects/cpp/    the C++ port through the same route
```
