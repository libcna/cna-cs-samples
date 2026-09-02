# CNA.NET Samples — engineering history

Newest first. Each entry says what actually happened, what was measured, and what the next session
inherits.

---

## Active handoff — 2026-09-02

### Work on next

`CSSAMPLE-001` PrimitivesSample, the first row of Tier 1. **The owner has authorised exactly one
sample.** Do not start `CSSAMPLE-008` or any other row until the owner has reviewed the first one
and said to continue.

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

### Open items

- `CSINFRA-003`, `004` and `005` — the content-provenance, verbatim-source and eligibility
  checkers — are specified in `plan.md` but not written. Until then, both properties are verified
  by hand per sample and recorded in that sample's `missing.md`.
- No browser gate exists here and none is planned; `../cna-samples` remains the only repository
  making a WEBGL2 claim.
