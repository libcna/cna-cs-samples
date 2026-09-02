# FuzzyLogic audit — CSSAMPLE-027

## Result

**The original C# runs unmodified.** No `../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/FuzzyLogicSample_4_0` |
| Project | `FuzzyLogic/FuzzyLogic/FuzzyLogicWindows.csproj` |
| Configuration | `Release|x86` and `Debug|x86`, Windows, Reach |
| Entry point | `FuzzyLogic.Program` |
| Assembly name | `FuzzyLogic` |
| Content | `hudFont.xnb`, `Mouse.xnb`, `OnePixelWhite.xnb`, `Tank.xnb` |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
e03e05c032d3f53f8143260ea6e8b2c96f2e7e6776141e7ccac0fa27237a0d62  FuzzyLogic/Background.png
2db104ae8b69920d352a202285763e9791b3618b0e208e29d72becae5e290c7f  FuzzyLogic/Behaviors/Behavior.cs
ff85e13488d8b218c689384104f86204b46f32871e49f62feefecdd6d41ba2d2  FuzzyLogic/Behaviors/ChaseBehavior.cs
9686e0d6c5f77d9565bc4062d477bc023ffa9199acf7983a69a898acc93a548f  FuzzyLogic/Behaviors/EvadeBehavior.cs
283b42a5445e0041582062e0f5b1d68697a2069346266a91afafbc58e174bd68  FuzzyLogic/Behaviors/WanderBehavior.cs
e4ae90ed61aef9ae9e4fc6c3d0fe5ae7642aad60ac06aa3b9fefb61b1c425a33  FuzzyLogic/Entities/Entity.cs
8c3bed06d2f1f8730022d6ee4ad0c981aca6714127a28efb9556f1c94f5366a8  FuzzyLogic/Entities/Mouse.cs
238b48c380a93f740e38bd62e4c259493111754bcd6f66efe72806ad916b9acf  FuzzyLogic/Entities/Tank.cs
484f8c34bc25dfe7ef176e05dc7dfa87973adbba2aec424291c4b67885b69883  FuzzyLogic/FuzzyLogicGame.cs
1bf9a93a298394ee800c9fdb048b316708eb899ea4ae0b4953885fa697dbfd88  FuzzyLogic/FuzzyLogic (Phone).csproj
269628584d777b3d96319551770115f1f8fd6af1c264e8aa86aedcef77ffec4a  FuzzyLogic/FuzzyLogic (Windows).csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  FuzzyLogic/Game.ico
dff129b6571a729981a213db9f534e8ff3b3bb83213d3d41c432df39b7564faf  FuzzyLogic/GameThumbnail.png
aa10f1be13d35a48e6ecdd14779a98f3096cd8c5daf71bb4723a2445971f7a55  FuzzyLogic.htm
3686bdca73e022630b3c118d441e97d05994556cd5ba3d43151c9df9a2c51f5d  FuzzyLogic/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  FuzzyLogic/Properties/AppManifest.xml
a8de89df0129106d07fd51b868a2fabe46c9e28f12e55f0beac71d2f78e5f709  FuzzyLogic/Properties/AssemblyInfo.cs
ef4e31bb3a72dd038be01df4f5c1aff1b4e57f9bb4626b1d5f419781b3183d53  FuzzyLogic/Properties/WMAppManifest.xml
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled `FuzzyLogic`,
exiting 0 on Escape. 4 795 distinct colours.

Against the C++ port: 20 685 differing pixels of 384 000. The sample seeds a `Random` in
`Mouse.cs` and animates from `gameTime`, so its tanks and mice are in different places between
runs; the same non-determinism as `CSSAMPLE-001` and `CSSAMPLE-025`.

`Tank.xnb` is a **texture**, not a model, so `CNA-REPORT-002` does not apply.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The fuzzy-logic behaviour over time.** Only a single frame was compared.

## Artifacts

`/rv/tmp/cs-samples/FuzzyLogic/evidence/` — `release/` and `cpp-reference.png`.
