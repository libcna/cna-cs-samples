# CNA.NET Samples — engineering history

Newest first. Each entry says what actually happened, what was measured, and what the next session
inherits.

---

## Active handoff — 2026-09-02 (second entry)

### Work on next

**Nothing, until the owner says so.** `CSSAMPLE-001` PrimitivesSample is complete and is the one
sample the owner authorised. `CSSAMPLE-008` ShapeRendering is next in Tier 1 when permission comes.

### Heads this session measured against

Recorded as history, not as a claim about today: `../cnanext` and `../cna-samples` are worked on by
other sessions and move independently. Re-read them at the start of a session rather than trusting
this table, and in particular re-check the C ABI generation against `../cna-cs`'s admission matrix
before treating a native load failure as a bug.

| Repository | Branch | Head when measured | Changed by this session? |
|---|---|---|---|
| `cna-cs-samples` | `develop` | this commit | yes |
| `../cna-cs` | `develop` | `67ac872` | yes — the `CSSAMPLE-001` `Clear(Color)` fix |
| `../cnanext` | `next` | `1caa45c84`, C ABI 0.21.0 | no, as the rules require |
| `../sharp-runtimenext` | `next` | `9cc96cd5` | no |
| `../cna-samples` | `develop` | `425d772` | no |

`../cnanext` had already advanced to `0eb5fc151` by the time this session pushed, through work that
is not ours. Nothing here was rebuilt against it.

### CSSAMPLE-001 PrimitivesSample — ✅

The original C# runs **unmodified**: `diff -r` against
`/rv/tmp/XNAGameStudio/Samples/PrimitivesSample_4_0/Primitives` reports no difference, both
configurations build with 0 warnings and 0 errors, and the sample renders its stars, ships and sun
at 853x480 on `OPENGLES3` and exits 0 on Escape.

Compared with the C++ port through the identical capture route, the two agree exactly on everything
deterministic — 273 pure-white pixels, 91 `Color.Gray` pixels, grey range 56..255, and the same
three white x-clusters at 90–110 (left ship), 397–456 (sun) and 743–763 (right ship). Only the total
differs (1,174 vs 1,191), because `CreateStars` seeds `new Random()` from the clock and the star
field is different every launch by design.

### The defect it found, and how it was found

The first run drew **nothing**. That is worth recording in full, because the method generalises:

1. The window was 853x480 and Escape exited cleanly, so the sample was alive and its own code was
   running.
2. The C++ port of the same sample, captured the same way on the same CNA build, drew 1,191 pixels.
   That put the defect above CNA and below the sample.
3. `../cna-cs-template` — a managed CNA.NET app — captured 963 distinct colours, so managed
   presentation and the X capture route were both fine.
4. A probe drove the sample's **own unmodified `PrimitiveBatch.cs`** and read the result back
   instead of screenshotting it. Into a `RenderTarget2D`: 20,219 pixels. Into the backbuffer: 0.
5. Four variants of the clear separated colour from depth, and named it exactly:
   `GraphicsDevice.Clear(Color)` selected `ClearOptions.Target` alone.

XNA and FNA both define the one-argument overload as `Target | DepthBuffer | Stencil` with
`Viewport.MaxDepth`; CNA's C++ layer already agreed (Task 928). The divergence was managed-side
only, which is exactly why the C++ port was unaffected. Fixed in `../cna-cs`, pinned by
`tests/CNA.Integration.Tests/ClearColorDepthTests.cs` — confirmed red with the fix reverted
(0 of 64 lit), green with it (64 of 64), and its target-only case stays dark so a pass is not
vacuous. `../cna-cs` suites after the fix: 622 framework, 225 XnaCompat, 208 native integration,
all passing.

### Techniques worth reusing

- **Read pixels back, do not screenshot, when locating a defect.** A `RenderTarget2D` plus
  `GetData`, or `GetBackBufferData`, answers "did it draw" without the window, the compositor or
  the capture route in the way. The probe area is `../cna-cs/build-probe/` — shared, gitignored,
  never per-ticket.
