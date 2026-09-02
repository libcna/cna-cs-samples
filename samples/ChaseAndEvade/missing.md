# ChaseAndEvade audit — CSSAMPLE-025

## Result

**The original C# runs unmodified.** No `../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ChaseAndEvadeSample_4_0` |
| Project | `ChaseAndEvade/ChaseAndEvadeWindows.csproj` |
| Configuration | `Release|x86` and `Debug|x86`, Windows, Reach |
| Entry point | `ChaseAndEvade.Program` |
| Assembly name | `ChaseAndEvade` |
| Content | 4 official pipeline XNBs |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, built 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
5a2a4bcf04fc8b38b3c5d0f3265d8c4ef97bff7294d312c0d01c78c505898dce  ChaseAndEvade/App.config
474479c25c5a295a52c5de89c10ab3fe680487125c4b20a4101c9c259a19b0e3  ChaseAndEvade/ChaseAndEvadeGame.cs
9dbecab6aef00655e032fd7462f1e453f01165794c331e1056130ae380d96d32  ChaseAndEvade/ChaseAndEvadeWindows.csproj
7441d5d560e7a54d8bf77d631379903f43379c17959d1a2202ca932519237770  ChaseAndEvade/ChaseAndEvadeWindowsPhone.csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  ChaseAndEvade/Game.ico
2fd8ec357c89d9569c0ee257fa2a7af4afeba8f744e4a64d63f8dae389c1e8d0  ChaseAndEvade/GameThumbnail.png
e3ab65dc1db8a5e6383b42f8f39d16bb9245a75c6f6fa271e00c136f27331a39  ChaseAndEvade.htm
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  ChaseAndEvade/Properties/AppManifest.xml
3f17f78e4e29047e82f62bfe2e51d146ef246f7bc848b10cadc0b21a791e5a46  ChaseAndEvade/Properties/AssemblyInfo.cs
4d387be765290d6fc3d7bd3af177bb30a30b53f63ce94e829113eb2cac839e65  ChaseAndEvade/Properties/WindowsPhoneManifest.xml
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 853x480 window titled
`ChaseAndEvade`, exiting 0 on Escape.

Against the C++ port: 8 096 distinct colours here, and **3 770 differing pixels of 409 440**. The
sample's three agents chase, evade and wander from a `Random` seeded in `ChaseAndEvadeGame.cs`, so
their positions are not comparable between runs — the same non-determinism as `CSSAMPLE-001` and
`CSSAMPLE-019`. The difference is under 1 % of the frame and confined to the moving sprites.

The sample's `#if WINDOWS_PHONE` branches at `ChaseAndEvadeGame.cs:140` and `:630` are correctly
inactive: this row builds the Windows configuration, which defines `WINDOWS`.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The chase and evade behaviours over time.** Only a single frame was compared.
- **Gamepad.** No controller attached; Escape was exercised.

## Artifacts

`/rv/tmp/cs-samples/ChaseAndEvade/evidence/` — `release/` and `cpp-reference.png`.
