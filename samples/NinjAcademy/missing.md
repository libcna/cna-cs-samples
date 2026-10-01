# NinjAcademy audit — CSSAMPLE-065 ✅

## Result

**Runs, as the phone game it is, pixel-identical to the C++ port** — 0 differing pixels of 384 000 against the C++ campaign's menu frame. The game and its common-types library, both verbatim, build in Debug and Release with no warnings. It first did not compile: it subscribes to `PhoneApplicationService.Current.Launching`, `Activated` and `Deactivated` and keeps its tombstone in `State`, a Windows Phone SDK type. Added to the opt-in CNA.PhoneCompat (CNA.NET CSX-097): Launching once the game runs, after `Initialize` and `LoadContent` — its handler starts the menu music through the audio manager it creates in `Initialize` — and Closing at exit; nothing tombstones a desktop process, so the other two never fire. Escape is the phone's Back button off a phone (CSX-095) and exits 0.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/NinjAcademy_4_0` |
| Project | `NinjAcademy/NinjAcademy/NinjAcademy.csproj` with `NinjAcademyCommonTypes/NinjAcademyCommonTypes.csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `NinjAcademy.NinjAcademyGame` (no `Main` upstream: the XAP host supplied it) |
| Assembly name | `NinjAcademy` |
| Content | textures, fonts, sounds, the music with its `.wma`, and the configuration compiled into the `NinjAcademyCommonTypes` library's types — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `NinjAcademyCommonTypes/`) is clean.

