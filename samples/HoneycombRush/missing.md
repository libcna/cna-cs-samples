# HoneycombRush audit — CSSAMPLE-063 ✅

## Result

**Runs, as the phone game it is, pixel-identical to the C++ port** — 0 differing pixels of 384 000 against the C++ campaign's menu frame. The training kit's final stage (`EX2_PolishAndMenus`), as the C++ port took it; its sources are checked in verbatim and build in Debug and Release with no warnings. Escape is the phone's Back button off a phone (CNA.NET CSX-095) and exits 0.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/HoneycombRush_4_0` |
| Project | `Sources/EX2_PolishAndMenus/HoneycombRush/HoneycombRush/HoneycombRush.csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `HoneycombRush.HoneycombRush` |
| Assembly name | `HoneycombRush` |
| Content | textures, fonts, sounds, the music with its `.wma` files, and the configuration and animation-definition XML files the game reads as they are (identical to upstream) — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
d58b17df860417153b7040f2ff2b0d46052a240d58cb8782fafd081cd81494af  HoneycombRush/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  HoneycombRush/Game.ico
2cc6705c36a301e714d2d691a28ea2b93512464a7980d135c6b8045996b59919  HoneycombRush/GameThumbnail.png
6ea32dd9f1acad3f94d938e8408d3415ff7918efc24fb26769a5352d63059da2  HoneycombRush/HoneycombRush.cs
7e31eb21ee53eddd1e813bbc65b9ee1b7c2cff47dd52213f4a8bb750cd268d6b  HoneycombRush/HoneycombRush.csproj
0ea58d035ab3a14e5b1de303dfa418c7b403a7a520c209f61e59a9c45a2661a7  HoneycombRush/Misc/Animation.cs
db13d95eac1f0b40668bd09279e62ee973445d1c8a68d7a3108e954aebbc6439  HoneycombRush/Misc/AudioManager.cs
963df7a84c2f415bcdab77c89bb7fc83a95e3869e5f34e466010dfbc4ee88d01  HoneycombRush/Misc/ConfigurationManager.cs
6b81ea059663feb82928c4cb249609e3d8e0ed5e4711354d4280dd0168969f76  HoneycombRush/Misc/ExtensionMethods.cs
949e237f353acfe59451f554d42c6cdd5ff66e48defd787c23612abea75873b4  HoneycombRush/Misc/VirtualThumbsticks.cs
2b7335cd48a736baf899478757eee13c0e464109c5a155c98c21d4aa0403ae7e  HoneycombRush/Objects/Bee.cs
640f3da71a48af1accee72bfd4f9a9effa69d20a6798f42decc0d62e0819cf6d  HoneycombRush/Objects/Beehive.cs
032d0d6b85945deaf8fdee70627b3e66e94dd0f26897eebcd4d100dff44c26ff  HoneycombRush/Objects/BeeKeeper.cs
29fe6d5868a1a1d59040da634aaeffa0b41bf55232c883a77bd5a919c4b0975a  HoneycombRush/Objects/HoneyJar.cs
e1ac0999d3b00e447f52936d9244143b1a4017d6295c635de230bc5a8c3aed10  HoneycombRush/Objects/ScoreBar.cs
d46db88188ae6a8feb407e56b6ac542eb31a6672b78fb33f8f2e1864b63db36f  HoneycombRush/Objects/SmokePuff.cs
f6400c656cf8517ffc6eb489482019ee9c135407962dcb2f34578e824ada9fa2  HoneycombRush/Objects/SoldierBee.cs
c47b7c0916c8c38cbb155f276cdaa94417e5e5e6932635ab52f70be3b536f4ee  HoneycombRush/Objects/TexturedDrawableGameComponent.cs
9ea5b2a29d927c6aae4adab3055a54a0dff30ca0dc26893df09d8481052b1eff  HoneycombRush/Objects/Vat.cs
7b756089a6fc64d5e628030080f7da963a635731bf5d304cd118fa105df13058  HoneycombRush/Objects/WorkerBee.cs
6ff773fc0ecb9da04b5472d33a0bdfd36adcf77bd441fd8873c2546a9fab98f4  HoneycombRush/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  HoneycombRush/Properties/AppManifest.xml
bcb52ae1002a77bc74ca4cb0eaacebb3d15df483dca18aac3d92d23a5b42c359  HoneycombRush/Properties/AssemblyInfo.cs
0135e83fa7bf763bba0bc0adff5a8832713fed7a146b6739a2524cae4c84036e  HoneycombRush/Properties/WMAppManifest.xml
c5ec89e24d8dd2f08179a1cf79193a0522701d7e5025168383533ce3733ffb43  HoneycombRush/ScreenManager/GameScreen.cs
5679801552b53a9bdba3defda311d3aa0f8e2eed1e6539294dba9fcd183dc975  HoneycombRush/ScreenManager/InputState.cs
55ce5962b9acae9278ec20bb3e2d9698ad4c8360e51781080dfe6e6431374d12  HoneycombRush/ScreenManager/MenuEntry.cs
9d591de98a49b4b0140ad21ccccf708dc30ac108f54eb86f301ef6bcaffc611a  HoneycombRush/ScreenManager/MenuScreen.cs
99013766a4ff55fc45033c3923683896af208da92dab140a96334957f915f84d  HoneycombRush/ScreenManager/PlayerIndexEventArgs.cs
3d80760c16313e3420ab667a0a1e9b5eac2a78fdcb71900dced185bc265709ba  HoneycombRush/ScreenManager/ScreenManager.cs
7ab966946694eca7130d3f120c776fcd5f8695532a857f854f19f3e2efa316cf  HoneycombRush/Screens/BackgroundScreen.cs
6dc5eba0d0773d02872ae6459a29c88b922905b20345f84a8c0fb7d77750cbe7  HoneycombRush/Screens/GameplayScreen.cs
7a33f3dbb564cbf4f86cfd568edb8a62f87e58058ea3c75487a5e617e60ad644  HoneycombRush/Screens/HighScoreScreen.cs
3f77fa218e5900d86b136588149db7dac2a9862b5cf04341764af42d23300c8a  HoneycombRush/Screens/LevelOverScreen.cs
f2b5ee534de9d8508404936595187d4030b7509d4ead70d2f25a334915c23b50  HoneycombRush/Screens/LoadingAndInstructionScreen.cs
cdfb1744a4e99bbd495979a9142eb83283879e31a6765e969ce196f13f9b97f5  HoneycombRush/Screens/MainMenuScreen.cs
c66a095087ca52e7e69e4b197a082c7c54cdd9ff5aef67dbecb400cc6079cfb0  HoneycombRush/Screens/PauseScreen.cs
```

## What was verified

The first frame at 2% fuzz against `cna-native-opengles3-final/01-menu.png` under `/rv/tmp/samples/SAMPLE-063-HoneycombRush_4_0/evidence/`. Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-60/HoneycombRush/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
