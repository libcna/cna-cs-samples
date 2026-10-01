# ChaseCamera audit — CSSAMPLE-058 ✅

## Result

**The original C# runs unmodified and matches the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings; the first frame differs from the C++ port by 0.22% (888 px at 2% fuzz).

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ChaseCamera_4_0` |
| Project | `ChaseCamera/ChaseCameraWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `ChaseCameraSample.Program` |
| Assembly name | `ChaseCamera` |
| Content | the ship and its texture, the ground and checker, `gameFont.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
5a2a4bcf04fc8b38b3c5d0f3265d8c4ef97bff7294d312c0d01c78c505898dce  ChaseCamera/App.config
b176aeba78eb1c5c28d9ea370539c7d4f7283d7b04213ead61883acf37332996  ChaseCamera/ChaseCamera.cs
3fdaad2fd796152efdbb0f7716caa6ac0eb555436bbeaba236df495cc78e31ad  ChaseCamera/ChaseCameraGame.cs
7e283fade72a2c5ffa3c46f45348aa6ff467d3342ca95aced85acab1d2a8a327  ChaseCamera/ChaseCameraWindows.csproj
102a6ef88f2ef5842f3d7e3594478a74b9568a56ab50f743e9b8eb7de6b0c1f3  ChaseCamera/ChaseCameraWindowsPhone.csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  ChaseCamera/Game.ico
ba74c282f64107247b5ab8575fa557028d5da01ed8d51f9f02b5989f95957e63  ChaseCamera/GameThumbnail.png
24fb2feaf6e2f5cbe253f8a1c6c53a99e776ce8269f29e2eb0e8e2954f265ab8  ChaseCamera.htm
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  ChaseCamera/Properties/AppManifest.xml
dfc47ec592f5e96d05c0f4f8c6237791053d9b44703c04688a942d8f720e0968  ChaseCamera/Properties/AssemblyInfo.cs
a98ceb2d9e2d9a55e83f24799ff1a9032f8f320d8e5f0fcbecb4760c8af6d1db  ChaseCamera/Properties/WindowsPhoneManifest.xml
9ebf4c5df94cf5c6689de7a946baf0fef91bb66f2ca31036dce49b3337359fe1  ChaseCamera/Ship.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. Flying the ship was not driven. Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-3/ChaseCamera/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
