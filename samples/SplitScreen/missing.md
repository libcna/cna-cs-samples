# SplitScreen audit — CSSAMPLE-076 ✅

## Result

**The original C# runs unmodified.** The Windows project's sources, verbatim, build in Debug and
Release with no warnings, draw the tank `Model` into two viewports with their own cameras, and exit
0 on Escape. Against the C++ port the frame differs by 4.84% (18 601 px at 2% fuzz): the same two
views at another moment of the time-driven tank animation.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SplitScreenSample_4_0` |
| Project | `SplitScreenSample/SplitScreenSample/SplitScreenSample (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `SplitScreenSample.Program` |
| Assembly name | `SplitScreenSample` |
| Content | `tank.xnb` and its two textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
38d7551cefed44c92d65ecb6fd7f710d3228e1b3241e5ce594bdef3d10e3f835  SplitScreenSample/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  SplitScreenSample/Game.ico
5d126d303f95181f6d3c762395c3e5ea900ef7c65f040f727224c90858a265bd  SplitScreenSample/GameThumbnail.png
d19a1771e8af5d408151792a2d4509f3d502f13fec77a168eb900d533f8da2a2  SplitScreenSample.htm
ef6deb84d365606f30b5e9e33f0c5cb705b4caffc3b823174947df560c40d4d2  SplitScreenSample/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  SplitScreenSample/Properties/AppManifest.xml
ee4dd1404e5053baa67e76303178edee52f64991b70e823dcb24b905463a6c99  SplitScreenSample/Properties/AssemblyInfo.cs
9737094274ba7e4c8478bfdb6681937424a4d7ff9a75956306a16b0032aedab1  SplitScreenSample/Properties/WMAppManifest.xml
fb087cd97246071a25fa21ac4d5b3344751a3b0bf4b4ff4f78d78ab30fcf5447  SplitScreenSample/SplitScreenGame.cs
efaf25f4173891d3887113c9609805d4bc8acbd3f7a1c10a6364440e073da827  SplitScreenSample/SplitScreenSample (Phone).csproj
7760baf9601939ff719eaf4969eaedc9b6b9bf12c8ba42217fdd84c93c503f3c  SplitScreenSample/SplitScreenSample (Windows).csproj
7f8dabd6f5d6dbc6890d64987b941bd643f0d63769c3145c9b63025ab58d0dea  SplitScreenSample/SplitScreenSample (Xbox).csproj
2102f8fd26c6f5c449662dc5d4946c631586c1440ce9f44c2c378b54fe78f15c  SplitScreenSample/Tank.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; runs against CNA.NET
`8fcd961`, CNA `80572aa00` (`build-probe`, Release OPENGLES3, compiled
effects) on a private Xvfb in an 800x480 window; Escape exits 0.

## Artifacts

`/rv/tmp/cs-samples/cssample-076/SplitScreen/` (C# capture and logs) and `.../cpp/` (the C++ port).
