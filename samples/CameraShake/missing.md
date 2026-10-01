# CameraShake audit — CSSAMPLE-030 ✅

## Result

**The original C# runs unmodified and matches the C++ port.** The Windows project's sources, verbatim, build in Debug and Release with no warnings; the first frame differs from the C++ port by 0.27% (1 018 px at 2% fuzz).

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/CameraShake_4_0` |
| Project | `CameraShake/CameraShake/CameraShake (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `CameraShake.Program` |
| Assembly name | `CameraShake` |
| Content | the tank and its two textures, `Ground.xnb`, `Checker_0.xnb`, `Font.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
f919a247754bf2063fb22bd590b7a64c227d75a3176110d8abce5944ef7b9001  CameraShake/Background.png
d4a43f64e662d543e151530af9977c52bbb952d77455063f7476a69fe524aa5a  CameraShake/Camera.cs
c885f85597cb1b35f699b0e47719dbc89d1a8cce3ad90b03c5d6bbd7de1032a5  CameraShake/CameraShakeGame.cs
e5485064e83bc075579b411d27f6669be87de8c4717df58eefb11da315a13054  CameraShake/CameraShake (Phone).csproj
4466d6341cedabb7a05c56d1da0414ebf641f69c76c1fd02f83296a9b424419e  CameraShake/CameraShake (Windows).csproj
6ef46affeeda775b071f7a89a1eccf4f3e43a149063080a15ac0f0bbc02319e7  CameraShake/CameraShake (Xbox).csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  CameraShake/Game.ico
2be77c1f0a6ae2989615f8d832b3cb8d968bc697a6468dee3a5c39b9a2301f5e  CameraShake/GameThumbnail.png
3b69485abfd13bd2956ad4e8ed1d991a73c5589b5e299d7e7f452be58a0d2fa5  CameraShake.htm
fb574df051ed66b797958a157e93782e781c2531b4acf086a9bae80d05c3b030  CameraShake/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  CameraShake/Properties/AppManifest.xml
e37c810bf88973677a6c3ce21d50a94227a2a695a56149f49dd7c068301aa170  CameraShake/Properties/AssemblyInfo.cs
a3f9be30ad4825d7f419290b1a46bbe5f064b62e3b3ad08f557c3d7b2fa639ec  CameraShake/Properties/WMAppManifest.xml
4f5f4e06d4e06d8502a2163d194431f042380bca7cee7e61d2072fd5550f7afb  CameraShake/VibrationManager.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; 800x480 window, Escape exits 0. The shake itself (A or X) was not driven. Runs against CNA.NET `ec7d3cb`, CNA `1dc4ce06a`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-1/CameraShake/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
