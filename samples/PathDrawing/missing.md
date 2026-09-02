# PathDrawing audit — CSSAMPLE-021 🛑

## Result

**Blocked on `DEC-001`'s entry-point question, in its purest form.** The sample has **no `Main` and
no `Program.cs` at all** — not even a guarded one.

The project is deliberately **not** in `CnaCsSamples.sln`.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/PathDrawing_4_0` |
| Solution | `PathDrawing.sln` — the only one upstream ships |
| Project | `PathDrawing/PathDrawing/PathDrawing.csproj` |
| Upstream configuration | `XnaPlatform=Windows Phone`, `DefineConstants TRACE;WINDOWS_PHONE` |
| Source files | `PathDrawingGame.cs`, `PrimitiveBatch.cs`, `Tank.cs`, `WaypointList.cs`, `Properties/AssemblyInfo.cs` |
| Content | `Font.xnb`, `ground.xnb`, `tank.xnb` |

## Why this is the sharpest case of the entry-point question

Three phone-only rows have now met `DEC-001`'s second half, and they form a ladder:

| Row | What upstream provides | Resolution |
|---|---|---|
| `CSSAMPLE-079` GesturesSample | `Main` guarded by `#if WINDOWS \|\| XBOX`, constructing a `Game1` that **exists** | ✅ — define `WINDOWS` in the project file, no source edit |
| `CSSAMPLE-016` Bounce | `Main` guarded the same way, constructing a `Game1` that **does not exist** | 🛑 — defining `WINDOWS` does not compile |
| `CSSAMPLE-021` PathDrawing | **no `Main` and no `Program.cs` at all** | 🛑 — there is nothing to enable |

For this row no constant helps, because there is no entry point to switch on. Running it means
**writing new code** — a `Program` class that constructs `PathDrawingGame` — which is what the XAP
host did on the phone and what `../cna-samples` supplied as a generated entry point for its own
`SAMPLE-021` and `SAMPLE-037`.

That is a file added beside the upstream subtree rather than an edit to it, so it is recoverable
under `rules.md` as a recorded deviation — but it is new authored code in a repository whose whole
premise is that there is none, and the same file would be needed for every row of this shape. It is
the owner's call, and it is the second half of `DEC-001` rather than a new decision.

`tank.xnb` here is a **texture**, not a model: the sample draws a top-down tank sprite with
`SpriteBatch`. `CNA-REPORT-002` does not apply.

## Source deviations

**None.** The upstream project directory is checked in verbatim; nothing has been added.

## What was verified

- Sources copied verbatim, `diff -r` clean.
- Content copied from `../cna-samples/samples/PathDrawing/Content/`, three official pipeline XNBs.
- The build fails only for the missing entry point:
  `CSC : error CS1555: Could not find 'PathDrawing.Program' specified for Main method`.

## Artifacts

```bash
dotnet build samples/PathDrawing/PathDrawing.csproj -c Release
```