- **The C++ port is the discriminator.** Any sample here has a working port beside it; running both
  through the same capture route is what turns "it looks wrong" into "the defect is in the
  binding".
- **`SDL_VIDEODRIVER=x11` with `WAYLAND_DISPLAY` unset, and `Xvfb +extension GLX`.** Without the
  first, SDL opens the window on the developer's real Wayland session and the private display stays
  empty — the run looks fine and the capture is black. Without the second, GL never reaches the
  drawable. `scripts/capture-sample.sh` encodes both.
- **Crop the root window to the sample window's geometry.** `import -window <id>` on a GL window
  reads back black.

### Reported to CNA, not repaired

`CNA-REPORT-001`, recorded in full in the new [`cna-bugs.md`](cna-bugs.md) and indexed from
`plan.md`: the owner maximized the sample's window
and the 853x480 image stayed at the bottom-left. Established by measurement, not inspection — the
window forced to 1200x900 puts the content at x 3..852, y 420..898, which is the OpenGL
framebuffer origin.

The original cannot reach that state: XNA's `AllowUserResizing` defaults to false and the sample
never sets it, so the real window has no working maximize box. CNA's XNA `GraphicsDevice` builds
its `WindowDescription` without setting `resizable` and takes the platform default of `true`, so
every CNA game gets a resizable window. The binding places no pixels — `Present()` is a bare ABI
call, `ClientSizeChanged` only forwards an event — so this is not `../cna-cs`'s to fix and, per
`rules.md`, not this repository's either.

Worth knowing for whoever picks it up: the game-visible `Viewport.Width` after that resize was
about 640 in a 1200-wide window, and the C++ port's apparent difference in the same test is **not**
usable as evidence — its binary is from 2026-08-25 and statically linked against the CNA tree of
that date, a week behind the library used here. `scripts/repro-cna-report-001.sh` takes an
arbitrary executable and window name precisely so a rebuilt port can settle that.

`cna-bugs.md` is new and is where every below-the-ABI finding goes from now on: `rules.md` says
report and move on, and a finding scattered across three documents is a finding that gets lost.
Each record must separate what is established from what is not.

### Open items

- `CSINFRA-003`, `004` and `005` — the content-provenance, verbatim-source and eligibility checkers
  — remain unwritten. `CSSAMPLE-001` verified both properties by hand; a sample with content will
  need the first one for real.
- `../cna-cs/tests/CNA.Integration.Tests/RenderTargetClearTests.cs` documents itself as expected-RED
  against an upstream CNA defect. It passes now. Someone should close that blocker row with
  evidence rather than leave the comment claiming otherwise; it is `../cna-cs`'s to close, not this
  repository's.

---

## Handoff — 2026-09-02 (first entry: repository established)

### Work on next at the time

`CSSAMPLE-001` PrimitivesSample, the first row of Tier 1. **The owner has authorised exactly one
sample.**

### Synchronized heads

| Repository | Branch | Head |
|---|---|---|
| `cna-cs-samples` | `develop` | this commit |
| `../cna-cs` | `develop` | `859ecd5` |
| `../cnanext` | `next` | `1caa45c84` (read-only from here) |
| `../sharp-runtimenext` | `next` | `9cc96cd5` (read-only from here) |
| `../cna-samples` | `develop` | `425d772` (eligibility authority) |

### What this session established

The repository, its policy and its build infrastructure, plus a measured toolchain baseline taken
**before** any sample was attempted — so that the first failure has something to be compared
against.

- `../cna-samples/plan.md` has 80 `✅` rows out of 153. Two of them (`SAMPLE-004` StockEffects,
  `SAMPLE-015` TicTacToe) are owner-accepted non-port decisions with no C++ port behind them, so
  **78 rows and 85 runnable products** are eligible here. The derivation is in `plan.md`.
