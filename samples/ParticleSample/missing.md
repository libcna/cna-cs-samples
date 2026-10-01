# ParticleSample audit — CSSAMPLE-029 ✅

## Result

**Runs.** The original C# is checked in verbatim, builds 0/0 in Debug and Release, runs on
OPENGLES3 and exits 0 through Escape. The scene is the C++ port's: same HUD, same effect, smoke
and explosions drawn the same way; the particles themselves are seeded from `Random`, so no two
captures agree pixel for pixel.

Blocked until 2026-10-01 by `CNA-REPORT-004` and a second defect behind it — a component's own
`Initialize` ran after its base had loaded content. Fixed in CNA `bdf239360` (CBIND-128) and
`6e0de68e8` (CBIND-129); see `cna-bugs.md`.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ParticleSample_4_0` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef (`<XnaProfile>` in the project, as upstream) |
| Content | official pipeline XNBs, copied from the C++ port |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

## What was verified

- Sources verbatim (`scripts/check-verbatim.sh`); every `.xnb` identical to the C++ port's
  (`scripts/check-content.sh`).
- Debug and Release build with 0 warnings and 0 errors.
- Runs against CNA.NET `496858b`, CNA `e9dd5d879` (`build-probe`, OPENGLES3 with compiled effects) on a private Xvfb; Escape exits with code 0.
- Compared with the C++ port captured through the same route (`scripts/requalify.sh`): 81.6% of pixels differ, nearly all of them smoke; the HUD text agrees at 800x480.
- That is what a randomly seeded particle field does: two C# captures differ from each other on
  85.2% of pixels, and two captures of the C++ port on 59.9%.

## Not verified

- Switching effects (A button, space bar, tap) was not driven; no interaction harness.

## Artifacts

```text
/rv/tmp/cs-samples/requal-20261001-cs496858b/ParticleSample/        C# capture, run and build logs
/rv/tmp/cs-samples/requal-20261001-cs496858b/ParticleSample/cpp/    the C++ port through the same route
```
