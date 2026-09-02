# SafeArea audit — CSSAMPLE-011

## Result

**The original C# runs unmodified.** It renders **pixel-for-pixel identically to the C++ port** at 1280x720: 0 differing pixels of 921 600. No `../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SafeAreaSample_4_0` |
| Project | `SafeArea/SafeAreaWindows.csproj` |
| Configuration | `Release|x86` and `Debug|x86`, Windows, Reach |
| Entry point | `SafeArea.Program` |
| Assembly name | `SafeArea` |
| Content | `Background.xnb`, `Cat.xnb`, `Font.xnb` |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, built 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
b06e132d41a5d8192d7e948580a81d8787acbe14153685cf17197b97de5c8d74  SafeArea/AlignedSpriteBatch.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  SafeArea/Game.ico
385e2408c6560fd2d475cedfa7660eb41a20e99573ca223c3d13ce79671bc669  SafeArea.htm
6bcf5cc685b0500a94a876d61c1c3c155094a4718298095572c268722bc5872f  SafeArea/Properties/AssemblyInfo.cs
b0d68ba774fee930c879ecb7157a26f555cb76e7be9b8281aea1fc21701e64a5  SafeArea/SafeAreaGame.cs
d2466e2f11696b09ce2dfc49e3dad8d6eec54fb87976dddbc3bc9d55defa1de6  SafeArea/SafeAreaOverlay.cs
1e80b5453c2c8cd59e3ebbf97e091271d0db4386358bfa2b44d335ebbf7c73c7  SafeArea/SafeArea.png
2883287d728cf15d4a5f6ad70688365a9a98ce55945166a5e909376db7319806  SafeArea/SafeAreaWindows.csproj
405673b5a3c390d724ba652ca451701885a36f426bdf269f2d175e70222ab14c  SafeArea/SafeAreaXbox.csproj
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in a **1280x720** window titled
`Safe Area Sample`, exiting 0 on Escape. Against the C++ port through the same route:
**0 differing pixels of 921 600**, 71 708 distinct colours in both.

### A capture bug this row exposed

The first comparison reported a size mismatch, `(1180, 720)` against `(1280, 720)`. The sample's
window is 1280 wide and `scripts/capture-sample.sh` ran Xvfb at 1280x1024 with the window moved to
x=100, so 100 pixels fell off the right edge and the crop silently returned a narrower image.

The screen is now 1920x1200. Recorded because this is the second harness bug in one session that
would have produced a wrong number rather than an error — `CSSAMPLE-079`'s was the first. A
comparison that cannot fail loudly has to be checked for silently failing instead.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The title-safe overlay's interactive modes.** Only the default frame was captured.
- **Gamepad.** No controller attached; Escape was exercised.

## Artifacts

`/rv/tmp/cs-samples/SafeArea/evidence/` — `release/` and `cpp-reference.png`.
