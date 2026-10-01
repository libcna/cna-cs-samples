# Bounce audit — CSSAMPLE-016 ✅

## Result

**Runs, as the phone game it is.** The original C# is checked in verbatim and builds in its only
upstream configuration, the phone one (`TRACE;WINDOWS_PHONE`), in Debug and Release. It runs on
OPENGLES3 and exits 0 through Escape, which the sample maps together with Back.

Two things the phone supplied are supplied here, neither in the sample's source:

- **Its entry point.** The XAP host constructed the game; `Program.Main` is guarded
  `#if WINDOWS || XBOX`. The project names the game class (`<CnaPhoneGame>Bounce.Game1</CnaPhoneGame>`)
  and `samples/Directory.Build.targets` generates the stand-in host into `obj/`.
- **The Windows Phone device APIs.** `Accelerometer.cs` reaches `Microsoft.Devices` and
  `Microsoft.Devices.Sensors` (line 109 even outside its guards). `<CnaPhoneCompat>true</CnaPhoneCompat>`
  references CNA.NET's opt-in CNA.PhoneCompat. On the desktop `DeviceType` is `Emulator`, so the
  sample takes its own emulator path: the arrow keys tilt the table.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/BounceSample_4_0` |
| Solution | `Bounce (Phone).sln` — **the only one upstream ships** |
| Project | `Bounce/Bounce/Bounce.csproj` |
| Configuration | `Release\|x86`, `XnaPlatform=Windows Phone`, `XnaProfile=Reach`, `OutputType=Library`, packaged as `Bounce.xap` |
| Original `DefineConstants` | `TRACE;WINDOWS_PHONE` |
| Content | none — the sphere geometry is generated in code, and `BounceContent.contentproj` declares no items |

There is no Windows or Xbox product. This is a phone-only sample, which is what makes it the first
row to meet this boundary.

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

## Build warnings

One, in both configurations, from the original source against the phone API it targets:
`Accelerometer.cs(59,21): warning CS0618: 'Accelerometer.ReadingChanged' is obsolete: 'Use CurrentValueChanged.'`
— the Windows Phone 7.1 SDK marks it the same way.

## What was verified

- Sources verbatim (`scripts/check-verbatim.sh`). No content: the spheres are generated in code.
- Debug and Release build, 0 errors and the one warning above.
- Runs against CNA.NET `496858b`, CNA `e9dd5d879` (`build-probe`, OPENGLES3 with compiled effects) on a private Xvfb; Escape exits with code 0.
- Compared with the C++ port through the same route. That capture is drawn offset by the 100-pixel
  window position the capture script moves windows to (all retained C++ phone ports do this, the
  C# runs do not), so the comparison is over the 700x380 region both show: 15% of it differs, the
  balls' positions, which the sample randomizes.

## Not verified

- Tilting with the arrow keys was not driven; no interaction harness. No real accelerometer: the
  `Device` branch needs `DeviceType.Device`, which a desktop never reports.

## Artifacts

```text
/rv/tmp/cs-samples/requal-20261001-phonehost/Bounce/        C# capture, run and build logs
/rv/tmp/cs-samples/requal-20261001-phonehost/Bounce/cpp/    the C++ port through the same route
```
