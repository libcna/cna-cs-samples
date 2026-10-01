# PathDrawing audit — CSSAMPLE-021 ✅

## Result

**Runs, and matches the C++ port exactly where both draw.** The original C# is checked in
verbatim and builds in its only upstream configuration, the phone one (`TRACE;WINDOWS_PHONE`), in
Debug and Release, 0/0. It runs on OPENGLES3.

The sample has no `Main` at all: the XAP host constructed `PathDrawingGame`. The project names it
(`<CnaPhoneGame>PathDrawing.PathDrawingGame</CnaPhoneGame>`) and `samples/Directory.Build.targets`
generates the stand-in host into `obj/` — nothing is added to the upstream tree.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/PathDrawing_4_0` |
| Solution | `PathDrawing.sln` — the only one upstream ships |
| Project | `PathDrawing/PathDrawing/PathDrawing.csproj` |
| Upstream configuration | `XnaPlatform=Windows Phone`, `DefineConstants TRACE;WINDOWS_PHONE` |
| Source files | `PathDrawingGame.cs`, `PrimitiveBatch.cs`, `Tank.cs`, `WaypointList.cs`, `Properties/AssemblyInfo.cs` |
| Content | `Font.xnb`, `ground.xnb`, `tank.xnb` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

## What was verified

- Sources verbatim (`scripts/check-verbatim.sh`); every `.xnb` identical to the C++ port's
  (`scripts/check-content.sh`).
- Debug and Release build with 0 warnings and 0 errors.
- Runs against CNA.NET `496858b`, CNA `e9dd5d879` (`build-probe`, OPENGLES3 with compiled effects) on a private Xvfb.
- Compared with the C++ port through the same route. That capture is drawn offset by the 100-pixel
  window position the capture script moves windows to (all retained C++ phone ports do this, the
  C# runs do not); over the 700x380 region both show, 0 pixels differ.

## Not verified

- Exit. The sample exits through Back only and no controller is attached; the run was ended by
  SIGTERM, which CNA.NET turns into the game's own exit (CSX-084).
- Drawing a path (touch drag) was not driven; no interaction harness.

## Artifacts

```text
/rv/tmp/cs-samples/requal-20261001-phonehost/PathDrawing/        C# capture, run and build logs
/rv/tmp/cs-samples/requal-20261001-phonehost/PathDrawing/cpp/    the C++ port through the same route
```
