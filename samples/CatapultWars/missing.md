# CatapultWars audit — CSSAMPLE-067 ✅

## Result

**Runs, as the phone game it is, pixel-identical to the C++ port** — 0 differing pixels of 384 000 against the C++ campaign's menu frame. The training kit's final stage (`EX2_PolishAndMenus/End`), as the C++ port took it; its sources are checked in verbatim and build in Debug and Release with no warnings. Escape is the phone's Back button off a phone (CNA.NET CSX-095) and exits 0.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/CatapultWars_4_0` |
| Project | `Source/EX2_PolishAndMenus/End/CatapultGame/CatapultGame/CatapultGame.csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `CatapultGame.CatapultGame` |
| Assembly name | `CatapultGame` |
| Content | textures, fonts, sounds and the XML animation definitions the game reads as they are (identical to upstream) — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
5ceedaddcdff8946961b2014014245a89a7e32da759faf3a17a3893e4233f579  CatapultGame/Background.png
2c204710ce47f531c2f1bf9451c804db182d266fbf47fe067b873926aebf441a  CatapultGame/Catapult/Catapult.cs
58020d2ab744086d4137a1f950cebec7628de203a92b940bd80152df2a927291  CatapultGame/CatapultGame.cs
aa6fe19007eed490311acb146ddd5cd81ff4bdae77a04a305b69baa27a631a2a  CatapultGame/CatapultGame.csproj
181aff69ea7322dc729c5d27336ba34eae3844162d1eeb91f7053ba45c2527dc  CatapultGame/Catapult/Projectile.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  CatapultGame/Game.ico
5b255dcc2a5a7005ca0f560c0a0edd5dfa3ee61a646955a9746b1a493a9d5455  CatapultGame/GameThumbnail.png
c3157e4488de0dd8f38230740e8e7c95b4d3395a998aa077f195185a603e7a60  CatapultGame/Players/AI.cs
d8912ebbaf1d885f6cc7ccc52885519ed3fdb4f2cd337432e2e28f4f3135310b  CatapultGame/Players/Human.cs
a363425c45e6db89122db4cb00bae71c0543e6b916f594024301406c8f477a34  CatapultGame/Players/Player.cs
a482a44cd48118728513af220a051913e4729d0ff83171b2899fcde8f8f76f65  CatapultGame/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  CatapultGame/Properties/AppManifest.xml
c3f0e4958e6d089a5bdfd08d4596a2bdd24a2c6bba1d6f8c5a6d9b9ba55ff3b6  CatapultGame/Properties/AssemblyInfo.cs
6c3f62fe99ec4d15cc9244f3392f7bd28486c2f54ba2d94a26fe83ac271bc68b  CatapultGame/Properties/WMAppManifest.xml
8921033a39d82bbaeb6a97a9ce17f65ce1569a00bddbe4feb383777df7e18a5f  CatapultGame/ScreenManager/GameScreen.cs
a65324c518f6a8b88799a65a1aa5cb0fd629a2b9f5a3acf953f88e15b0b87e11  CatapultGame/ScreenManager/InputState.cs
f21f66d8edad75c05bf292a7156822338545f92b26e7f9cf53fa1fd0cd890e51  CatapultGame/ScreenManager/MenuEntry.cs
4407b6606aa057e0feae54bc034ca2a0e0a0d47043b60a74b5a57a8634f9194c  CatapultGame/ScreenManager/MenuScreen.cs
75dc8b6f281f7192cda42acb682eef99dcfa0771eccad2282842d050a3c60fdf  CatapultGame/ScreenManager/PlayerIndexEventArgs.cs
55fdbc3e92f8af500267b73282db6bbb95b89b2aae3ba778110f3ccd18b48c3d  CatapultGame/ScreenManager/ScreenManager.cs
32b370ba86d22c121392286ee356d1f75e214dc2e342ad1db2286926c74349cd  CatapultGame/Screens/BackgroundScreen.cs
ab83003a7c008b4d2ea5d8a3ea01881b0c0504d8c5b229e2dc7ed36518eaee4d  CatapultGame/Screens/GameplayScreen.cs
a611ea8df8942bfbc0eaf4d546693c9edf35dfc2ef2ed9b52786fa38acafc041  CatapultGame/Screens/InstructionsScreen.cs
7384a2a973597ea5e24ba8c43cc87ac26ddd2a84fdf1c4bfcfb1fbc1ccf09cc2  CatapultGame/Screens/MainMenuScreen.cs
52b920c201a5e73b22f50c71b775a8b11ae3db284a3443dca40bf001507bbd81  CatapultGame/Screens/PauseScreen.cs
a3bad5bd4895fd196f3cb60c979184e6bbc703b843b1399e021bc748c9259292  CatapultGame/Utility/Animation.cs
8716797b781b5c2dd342486c921472730d8dd821573e9260cc5881c71289d156  CatapultGame/Utility/AudioManager.cs
```

## What was verified

The first frame at 2% fuzz against `cna-native-mouse-touch/cw-01-menu.png` under `/rv/tmp/samples/SAMPLE-067-CatapultWars_4_0/evidence/`. Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-60/CatapultWars/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
