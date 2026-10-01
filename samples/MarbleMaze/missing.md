# MarbleMaze audit — CSSAMPLE-061 ✅

## Result

**Runs, as the phone game it is, pixel-identical to the C++ port** — 0 differing pixels of 384 000 against the C++ campaign's menu frame. The training kit's final stage (`EX2_Polishing/End`), as the C++ port took it; its sources are checked in verbatim and build in Debug and Release. The two build warnings are CNA.PhoneCompat's `[Obsolete]` on `Accelerometer.ReadingChanged`, as the Windows Phone 7.1 SDK marks it. Escape is the phone's Back button off a phone (CNA.NET CSX-095) and exits 0.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/MarbleMaze_4_0` |
| Project | `Source/EX2_Polishing/End/MarbleMazeGame/MarbleMazeGame/MarbleMazeGame.csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `MarbleMazeGame.MarbleMazeGame` |
| Assembly name | `MarbleMazeGame` |
| Content | the maze and marble models, textures, images, sounds and fonts — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
f98f4dd580d57e9dad1066c20270e0ba23c69a0367ba0127bba1400c0297bae5  MarbleMazeGame/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  MarbleMazeGame/Game.ico
97666f7e289f4663330b9bbbf80ce4150378ed2556566b7feb4d9d36de33a32c  MarbleMazeGame/GameThumbnail.png
24f7f8c5e42a621521fee23e13dcd5b37ab49f775d56ba596b8c7f5a811091d8  MarbleMazeGame/MarbleMazeGame.cs
28956da97b1f9e0045b319ac60e2e9852dfc3de8ee1d7a86a0c32cf9bfcd55ea  MarbleMazeGame/MarbleMazeGame.csproj
13247c1598c61a3f2cc33e19bdf737c125a3ff3508b8e98acf7234a9af8a49f0  MarbleMazeGame/Misc/Accelerometer.cs
0450ad7cf5e912aef160b6be39519df667e0cd285fdc589f946ccf1dce6757b0  MarbleMazeGame/Misc/AudioManager.cs
caaca9be76fd59ab51f406f3adefe06bca523b0f1b0ee634d6a9a39f96e8ed48  MarbleMazeGame/Misc/IntersectDetails.cs
cdb64dd5ef39eff7b41eb49a8b4aaec559ee33ee01e64286f83d8c27c2ff7a21  MarbleMazeGame/Misc/TriangleSphereCollisionDetection.cs
913e1637ace5645984bb85e4a75fc7a8e16e94089d83af5a52f9e52ce10c7c3b  MarbleMazeGame/Objects/Camera.cs
f3b56842ff1348281835e9d3fcf064fdad508937fe9a728cf1f14b5366b8b657  MarbleMazeGame/Objects/DrawableComponent3D.cs
f28f2a45f4f68ea719ca5e96d2d2286107f75cc4f4d52eef7bd659afc5162887  MarbleMazeGame/Objects/Marble.cs
3b236653eef3d23e1a1e8bf48222b3f92255e981844d9886ff1afbd431a90bbb  MarbleMazeGame/Objects/Maze.cs
afde22b035a79cf7b21768e2c66bc2e4f5b5efb33570bcaa03cab7eda8851c65  MarbleMazeGame/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  MarbleMazeGame/Properties/AppManifest.xml
5d51be4a12a0d5f6884e6a3c43ce8b4f6e81f3edaa3b77b3ca15c5d3de805033  MarbleMazeGame/Properties/AssemblyInfo.cs
4aeea40551930b810e9c7c419169f9b4c3240b1b95f783f1cb35f67cfea91894  MarbleMazeGame/Properties/WMAppManifest.xml
8921033a39d82bbaeb6a97a9ce17f65ce1569a00bddbe4feb383777df7e18a5f  MarbleMazeGame/ScreenManager/GameScreen.cs
a65324c518f6a8b88799a65a1aa5cb0fd629a2b9f5a3acf953f88e15b0b87e11  MarbleMazeGame/ScreenManager/InputState.cs
1e7f3e2a31f32e49136a37f34c4d7c052e3a3039b41e17d59bc07422887cf69e  MarbleMazeGame/ScreenManager/MenuEntry.cs
4407b6606aa057e0feae54bc034ca2a0e0a0d47043b60a74b5a57a8634f9194c  MarbleMazeGame/ScreenManager/MenuScreen.cs
75dc8b6f281f7192cda42acb682eef99dcfa0771eccad2282842d050a3c60fdf  MarbleMazeGame/ScreenManager/PlayerIndexEventArgs.cs
38ea08eb883149c1a84b86804ff362119710f7af5a3fa3a3620ffdc6464b1461  MarbleMazeGame/ScreenManager/ScreenManager.cs
1724bbf44cf5fe162ea7c620ec6df64d924c7adce373ab02bfaaa198c46491ff  MarbleMazeGame/Screens/BackgroundScreen.cs
61c8f6201198d475d9f32a19f1c492db587b0311a251f7a28251456a7b10b8f3  MarbleMazeGame/Screens/CalibrationScreen.cs
190f6b5ee7e01823bf572d6f7c45fa51dc399ac04b6d89c879fcc48b2d708afe  MarbleMazeGame/Screens/GameplayScreen.cs
c07d34f3357440b0b5da88abba5c808fe71fd32afd120b1c97fa3deee5bcea0a  MarbleMazeGame/Screens/HighScoreScreen.cs
b79204d800ac772ed1ea82dd5747cea15588e7ee1dc7665edcc92c547216bbf8  MarbleMazeGame/Screens/LoadingAndInstructionScreen.cs
947e4b387ce5058536d5b4605bd892d08743f9db0dd35e6dd3263e6656d57034  MarbleMazeGame/Screens/MainMenuScreen.cs
032c9f8b6b2730c58a0f725d96cc641cb4e882ce2e02c23ccab2d4d85e23997d  MarbleMazeGame/Screens/PauseScreen.cs
78c3320cc6fe759eee0204c1243efad7b09ee15581298e5ddc67883b40c2e621  MarbleMazeGame/SplashScreenImage.jpg
```

## What was verified

The first frame at 2% fuzz against `requal-20260926/cna-native-opengles3-audio/native-menu.png` under `/rv/tmp/samples/SAMPLE-061-MarbleMaze_4_0/evidence/`. Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-60/MarbleMaze/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
