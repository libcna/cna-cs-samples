# AimingSample audit — CSSAMPLE-026

## Result

**The original C# runs unmodified, and renders pixel-for-pixel identically to the C++ port** —
0 differing pixels of 409 440, with the controls to show that is not an accident of timing. No
`../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/AimingSample_4_0` |
| Solution | `Aiming (Windows).sln` |
| Project | `Aiming/AimingWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Original `DefineConstants` | `TRACE;WINDOWS` (Release), `DEBUG;TRACE;WINDOWS` (Debug) |
| Entry point | `Aiming.Program.Main`, a static `Program` class at the bottom of `AimingGame.cs` |
| Assembly name | `Aiming` |
| Content | `cat.xnb`, `spotlight.xnb` |
| Native library | `cmake-build-release-capi` (see `CSSAMPLE-018` and `CNA-REPORT-003`) |

The sample directory is `AimingSample` to match the C++ port's; the assembly keeps the original's
`Aiming`. The Phone solution is a platform variant and is not this row's target.

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
2a847e6311f0eccc432505485f1d40e11ac76b57b0133960ae49227bc3cea7d9  Aiming/AimingGame.cs
4f872fe1c0a1c6eca0936051f60064409eafe0ac99e1c725705f6daa40963736  Aiming/AimingWindows.csproj
f12546c96cf538f1be6c656dcfd8be0ef78d1a10c8fd530b1caa5fe93ebe4f4c  Aiming/AimingWindowsPhone.csproj
5a2a4bcf04fc8b38b3c5d0f3265d8c4ef97bff7294d312c0d01c78c505898dce  Aiming/App.config
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Aiming/Game.ico
e51c9f4f9c051cbab6806ab5a07395f92610e40c59ce1bf3ecf8814a16c19cb8  Aiming/GameThumbnail.png
19d842b2ac72e31bb7a9b898a1ac5725bfa07a66059eacc42d0d6cd646d1977f  Aiming.htm
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Aiming/Properties/AppManifest.xml
17d606c61cbbf561ea1038aaa529fb2109f1d6a3e647fa3ff93226ca6a6bcd13  Aiming/Properties/AssemblyInfo.cs
68d34176acab76a4cd9e14ba9153ec59581d5b2a5818d113f9970d405e4d0f42  Aiming/Properties/WindowsPhoneManifest.xml
e4aab21ac7ae4ffabbba308502cc9e9a513fbf30560866f576e25aa45141d03d  Content/cat.xnb
0bcfb889b2bc3e9f2cb40dc63aa6b9228436de84fce525051425690faa711e00  Content/spotlight.xnb
```

## Native verification

Debug and Release both build 0/0 and run on `OPENGLES3` in an 853x480 window, exiting 0 on Escape.

## Comparison with the C++ port — frame-exact, and controlled

| comparison | differing pixels |
|---|---:|
| C# on CNA.NET vs the C++ port | **0** of 409 440 |
| C# run 1 vs C# run 2, same settle | 0 |
| C# settle 5 s vs settle 9 s | 0 |

Both engines produce 5 811 distinct colours and the same 346 067 black background pixels.

The two controls are what make the first row mean something. `CSSAMPLE-008` produced a 0 that was
true but nearly a false claim, because that sample's camera orbits and the capture is not frame-locked;
a repeat run there differed by 5 076 pixels. Here the repeat run and the longer settle both differ
by nothing, which establishes that the scene is **static without input** — the cat turns toward the
pointer and there is no pointer — so the frame is not a moment in an animation and the agreement is
frame-independent.

This is the first cross-engine match in the campaign that is exact and survives its own control.
Given the sample draws two textures through `SpriteBatch` with rotation and origin, it is also a
meaningful one: the rotation, origin and filtering paths agree to the bit.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The aiming behaviour itself.** The cat rotates to face the mouse or touch point, and no input
  was driven, which is precisely why the frame is static and comparable. Exercising it needs the
  interaction harness the capture script does not yet have.
- **Gamepad.** Present in the source, no controller attached; Escape was exercised.

## Artifacts

```text
/rv/tmp/cs-samples/CSSAMPLE-026-AimingSample/evidence/
├── release/          window capture, run log, window geometry, sha256
├── repeat/           a second run at the same settle -- the determinism control
├── settle9/          a third at a longer settle -- the animation control
└── cpp-reference.png the C++ port through the same route
```
