# Platformer audit — CSSAMPLE-013 ✅

## Result

**The original C# runs unmodified and matches the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings. The first frame differs by 0.97%; with Right held for two seconds both builds run the player to the same place (1.11%). The Windows game leaves on the gamepad's Back button only, as XNA's does; no key exits it.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/Platformer_4_0` |
| Project | `Platformer/Platformer/Platformer (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `Platformer.Program` |
| Assembly name | `Platformer` |
| Content | tiles, sprites, backgrounds, overlays, sounds, the music with its `.wma`, the font, and the three level files the game reads with `TitleContainer` (`Levels/*.txt`, identical to upstream) — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
2ecf476099c2ec2ca027fce704917661fd47cc6a43cf924fb0fae6d3d36871b0  Platformer/Accelerometer.cs
25f683b3aa3f4578764aeb14b98f6606468e31fbf395548c6e3d2d5549766d9b  Platformer/Animation.cs
f4beb91407317eeb7859d418cab4ed693711c3248160b649d0cfeccdc1eb3ead  Platformer/AnimationPlayer.cs
f14740633b98610455c7fc24ae2a7b126bcce41e9ec9a1486c59141f54380605  Platformer/Background.png
24f61b1fc1351ec5ac7a42278a6047f8e380da9a4def4e0e3eac6e30695446ef  Platformer/Circle.cs
2c10c91a6d80b8ed7b797ee92b9461cc95c94b2830f1812bf263385506a977e9  Platformer/Enemy.cs
4b28aefafc5cdcb2801b9c5a35e96b5fe19adae56759b4e9835c8fcb22f6c37a  Platformer/Game.ico
d4c0057c99489ea2f60c89aeff6fa722d159e5d2f7a29fd135132f1fcdbf9aa6  Platformer/GameThumbnail.png
cd67304a19a8471d345afb4295eec2832be99211511116fbbacfaa4d75ef750a  Platformer/Gem.cs
f6ea8e299d984d410af0ca1be8ccf4216277f8532047be474070141edb942b71  Platformer.htm
df98c441ba76f675335baf5f020d03d5b27d38f79019ae108d3bdc7ee7ef14a3  Platformer/Level.cs
31c867111dfb259b77881c6b5b8fff0c8290458b4a6a3e22cb65d5e038ed981b  Platformer/PlatformerGame.cs
5c37a2260599bb55e69a7ce09ecf76fe793e7d250251fd28d9d901e5339128c1  Platformer/Platformer (Phone).csproj
b9d7420c52950c6a46574468c0da07c27aa3e47a26cf4e96eb828e321706a387  Platformer/Platformer (Windows).csproj
082b9f2825cbe1f10825ab291e4d63b8237f50e32049e0432041775fc7f3c745  Platformer/Platformer (Xbox).csproj
06b1c6a5c4a00213c98df127f5c9eeb774299cb54b608eb04fb6781c2294c6f9  Platformer/Player.cs
6644ea01e6470f354c8e0de01a677842ae2356f75ac74a113333dc7e290651b1  Platformer/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Platformer/Properties/AppManifest.xml
2d0eaf927a4c53c4de97263bbd64ccf9350957b947191e4dc37c0cbeb260dd2b  Platformer/Properties/AssemblyInfo.cs
390c6ac3f7eef2e862b760e6875cc41d20ff9fe364109a45fbd325fd4bfe9fde  Platformer/Properties/WMAppManifest.xml
ac368a6da27b56e0a9973e444edbee9b27efd21391eaf0f738d5dede72632630  Platformer/RectangleExtensions.cs
296b8eb311227f37535c45f5cf79407f79b89ab81ad414259c7cf32fbef7d09a  Platformer/Tile.cs
d12c51e0a5c471471da48ab5c67c12a78683c529f15e4020347665d5878655fa  Platformer/TouchCollectionExtensions.cs
```

## What was verified

The first frame and a frame with Right held (`/rv/tmp/cs-samples/platformer-run/`) at 2% fuzz against the C++ port captured the same way. Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-59/Platformer/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
