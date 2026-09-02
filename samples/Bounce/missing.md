# Bounce audit — CSSAMPLE-016 🛑

## Result

**Blocked, and the block needs an owner decision.** The sources are checked in verbatim and the
project file is here as the reproduction, but the row is not finished and the project is
deliberately **not** in `CnaCsSamples.sln`, so the solution still builds clean.

The original C# cannot compile against CNA.NET because it calls Windows Phone 7 SDK types outside
any `#if WINDOWS_PHONE` guard. That is not an XNA 4.0 gap, so `rules.md`'s "fix it in `../cna-cs`"
ladder does not apply on its own authority — filling it would expand what CNA.NET is.

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

## Blocker 1 — unguarded Windows Phone 7 SDK types

```text
samples/Bounce/Bounce/Accelerometer.cs(109,21): error CS0234: The type or namespace name 'Devices'
    does not exist in the namespace 'Microsoft' (are you missing an assembly reference?)
samples/Bounce/Bounce/Accelerometer.cs(109,65): error CS0234: ... (same line, second reference)
```

Two errors, both on one line. `Accelerometer.cs` guards its sensor field, its `ReadingChanged`
handler and its `Initialize` body with `#if WINDOWS_PHONE`, but `GetState()` does not:

```csharp
if (Microsoft.Devices.Environment.DeviceType == Microsoft.Devices.DeviceType.Device)
```

So the type is needed whether or not `WINDOWS_PHONE` is defined, and defining it only adds
`Microsoft.Devices.Sensors.Accelerometer`, `AccelerometerReadingEventArgs` and
`AccelerometerFailedException` to the requirement.

`Microsoft.Devices.Environment` and `Microsoft.Devices.DeviceType` live in `Microsoft.Phone.dll`,
and the sensor types in `Microsoft.Devices.Sensors.dll`. Both are **Windows Phone 7 SDK**
assemblies, not XNA 4.0 — the upstream project references them separately from its five
`Microsoft.Xna.Framework.*` references. CNA.NET has no `Microsoft.Devices` surface today.

## Blocker 2 — no entry point, and the original's own is broken

Independent of the first, and it will recur on every phone-only row. `Program.cs` compiles its
`Main` only under `#if WINDOWS || XBOX`, and that `Main` constructs `Game1` — **a class that does
not exist** in this sample; the game class is `BounceGame`. So:

- with `WINDOWS_PHONE` defined there is no `Main` at all, because the XAP host supplied the entry
  point;
- with `WINDOWS` defined instead, the code does not compile, and it would also switch every
  `#if WINDOWS_PHONE` branch in `BounceGame` to its desktop form, changing the sample.

`../cna-samples` met the same thing at `SAMPLE-037` RimLighting and linked its executable with a
generated entry point. Doing that here means adding a file outside the upstream subtree — a
recordable deviation rather than an edit, but a deviation, and it should be decided once for all
phone-only rows rather than per sample.

## How far this reaches

Measured across all 78 eligible rows: 9 upstream directories mention `Microsoft.Devices`, but in
most the reference sits inside a `#if WINDOWS_PHONE` region and disappears when the constant is
undefined. Reachable references, which is what actually blocks a build:

| Row | Upstream | Reachable refs | Note |
|---|---|---:|---|
| CSSAMPLE-016 | `BounceSample_4_0` | 1 | this row |
| CSSAMPLE-060 | `SoundAndMusicSample_4_0` | 1 | in the game class, not a sensor wrapper |
| CSSAMPLE-061 | `MarbleMaze_4_0` | 34 | across the shipped game and its training copies |
| CSSAMPLE-067 | `CatapultWars_4_0` | 4 | in the `Source/EX*` training subtrees |
| CSSAMPLE-068 | `CatapultWarsTrainingKit_4_0` | 16 | seven products |
| CSSAMPLE-084 | `AccelerometerSample_4_0` | 2 | the same `Accelerometer.cs` plus its `Game.cs` |

`Platformer_4_0`, `CameraShake_4_0` and `SnowShovelSample_4_0` mention it but only inside guards, so
they are not affected.

## The decision

Three options, with what each costs:

1. **CNA.NET adds a minimal `Microsoft.Devices` compatibility surface** — `Environment.DeviceType`,
   `DeviceType`, `Sensors.Accelerometer` with its reading event args and failed exception. Bounded
   in size, and CNA already implements the sensor below the C ABI (`../cna-samples` `SAMPLE-084` is
   `✅` on the C++ side). The cost is scope: CNA.NET stops being only a
   `Microsoft.Xna.Framework` facade, and its strict metadata gate — 257/257 XNA types, 0 leaks,
   empty allowlist — needs a policy for surface that is deliberately not XNA.
2. **A samples-local shim** in this repository supplying those types to the affected projects only.
   Keeps CNA.NET pure, but it is this repository implementing a Microsoft SDK, which is what
   `rules.md`'s zero-workaround rule exists to prevent. Recorded as an option because it is real,
   not because it is recommended.
3. **Declare phone-only samples out of scope here.** They keep their C++ ports and this repository
   records the boundary. Cheapest, and it gives up six rows.

The entry-point question in Blocker 2 needs a ruling either way, because it applies to every
phone-only row whichever of the three is chosen.

## What was verified before stopping

- Sources copied verbatim; `diff -r` against the upstream project directory is clean.
- The build was actually attempted rather than reasoned about. With no platform constant defined,
  the compiler reports exactly the two errors above and nothing else — so `Microsoft.Devices` is the
  first and only thing standing between this sample and a build.
- `CnaCsSamples.sln` does not reference this project, and the solution builds with 0 warnings and
  0 errors.

## Artifacts

The sources and `Bounce.csproj` in this directory are the reproduction:

```bash
dotnet build samples/Bounce/Bounce.csproj -c Release
```
