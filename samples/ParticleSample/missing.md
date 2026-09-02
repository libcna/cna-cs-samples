# ParticleSample audit — CSSAMPLE-029 ⛔

## Result

**Blocked by `CNA-REPORT-004`.** The original C# is checked in verbatim and builds 0/0 in both
configurations. It cannot run because `GraphicsDevice` is unreachable from every
`DrawableGameComponent` callback, and this sample's work is done in components.

Observed symptom: **NullReferenceException inside a component callback**.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ParticleSample_4_0` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Content | official pipeline XNBs, copied from the C++ port |

## Why it is blocked

The sample adds `DrawableGameComponent` subclasses with `Components.Add`, which is the standard
XNA way to give a game self-drawing parts. Every callback such a component receives —
`Initialize`, `LoadContent`, `Update`, `Draw` — throws when it touches `GraphicsDevice`:

```text
cna_game_get_graphics_device failed with native result InvalidState:
The graphics device may be borrowed only during a game lifecycle callback.
```

Native does not treat its own component callbacks as lifecycle callbacks. The binding cannot work
around it: the ABI documents the device handle as valid only inside the callback that fetched it,
so no cache is legal, and the borrow itself is what is refused.

Reproduced in isolation by `../cna-cs/build-probe/drawable-component/`, which reports the device
from all four callbacks. Full write-up, including the blast radius and the false counterexample that
had to be checked, is `cna-bugs.md` `CNA-REPORT-004`.

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

## What was verified

- Sources verbatim; both configurations build with 0 warnings and 0 errors.
- The window opens and the failure is in the component path, not in content loading.

## Artifacts

`/rv/tmp/cs-samples/ParticleSample/evidence/release/run.log`