```text
ee2817eb577801a9654f32b0f6ad727e59c234cce66d29ac9090dea73674a5cf  NinjAcademyCommonTypes/Animation.cs
9076ad1f4e0738e22f0f268702a537c4835bce8200b1f5677e8f6cbdd670db8f  NinjAcademyCommonTypes/AnimationStore.cs
c2ba0f7aa6937640ddeee6c177aaf29b00f5942c95b184a5cd55655655bbb5ef  NinjAcademyCommonTypes/GameConfiguration.cs
c7d0bbc1d9caf1645823826e7f589cf88296a44748251902b9058eac31683c52  NinjAcademyCommonTypes/NinjAcademyCommonTypes.csproj
cb5bbadc8f03a40b0ec8c2b063511a6116d60c44b36c647cf6e1c21540c107e0  NinjAcademyCommonTypes/Properties/AssemblyInfo.cs
252b3169e389bc5fcf96559f897bc0dc6d6e12e08e34d3b71269ae0673c9447a  NinjAcademy/Background.png
09df9a96f8016b26dc612fb0af5cd3029c56aa0d264bbcb0f9cd73bdf4c70852  NinjAcademy/Elements/General/AnimatedComponent.cs
d156ff5b3ac0c8445159938a3b103b1e9a35c2bb22223930ac4024293ee6961e  NinjAcademy/Elements/General/EndingAnimationComponent.cs
1a2668ffc7101c6f29be084ea2928d6bb1c992a6e10a99c7ab966878c73afa4f  NinjAcademy/Elements/General/LaunchedComponent.cs
c43f250da6c599441fc1d1f6603ec3d9ab8f2b049fad4f0d190a0197772f4476  NinjAcademy/Elements/General/StaticTextureComponent.cs
a8127f40be273d4de0d7fd35a56a1a50a76498b5d1fc130019794a3ba6cb54f4  NinjAcademy/Elements/General/StraightLineMovementComponent.cs
f99db4b526c2630a01709e776ad4786688901e1cb81b79ec31f7f31ceb46a616  NinjAcademy/Elements/General/StraightLineScalingComponent.cs
812fb499aac2f8db408a70cc30868b451ecb73ab311cd72cfbde6a2747f7e0d0  NinjAcademy/Elements/General/TexturedDrawableGameComponent.cs
d1afa52cb604747fca821e4edfe4290ab184e7006d0d65f878335c97fc038415  NinjAcademy/Elements/HUD/HitPointsComponent.cs
6306882a9e232f5941fe16bd2d29a636b1cbb2c7bbf5b43d516e9f879442bf8a  NinjAcademy/Elements/HUD/ScoreComponent.cs
20005af20d9012992e2e0f297759c4e85b981108287a01cb9ea346661d6c0fbe  NinjAcademy/Elements/HUD/TextDisplayComponent.cs
3d5969989a772b7b2dbba03073aeddf58393277fb46179ae44c44b8de0bf1358  NinjAcademy/Elements/RestorableStateComponent.cs
2e0829af3ea9bbf900527ad9f5cc2712165e7377057bbf465bae511db0862348  NinjAcademy/Elements/Specific/SwordSlash.cs
3c6cc0975e8579e186ef71d15a9f7edc56e58e6a3a6f4dd25c30c2dea9fe8e1b  NinjAcademy/Elements/Specific/Target.cs
97f416bdcbc2c708320992b90a809454a4ab689ca3c240b9603c3b22b98075c1  NinjAcademy/Elements/Specific/ThrowingStar.cs
90d26397968bc9fc4e39f8f4f4cbb91aea2e68a4ab3ee4e36298c8afe073b63c  NinjAcademy/GameConstants.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  NinjAcademy/Game.ico
252b3169e389bc5fcf96559f897bc0dc6d6e12e08e34d3b71269ae0673c9447a  NinjAcademy/GameThumbnail.png
2113ca0830275e99a1277868551211a0f5a369c4c657f298b5445820a70afaf3  NinjAcademy.htm
19b2ffc2f90613b4f425367448932fa6e804f53d26ac952c7fed68d2b0ba4657  NinjAcademy/NinjAcademy.csproj
830134e8fab465ac3a61fd82e1c5034106d5ab5a001e2035d416614dc332102b  NinjAcademy/NinjAcademyGame.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  NinjAcademy/Properties/AppManifest.xml
57fcbc03e6cdda7a4ae70ae11c4ffd2337ed1e5a480f62b83cbd3d7c384317c6  NinjAcademy/Properties/AssemblyInfo.cs
dc3a5ac884fb9e3ac8fe5cd06c002c29e02d4fc774ad0f5a48bbfd24024aa6fa  NinjAcademy/Properties/WMAppManifest.xml
754e1711ed1cdd1e52f0899287617b43b2abf53d6280e432a165ab9ac8b92b13  NinjAcademy/ScreenManager/GameScreen.cs
3ea4d39c07c23b2915ce5d3b79f5035d36287fbe13b52c5bf4903b49ae92184d  NinjAcademy/ScreenManager/InputState.cs
4cd40ff9f1baed1b53ed1153169de32a62755651a5c73e5ac98a36db0cd9d7af  NinjAcademy/ScreenManager/MenuEntry.cs
3992d1c7f6cbce9887091b79b7a7cf2bb923df3fb7b9c524be4553f527dfd3ad  NinjAcademy/ScreenManager/MenuScreen.cs
ea7fdd458cd7db9a2605e14cac514da7a79fd87f90e17c90bcb2f1ac177eb73f  NinjAcademy/ScreenManager/PlayerIndexEventArgs.cs
eafac50b562584db4827b3d8c058a9a4080a2497f7d3ced2dfa5866492a5a0ef  NinjAcademy/ScreenManager/ScreenManager.cs
c46f1a3b323f9643a6fb0947391e8d8fb5de6c97e9e1e54fe0bcc5ab6314138d  NinjAcademy/Screens/BackgroundScreen.cs
d6bdd37f541e92073f6fe12a1f20b259dcb892b6319f304ab36557e14657b95b  NinjAcademy/Screens/CountdownScreen.cs
4fd11b8c53df18e90fc7a6ff8596a257bd20cf3bb222e7b92159746809b5130f  NinjAcademy/Screens/GameplayScreen.cs
6cd6433d7afe7b439e27736e36918ce1d683f817bb2de7225058b45de9df4819  NinjAcademy/Screens/HighScoreScreen.cs
92ca86c2f81beae11c48d3a341eb7d644d773d7f28812cca2202ec15af05450b  NinjAcademy/Screens/LoadingScreen.cs
85d826b17b4091618cfd416da8272565bdb12ff43bf30c45505d910dccbc8c35  NinjAcademy/Screens/MainMenuScreen.cs
c5956af39fd6e6d514fb74c18e19b1af192ae98d4acc56099fac43addca3e63e  NinjAcademy/Screens/PauseScreen.cs
e3718f9e32ac599e487d11121158ca6850a229b9e1b7c408023942548287aea8  NinjAcademy/Utility/AudioManager.cs
65025540702907e1cef4d2502ca977687a92c90192461c9c8174516b1088fb36  NinjAcademy/Utility/ExtensionMethods.cs
a7ed197748b0a956189145dcb48ad91603f6e0e0146e77272d64408d11e8b297  NinjAcademy/Utility/Line.cs
```

## What was verified

The first frame at 2% fuzz against `cna-native-opengles3-final/01-menu.png` under `/rv/tmp/samples/SAMPLE-065-NinjAcademy_4_0/evidence/`; Escape as the exit key. Runs against CNA.NET `9360a28`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-62/NinjAcademy/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
