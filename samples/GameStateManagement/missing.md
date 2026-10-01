# GameStateManagement audit — CSSAMPLE-072 ✅

## Result

**The original C# runs unmodified and matches the C++ port** — 0.95%. The Windows project's sources, verbatim, build in Debug and Release with no warnings. Escape on the main menu opens the sample's own "Are you sure you want to exit this sample?" box, as in XNA, and Enter then exits 0.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/GSMSample_4_0_WIN_XBOX` |
| Project | `GameStateManagementSample/GameStateManagementSample (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `GameStateManagement.Program` |
| Assembly name | `GameStateManagementSample` |
| Content | the menu and game fonts, background, blank and gradient textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
89f5105e6c7ae00bc4ee6264c95a1b585e71e224d450e95a71e6233f73e63476  GameStateManagement.htm
509bad6af0c1f6badb2e2d658a3d0d4ec7e881160e30ad40e5b86fc9574a54eb  GameStateManagementSample/Background.png
714ab8803ba01fca2ac321cba90e2b9fe134df4af7d90ff060c89fd4fe33690e  GameStateManagementSample/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  GameStateManagementSample/Game.ico
35294acfecc58fcc97f53fb48482adff14ad38cbbd87863c0d6e45e058c925f7  GameStateManagementSample/GameStateManagementSample (Windows).csproj
40f7037b218ebb3a5c5e5a59991efded4f6e08443c00721312b571f0b25486e1  GameStateManagementSample/GameStateManagementSample (Xbox).csproj
def6192391e4ec86a8b64bb99a4f70d3213ab561f016256aa2eec026a7be2fea  GameStateManagementSample/GameThumbnail.png
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  GameStateManagementSample/Properties/AppManifest.xml
bd126d143bf6db8c722fa98f4e61434182ffe969b8b1094b848c853c476f7c5c  GameStateManagementSample/Properties/AssemblyInfo.cs
60ca58269f9bef267fb17404aea01adf831341b6695f339719335568d77daa1e  GameStateManagementSample/Properties/WMAppManifest.xml
a1a2c69ef4655433fdfbe6d433dc56810f9dfe1fd6916172fa25145eb4058be4  GameStateManagementSample/ScreenManager/GameScreen.cs
a65324c518f6a8b88799a65a1aa5cb0fd629a2b9f5a3acf953f88e15b0b87e11  GameStateManagementSample/ScreenManager/InputState.cs
9b8cecf47d2ca574dd1f14a1f7d58aa4625e65805e77bb630318921a87782c63  GameStateManagementSample/ScreenManager/ScreenManager.cs
45554c6b9c24f55910dc35a348aa3cfa344d38db2b5df9e3e8cdc7360d1064e9  GameStateManagementSample/Screens/BackgroundScreen.cs
530e62026a1f8cc8ad0f9c4073a2bcb40fa8583349b7c0413cc02079775cbc95  GameStateManagementSample/Screens/GameplayScreen.cs
f405a83f20786510e7c0b5b46c509aa0e2a8dbb78b72ac30611a3c62615307c0  GameStateManagementSample/Screens/LoadingScreen.cs
508f9b8fc6cd97fcc1dde3134cf0f4d418548ed7f802c90811c6e8860eb5dde4  GameStateManagementSample/Screens/MainMenuScreen.cs
ec5ce6687460d20bc21b3fd79b8db2191403bad97c8fb0baa4d557d9a99a4831  GameStateManagementSample/Screens/MenuEntry.cs
5fda03f58a9321d5aee40d4d5228995212e356aec7e9e5ea5fdba62d9356ca6f  GameStateManagementSample/Screens/MenuScreen.cs
d4ee7e7650000d1b45a7a5e619401f2b174b4120a0e265d05184227cd3e0c2a1  GameStateManagementSample/Screens/MessageBoxScreen.cs
ad820afddc0963bcbbec7e56fb2f73694d2ce5bf3309968012b2a24f126627e2  GameStateManagementSample/Screens/OptionsMenuScreen.cs
f0025c75fc97f3f2b8ad890ded484d3d77e4ac12e4f5270403596b8f45877805  GameStateManagementSample/Screens/PauseMenuScreen.cs
75dc8b6f281f7192cda42acb682eef99dcfa0771eccad2282842d050a3c60fdf  GameStateManagementSample/Screens/PlayerIndexEventArgs.cs
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way; the exit path captured with Escape held, then Enter as the exit key (`/rv/tmp/cs-samples/gsm-exit-confirm/`). Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-59/GameStateManagement/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