- The dependency chain lines up: `../cnanext`'s `abi.h` declares C ABI **0.21.0**, and CNA.NET's
  admission matrix on `develop` accepts exactly 0.21.0. That agreement is not permanent — CNA.NET
  retires a generation whenever it moves — so re-check it at the top of any session where a native
  load fails.
- `../cnanext/cmake-build-release-capi` already held a current Release `OPENGLES3` build of
  `libcna_c_api.so`. It was reused rather than rebuilt, per the openeggbert build rules.
- End-to-end proof that the stack runs before any sample depends on it: `../cna-cs-template`
  built Release against that library and completed its 60-frame smoke test under `xvfb-run` with
  exit 0, on EasyGL / OpenGL ES 3.2 (Mesa 25.0.7).

### Decisions worth knowing

- **The C# is the deliverable, so the project file absorbs the change.** `samples/Directory.Build.props`
  carries `net8.0`, `WinExe`, `ImplicitUsings=disable`, `Nullable=disable`,
  `GenerateAssemblyInfo=false` and `DefineConstants=WINDOWS`. Each of those replaces something the
  original Visual Studio 2010 project said, or switches off a modern default the 2010 code
  predates. A sample `.csproj` should then carry only its identity — name, namespace, entry point.
- **`GenerateAssemblyInfo=false` is not cosmetic.** Every sample ships
  `Properties/AssemblyInfo.cs`; the SDK's generated attributes would collide with it, and deleting
  the upstream file to avoid that would be a source deviation.
- **`AssemblyName` keeps the *original* project's name**, which is often not the sample directory's
  name (`PrimitivesSample/` builds `Primitives`). The `.csproj` file is named after the directory
  so the solution stays unambiguous; `scripts/run-sample.sh` therefore finds the executable by
  searching `bin/<cfg>/` rather than by guessing its name.
- **Deterministic runs are a launcher concern.** `cna-samples` could add a frame counter to a port;
  adding one here would be a fidelity deviation, because the original sample had none.

### Reported to CNA, not repaired

`CNA-REPORT-001`, recorded in full in the new [`cna-bugs.md`](cna-bugs.md) and indexed from
`plan.md`: the owner maximized the sample's window
and the 853x480 image stayed at the bottom-left. Established by measurement, not inspection — the
window forced to 1200x900 puts the content at x 3..852, y 420..898, which is the OpenGL
framebuffer origin.

The original cannot reach that state: XNA's `AllowUserResizing` defaults to false and the sample
never sets it, so the real window has no working maximize box. CNA's XNA `GraphicsDevice` builds
its `WindowDescription` without setting `resizable` and takes the platform default of `true`, so
every CNA game gets a resizable window. The binding places no pixels — `Present()` is a bare ABI
call, `ClientSizeChanged` only forwards an event — so this is not `../cna-cs`'s to fix and, per
`rules.md`, not this repository's either.

Worth knowing for whoever picks it up: the game-visible `Viewport.Width` after that resize was
about 640 in a 1200-wide window, and the C++ port's apparent difference in the same test is **not**
usable as evidence — its binary is from 2026-08-25 and statically linked against the CNA tree of
that date, a week behind the library used here. `scripts/repro-cna-report-001.sh` takes an
arbitrary executable and window name precisely so a rebuilt port can settle that.

`cna-bugs.md` is new and is where every below-the-ABI finding goes from now on: `rules.md` says
report and move on, and a finding scattered across three documents is a finding that gets lost.
Each record must separate what is established from what is not.

### Open items

- `CSINFRA-003`, `004` and `005` — the content-provenance, verbatim-source and eligibility
  checkers — are specified in `plan.md` but not written. Until then, both properties are verified
  by hand per sample and recorded in that sample's `missing.md`.
- No browser gate exists here and none is planned; `../cna-samples` remains the only repository
  making a WEBGL2 claim.
