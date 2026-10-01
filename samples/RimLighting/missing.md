# RimLighting audit — CSSAMPLE-037 ✅

## Result

**Runs, as the phone game it is, matching the original.** Upstream ships only the phone project; its sources are checked in verbatim and build in Debug and Release. The first frame is **1 554 px of 384 000 (0.40%)** from the original XNA game's start frame and 3 393 px (0.88%) from the C++ port's (`SAMPLE-037` evidence). The retained C++ phone binary asks for full screen, which a bare Xvfb cannot grant (SDL: "no window becoming fullscreen"), so its requalify capture is black; the comparison is against the C++ campaign's own start frame instead.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/RimLighting_4_0` |
| Project | `RimLighting/RimLighting/RimLighting.csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `RimLighting.SampleGame` |
| Assembly name | `RimLighting` |
| Content | the head model and its texture, the environment cube, `blankTex.xnb` and the font — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
942c3d2f2efab9b1fa085ce35f992a0031c062fbf67602070dae24fc7aeebb5d  RimLighting/Background.png
a4e66f8bf38c5d76c9e1155af0ece95e4476c62a45b2ff4411bdca8d90cc7915  RimLighting/Camera/Arcball.cs
92bea1db7c29683a11554d0a80a3a17633e383a83ea96248d79154d15d7af15d  RimLighting/Camera/ModelViewerCamera.cs
3c9d1262daeca30837776503c4604ecb28a03cd9a192f669a4e5477f878fc060  RimLighting/Game1.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  RimLighting/Game.ico
272d9b44681d15c53c0339701d36972a25d36ec3a841a1610870d8138435885a  RimLighting/GameThumbnail.png
1eeb1f347de762de6e475097caeb76c32d1df56ed679b529e31083cbebc475e0  RimLighting.htm
724bc53255b431880e63fd1f2bdf39689127f838fd3c7c8dfc13242a1862103e  RimLighting/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  RimLighting/Properties/AppManifest.xml
a99332325a7e95ded23995a82aeb6e56b9037e1579569cf20c4fb713e124c509  RimLighting/Properties/AssemblyInfo.cs
c3fadc60f10a6875f0e74eb8fca2b1707dcf56d225287383db59a618ec88ed3b  RimLighting/Properties/WMAppManifest.xml
bbdb8615ea12c8b11180e3d817b20c6dab6fcac7166e7027a8395ca2a0e652e7  RimLighting/RimLighting.csproj
339024c2078ddf88fb58de8feb0569e4afb4e1bca597bebe53a70d375273d6c8  RimLighting/UI/Button.cs
0f09ee222e735d6324dad80febdd3ee3049c7a89e176f9073954003862bb80ad  RimLighting/UI/Slidebar.cs
ada5e0d90586a341286502b1988cf38564bbe96a662989a6d37365e5cea8f6a4  RimLighting/UI/UIElement.cs
```

## What was verified

The first frame at 2% fuzz against `xna-original/rl-xna-1-start.png` and `cna-native-opengles3/rl-cna-1-start.png` under `/rv/tmp/samples/SAMPLE-037-RimLighting_4_0/evidence/`. Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/RimLighting/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
