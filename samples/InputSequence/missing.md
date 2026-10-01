# InputSequence audit — CSSAMPLE-010 ✅

## Result

**Runs, and matches the C++ port exactly.** The original C# is checked in verbatim, builds 0/0 in
Debug and Release, runs on OPENGLES3 and exits 0 through Escape. Its capture is pixel-identical to
the C++ port's.

Blocked until 2026-10-01 on `DEC-002`: line 22 of `Game.cs` is the template's
`using Microsoft.Xna.Framework.Net;`, and CNA.NET had no such namespace. The sample uses no type
from it. CNA.NET now provides the XNA Net surface backed by CNA (`../cna-cs` CSX-043), so the
using directive resolves and nothing else changes.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/InputSequenceSample_4_0` |
| Project | `InputSequenceSample/InputSequenceSampleWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `InputSequenceSample.Program.Main`, a static `Program` class in `Game.cs` |
| Assembly name | `InputSequenceSample` |
| Content | 15 official pipeline XNBs, copied from the C++ port |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

## What was verified

- Sources verbatim (`scripts/check-verbatim.sh`); every `.xnb` identical to the C++ port's
  (`scripts/check-content.sh`).
- Debug and Release build with 0 warnings and 0 errors.
- Runs against CNA.NET `496858b`, CNA `e9dd5d879` (`build-probe`, OPENGLES3 with compiled effects) on a private Xvfb; Escape exits with code 0.
- Compared with the C++ port captured through the same route (`scripts/requalify.sh`): 0 of 384 000
  pixels differ at 800x480.

## Not verified

- The input sequences themselves (the special moves the sample detects) were not driven; the capture
  script has no interaction harness. Gamepad: no controller attached.

## Artifacts

```text
/rv/tmp/cs-samples/requal-20261001-cs496858b/InputSequence/        C# capture, run and build logs
/rv/tmp/cs-samples/requal-20261001-cs496858b/InputSequence/cpp/    the C++ port through the same route
```
