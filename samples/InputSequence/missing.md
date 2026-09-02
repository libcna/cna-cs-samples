# InputSequence audit — CSSAMPLE-010 🛑

## Result

**Blocked on an owner decision, `DEC-002`.** The original C# is checked in verbatim and everything
about the row is ready; it does not compile for one reason:

```text
samples/InputSequence/InputSequenceSample/Game.cs(22,31): error CS0234: The type or namespace name
'Net' does not exist in the namespace 'Microsoft.Xna.Framework'
```

Line 22 is `using Microsoft.Xna.Framework.Net;` — part of the boilerplate using-block the XNA
project template generates. **The sample uses no type from that namespace at all.**

The project is deliberately **not** in `CnaCsSamples.sln`, so the solution still builds clean.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/InputSequenceSample_4_0` |
| Project | `InputSequenceSample/InputSequenceSampleWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `InputSequenceSample.Program.Main`, a static `Program` class in `Game.cs` |
| Assembly name | `InputSequenceSample` |
| Content | 15 official pipeline XNBs, copied from the C++ port |

## Why this is a decision and not a fix

`Microsoft.Xna.Framework.Net` is **real XNA 4.0 surface**, so `rules.md`'s ladder points at
`../cna-cs` rather than at a source edit — unlike `CSSAMPLE-016`'s `Microsoft.Devices`, which is
Windows Phone SDK and outside XNA entirely.

But `Net` is the Xbox LIVE session subsystem: `NetworkSession`, `LocalNetworkGamer`,
`NetworkGamer`, `PacketReader`/`PacketWriter`, `AvailableNetworkSession` and the rest. Implementing
it is a large new subsystem, which `rules.md` says to stop and ask about rather than start.

CNA.NET already knows: `docs/xna-compatibility.md:188` records "GamerServices and networking/session
APIs need separate inventory". `GamerServices` and `Storage` are present; `Net` is not.

## The measurement that makes the decision cheap

Three of the 78 eligible rows mention the namespace, and they split in a way that matters:

| Row | Uses a `Net` **type**? | What it needs |
|---|---|---|
| `CSSAMPLE-010` InputSequence | **no** — boilerplate `using` only | the namespace to exist |
| `CSSAMPLE-038` ShadowMapping | **no** — boilerplate `using` only | the namespace to exist |
| `CSSAMPLE-081` PerformanceMeasuring | **yes** — `NetworkSession`, `LocalNetworkGamer`, `NetworkGamer`, `NetworkSessionType`, `PacketReader`, `PacketWriter` | real networking |

So declaring the namespace's XNA 4.0 public types, with no working implementation behind them,
unblocks two rows and is metadata work rather than a networking project. Only `CSSAMPLE-081` needs
the subsystem itself, and it is blocked by `CNA-REPORT-002` as well.

`CSSAMPLE-038` is blocked by `CNA-REPORT-002` too, so **`CSSAMPLE-010` is the only row where `Net`
is the sole obstacle.**

## Source deviations

**None.** `diff -r` against the upstream project directory is clean. The upstream project's own
`Content/` inputs (`.png` sources and `Font.spritefont`) are excluded per `rules.md`; the compiled
output is checked in.

## Artifacts

The sources and `InputSequence.csproj` are the reproduction:

```bash
dotnet build samples/InputSequence/InputSequence.csproj -c Release
```
