# DynamicMenu audit — CSSAMPLE-077 ✅

## Result

**Runs, as the phone game it is, pixel-identical to the original** — 0 differing pixels of 384 000 against both the C++ campaign's page-1 frame and the original XNA game's (`original-windows-hidef-diagnostic/01-page1.png`). The game and its menu library, both verbatim, build in Debug and Release. The row was `🛑` while a phone game without `Main` needed a ruling; `<CnaPhoneGame>` answered it for PathDrawing (CSSAMPLE-021) and answers it here, with nothing authored into the upstream tree. The menus are the library's own types, read by XNA's reflective reader. Escape is the phone's Back button off a phone (CNA.NET CSX-095) and exits 0.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/DynamicMenu_4_0` |
| Project | `DynamicMenuSample/DynamicMenuSample/DynamicMenuSample.csproj` with `DynamicMenu/DynamicMenu - Phone.csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `DynamicMenuSample.DynamicMenuSample` (no `Main` anywhere upstream: the XAP host supplied it) |
| Assembly name | `DynamicMenuSample` |
| Content | the three menu pages (XML the pipeline compiled into the `DynamicMenu` library's control types), the fonts and textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `DynamicMenu/`) is clean.

```text
c6b6b0fcfe4254702d55921651e5729037381fda17f04cf16f25253025ea6644  DynamicMenu/Controls/Button.cs
2c2e98ac049c59684112b43d243065318c442f20f6581f418df0dd3012cb5c00  DynamicMenu/Controls/Container.cs
4be0c36ac7cf31bf82bee587f497402901e0fe5667b144f61f3656db1e950b43  DynamicMenu/Controls/Control.cs
ddc9abf117ebc7396b264218ba5b5b9888dc5d15cb35ce327c2304f0685c6c42  DynamicMenu/Controls/IControl.cs
bce8943de37992e4af5e5c010f219e2a7498e72d86d20b18c59fc7e958538a86  DynamicMenu/Controls/Image.cs
2684fc364772d825ea09519809c79fa67fa01f1e9324655e3f2df5c8bbd71767  DynamicMenu/Controls/ITextControl.cs
a03abd846a163c8565d0623b5d14540356f6f3d7285e0b2a8099bc5ae8f458bc  DynamicMenu/Controls/Label.cs
1fffdbc516590ec3db7a5bee1a57b540a701479baac831171d16a57b07e5b7e0  DynamicMenu/Controls/MultilineTextControl.cs
615b944e7fc4303c2889b06ba2e8d352eb3456ef3edad69bce5474b3bcf30b8e  DynamicMenu/Controls/PhoneScreen.cs
38b7a4ef739777e264bcde70347f6a67036beb14c629dbec91bb632b94300545  DynamicMenu/Controls/ProgressBar.cs
f7d9da9984aafe95d3aa6167cfc8ee215d8ffe388b287b5398fd7cb3b13447d1  DynamicMenu/Controls/TextControl.cs
6efd2161b343f7e9910168e5373260ed8856fa484ed49b5de790d3dee28d6948  DynamicMenu/DynamicMenu - Phone.csproj
718b84003f26ae7b8f346fb952d2ad951a28beace4d1636dc814db6133cde1ca  DynamicMenu/DynamicMenu - Windows.csproj
7be543b04c23eb0f862b9082c5ef70c9204a671ca66d19bf59ea9ae17817f775  DynamicMenu/Properties/AssemblyInfo.cs
3ef8e0065285311e93acf89490d49ceae1d1f2a1de6be4e9eca88391e8e65547  DynamicMenu/Transitions/Transition.cs
a0940739e88751945f0d7c4982aa117c8ab4a6bb709dfea20774eab6cf4ec434  DynamicMenuSample/Background.png
2e825eb8df6d38ff04f7ddb5ab102bf1eb904b55ae367f99a899a804fe72cef4  DynamicMenuSample/DynamicMenuSample.cs
5b43e162e2cded698817fe38f0fd2df0babc3124cfdcf0071baa62e2aec407c2  DynamicMenuSample/DynamicMenuSample.csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  DynamicMenuSample/Game.ico
a0940739e88751945f0d7c4982aa117c8ab4a6bb709dfea20774eab6cf4ec434  DynamicMenuSample/GameThumbnail.png
68ef4fce32608d83262b443535a5d8829d930829e49e9ae85f6106b1be23ac3e  DynamicMenuSample.htm
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  DynamicMenuSample/Properties/AppManifest.xml
d39c239d365a7fb69e069c99efa668926d216aeba3cb5fabae409b50c419cf97  DynamicMenuSample/Properties/AssemblyInfo.cs
89b1cd3c83aa0c44d51107ec95a33197e2ab993abc854be151b4519edad8cb85  DynamicMenuSample/Properties/WMAppManifest.xml
78c3320cc6fe759eee0204c1243efad7b09ee15581298e5ddc67883b40c2e621  DynamicMenuSample/SplashScreenImage.jpg
```

## What was verified

The first frame at 2% fuzz against `cna-native-opengles3/01-page1.png` and `original-windows-hidef-diagnostic/01-page1.png` under `/rv/tmp/samples/SAMPLE-077-DynamicMenu_4_0/evidence/`; Escape as the exit key (`/rv/tmp/cs-samples/phone-exit-csx095/DynamicMenu/`). Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-59/DynamicMenu/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
