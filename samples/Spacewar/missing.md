# Spacewar audit — CSSAMPLE-014 ✅

## Result

**The original C# runs unmodified and is pixel-identical to the C++ port** — 0 differing pixels of 921 600 on its splash. The project sits at the upstream root, so it is checked in as `Spacewar_4_0/`; verbatim, it builds in Debug and Release with no warnings. `Settings.Load` opens `settings.xml` by its relative name, so `Spacewar.csproj` copies it to the output as the upstream project's Content item does. Its Back button is the keyboard's Left Shift (from `settings.xml`), which exits 0 from the splash.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/Spacewar_4_0` |
| Project | `SpaceWarWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `Spacewar.Program` |
| Assembly name | `SpaceWarWindows` |
| Content | models, textures, shaders, fonts and the XACT audio project (`.xgs`, `.xwb`, `.xsb`) — official pipeline output, identical to `../cna-samples` — and `settings.xml`, which the project copies beside the executable as the upstream project does |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
9b505d22fb8e460af4fba2aadae1627ab2f2790ddc2289457238cb8561969d6c  Spacewar_4_0/Asteroid.cs
35b4b4539984e0cda15eacd8de8b1dc4493ca7f6f45e3ee8b749ea4abe0b67dd  Spacewar_4_0/camera.cs
a7b76250a910bd3d95c0538e94c2e685434521c4c78515687214265c32b7af2a  Spacewar_4_0/Common/GamePadHelper.cs
384cd9bea5af9085a317ae21376dfbcb00748a8ea699e2c5ee3eb318d1296727  Spacewar_4_0/Common/GamePads.cs
52241f1a93823137d1a499286ba7c6cf06a3202bfa126f242072b06748ccb6b6  Spacewar_4_0/Common/Keymap.cs
13ace16ba7a249a5c9a172eaeb357fae1002a8a7efaaaf698d46ad451ae94f48  Spacewar_4_0/Common/XInputHelper.cs
f422f1c8dcae0f434b9f0c90c21bd9c9e56ead980c50964cdae754ea5aa83cc4  Spacewar_4_0/Documentation/readme.htm
5d93d0c93dd8577ee6e474d21a9863b1b8905242592abe7d31f70b557a5cc443  Spacewar_4_0/Enums.cs
940d584f53cf1090d7e29a65019ebffd84125ca232345578ae83e0f745cbffca  Spacewar_4_0/Evolved/BasicEffectShape.cs
1cbb06aecc9434149857dc5bce6fc8b8cd6a2f70d5f1df155bca55becae7c284  Spacewar_4_0/Evolved/EvolvedBackdrop.cs
9ec48d7d154d7b200cd475dc33caf808df4331a12eae49612289a0fd2cf87472  Spacewar_4_0/Evolved/EvolvedScreen.cs
d3bdcbc7eae249fb92ae155fb48f7b5270f05fa56348dfd25bb645bb01c3db94  Spacewar_4_0/Evolved/EvolvedShape.cs
7b5f77023f15b5d2be0c409dc99474557b3557fb5efeb8b631b8f99113d59416  Spacewar_4_0/Evolved/EvolvedSun.cs
2c8092caa55c382ab7bcb5dee1453df4ad4e7fe702584ab410c711bedd185d5d  Spacewar_4_0/Font.cs
f321791f1033118625d5fd030a823544a396c9bafe167ec02f81b3516d3f1c8a  Spacewar_4_0/Microsoft Permissive License.rtf
0f1c49dc6aad141b295343ab041f98777eee7011ab51e6c6fdb28afffa4edc58  Spacewar_4_0/Particle.cs
7a6c42c3a387b30fa66a67b08deb516afb2b92f0cac2792d970ea5c67d52397a  Spacewar_4_0/Particles.cs
d1fc5eeb567f745703eefea2fee38b94bb8437bc4d3bb03dba173e9d5e0a1223  Spacewar_4_0/Player.cs
787bcbe295022d3b2e641c7931f944de3dbd545ddcd2410635de01d1e55793c7  Spacewar_4_0/Program.cs
4860f5b3dfa80339bd6d054437e7ef8bfbf00b8e77fca9c0285833ecdf959f6e  Spacewar_4_0/Projectile.cs
4f76ab516fd586add90849d91348b070dc64359d950f6637616bfad8a4e86604  Spacewar_4_0/Projectiles.cs
8814f43a69b9024960f6d3462e41198fb4080ff80ff4fb7f7e0e163f30a16091  Spacewar_4_0/Properties/AssemblyInfo.cs
e33844e058af24b564dc7593c0e76c1346447520bf33ef75bcff93cbf8637bbe  Spacewar_4_0/Retro/RetroProjectiles.cs
7b8f0c44205f81ded5affb169a1a2893ac46318b3ec751cea8e73a909f3d65ef  Spacewar_4_0/Retro/RetroScreen.cs
e418dae3417a1f5ca85dfb582629350db4496fd4874bff99f70e2d33c1be1b0f  Spacewar_4_0/Retro/RetroShip.cs
c6e264639ec3501f58b0886f6c57384314de616e809c4ba79425a29c74bef2d6  Spacewar_4_0/Retro/RetroStarfield.cs
1e4a75b84ff9b6ffea6c5412ca24df753b89fbb9252005d30d7b1193ef68e601  Spacewar_4_0/Retro/RetroSun.cs
3e3762e9d286e08cc2b3cb99686fbf968742a954557bf9cda0ac4d379401a572  Spacewar_4_0/SceneGraph/FullScreenSplash.cs
4a1bfb95f8c0d47dd64c2049fb2ade392f97f42f84df262380695853927ea1e6  Spacewar_4_0/SceneGraph/SceneItem.cs
4a8a556147ccaed485a4fd03650469b2d41ac935d57a30c62356169b4bf94baf  Spacewar_4_0/SceneGraph/Screen.cs
3d25bc26d81b30cad8737d36012cbd9c8a84df2155a18724e80e4e9407cf6ccb  Spacewar_4_0/SelectionScreen.cs
367d6309c46adf629867a8a5d0ea6acd9d9ff3b08b99f647d8477dd24756bc3b  Spacewar_4_0/Settings.cs
5f0ece3f38761b2738412985c2d75b08e5b892bbc2a2890f14774c7ea30dcc8d  Spacewar_4_0/settings.xml
f6c1579ecfb47fd9ffab7525a766440529e1dde8119bb1485187aa923f07f06c  Spacewar_4_0/Shapes/Shape.cs
e344cf93351b2668e28967f742bbbea8f9a61d68ce33c5c956d2e5abba773317  Spacewar_4_0/Shapes/VectorShape.cs
e327c796760f67866508c353dea8ecf716bcde11bca74c98dd59c357683731f1  Spacewar_4_0/Ship.cs
39b93b95bf741dce629a4cf1d7127524d4b14ff78ed880af925f1db000fd3826  Spacewar_4_0/ShipUpgradeScreen.cs
3238f50ae7904d8f66f59c75ce096dee97a83500162cfe7fab5f5f9ff57a4bbc  Spacewar_4_0/Sound.cs
726014a9cec6f508891be1e51520233cc9ef585d9da615f5b3495e7a282a4d3b  Spacewar_4_0/SpacewarGame.cs
365854614236959de42b7487518d67b39a8306c065cd0b84827545f158a1e0e9  Spacewar_4_0/SpacewarSceneItem.cs
3f7466578c7848dd40d37d36b93cdf1bb4e68d10c04822f890a8cad3adee2996  Spacewar_4_0/SpacewarScreen.cs
fd0a37ce757ce5c5bcb9ea3c3de01e55f0d6a9e2add855b9c53c949d78c9d8f4  Spacewar_4_0/Spacewar_Template.ico
c3e6caf1195d500fa7fcdde709b7c8c58c101510b5cfebc2d8139649c620e475  Spacewar_4_0/SpacewarThumbnail.png
089456f98100caa621b6c0454845f51e35fa2a0f42ca85a1d67ebe64e0fc222a  Spacewar_4_0/SpaceWarWindows.csproj
40c6eaf5cf4a5c85f7f233e575e5b5a10af7b9b613201a92e0ea5f0390ee3f52  Spacewar_4_0/SpaceWarWindows.sln
2252b07c44cab2d50d649f03d0a9a26c1fd86c226651e26e96e55e03554c353f  Spacewar_4_0/SpaceWarXbox.csproj
f79e7e97b618570522f22bcf41d4a43435c37d908c4b619a4da817d3ac85583f  Spacewar_4_0/SpaceWarXbox.sln
dc95e130227446ff72a0e76c8d41a30b06f4f360582505b8fb1de025d44d7cc1  Spacewar_4_0/Sun.cs
4704e9e23ec35b6f76d94f8b931317aadb97caf95aa7283fd9815b2fc01a544b  Spacewar_4_0/TitleScreen.cs
dc04f46d35be4f7f19c1d18593baf0b98fae986e6093dd4c8ea374ecf94d4d84  Spacewar_4_0/VictoryScreen.cs
```

## What was verified

The splash frame at 2% fuzz against the C++ port's frame captured the same way; Left Shift as the exit key (`/rv/tmp/cs-samples/spacewar-exit/`). Runs against CNA.NET `a6e0c50`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-61b/Spacewar/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
