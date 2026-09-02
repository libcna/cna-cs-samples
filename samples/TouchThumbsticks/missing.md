# TouchThumbsticks audit — CSSAMPLE-080

## Result

**The original C# runs unmodified.** A phone-only row on the `CSSAMPLE-079` rung of `DEC-001`: the guarded `Main` constructs `TouchThumbsticksGame`, which exists, and the only preprocessor directives in the sample are that one guard pair. Defining `WINDOWS` in the project file is the whole deviation; no `.cs` file is touched.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/TouchThumbsticksSample_4_0` |
| Project | `TouchThumbSticks/TouchThumbSticks/TouchThumbSticks (Phone).csproj` |
| Configuration | `Release|x86` and `Debug|x86`, phone-only; this build defines `WINDOWS` |
| Entry point | `TouchThumbsticks.Program` |
| Assembly name | `TouchThumbSticks` |
| Content | `alien.xnb`, `bullet.xnb`, `player1.xnb`, `thumbstick.xnb` |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
8f16c83ed1b42f1e21804400b818739740d235117e6b23e88a142068effc6ec3  TouchThumbSticks/Background.png
15a17d8f9c9937697f0b8ad8fb18b583c698c7bbfcd407353dfcefc6c04dc953  TouchThumbSticks/Bullet.cs
fd39be5d4cc8f397e4c99cc9544d0cd9e9d552891f751bbfacbef929cb4b2d74  TouchThumbSticks/EnemyShip.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  TouchThumbSticks/Game.ico
05738ea31d5e5273df377cf46d9886c85795cef57c004f142f3944435007b1d1  TouchThumbSticks/GameThumbnail.png
af4f49c740ac120322543331d81bbbf6e71f62e0eaefc3b96e12e900260d073c  TouchThumbSticks.htm
321a16f643b7b4536e70c21ba18d1c6eb6ba28b15fa9ecfa23fa6ddf0adda689  TouchThumbSticks/PlayerShip.cs
9eb8999a396b73090078d4ad63d88370df16c489452559ebe3928804d4c6b28b  TouchThumbSticks/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  TouchThumbSticks/Properties/AppManifest.xml
5745b767daea0f077dd2b40a1ac290993fd4fd34a9ba5bfcee8c395ad88ec990  TouchThumbSticks/Properties/AssemblyInfo.cs
769f05e86d6fc429bc8934b70a777a28db73e33b2dcb19afaf49dd950078bbae  TouchThumbSticks/Properties/WMAppManifest.xml
897005f1cc1e408331760eb42385f4b657c34bedb709e4da55ca1d36dcc76e69  TouchThumbSticks/Ship.cs
10276265721458c231eb85c7562a56c4900bcd6c568d9bb1da7f87f52c74b01d  TouchThumbSticks/TouchThumbsticksGame.cs
523bbe22697fc6529c94ad54ae5991921a1afd7e15102ad33b697dcf272fb1c5  TouchThumbSticks/TouchThumbSticks (Phone).csproj
4ba815d50c7c4ac48b6ada8bee00159a0ff099d584be9ab903583e76dfd37678  TouchThumbSticks/VirtualThumbsticks.cs
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled
`TouchThumbSticks`. **Escape does not exit** — as with `CSSAMPLE-079`, this is a phone sample with
no keyboard exit path, so the capture runs with `--no-exit-check`.

Against the C++ port: 1 233 differing pixels of 384 000, five distinct colours here. The sample
animates from `gameTime` and seeds a `Random`, so a single frame is not exactly comparable; the
residue is 0.3 % of the frame.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The thumbsticks themselves.** They are driven by touch, which the capture script cannot supply.
- **Exit.** No keyboard path exists; a controller Back was not available.

## Artifacts

`/rv/tmp/cs-samples/TouchThumbsticks/evidence/` — `release/` and `cpp-reference.png`.
