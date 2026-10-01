# WaypointSample audit — CSSAMPLE-023 ✅

## Result

**Runs, and matches the C++ port exactly.** The original C# is checked in verbatim, builds 0/0 in
Debug and Release, runs on OPENGLES3 and exits 0 through Escape. Its capture is pixel-identical to
the C++ port's.

Blocked until 2026-10-01 by `CNA-REPORT-004` — `GraphicsDevice` was unreachable from
`DrawableGameComponent` callbacks, and this sample draws in components. Fixed in CNA `bdf239360`
(CBIND-128); see `cna-bugs.md`.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/WaypointSample_4_0` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef (`<XnaProfile>` in the project, as upstream) |
| Content | official pipeline XNBs, copied from the C++ port |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

## What was verified

- Sources verbatim (`scripts/check-verbatim.sh`); every `.xnb` identical to the C++ port's
  (`scripts/check-content.sh`).
- Debug and Release build with 0 warnings and 0 errors.
- Runs against CNA.NET `496858b`, CNA `e9dd5d879` (`build-probe`, OPENGLES3 with compiled effects) on a private Xvfb; Escape exits with code 0.
- Compared with the C++ port captured through the same route (`scripts/requalify.sh`): 0 of 409 440 pixels differ at 853x480.

## Not verified

- The waypoint controls (mouse/touch to place waypoints, the behaviour switch) were not driven;
  the capture script has no interaction harness. Gamepad: no controller attached.

## Artifacts

```text
/rv/tmp/cs-samples/requal-20261001-cs496858b/WaypointSample/        C# capture, run and build logs
/rv/tmp/cs-samples/requal-20261001-cs496858b/WaypointSample/cpp/    the C++ port through the same route
```
