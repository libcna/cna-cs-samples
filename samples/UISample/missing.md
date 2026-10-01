# UISample audit — CSSAMPLE-082 ✅

## Result

**Runs, as the phone game it is, pixel-identical to the C++ port** — 0 differing pixels of 384 000 against the C++ campaign's qualified main-menu frame. Upstream ships only the phone project (its assembly is `AchievementUISample`, kept); its sources are checked in verbatim and build in Debug and Release. Its main menu leaves on the phone's Back button only; off a phone that button is Escape (CNA.NET CSX-095 — the C++ port got the same by editing the game, at the owner's request), and Escape exits 0. Its screen state goes to isolated storage, under the capture's private home.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/UISample_4_0` |
| Project | `UISample/UISample.csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `UserInterfaceSample.SampleGame` |
| Assembly name | `AchievementUISample` |
| Content | the five level pictures, the menu fonts, the background and gradient — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
2e344471eafdf49da2c201f286f1c7c2d2327b1dcc6fb21f95c0b3a05b5b7cc0  UIControlsSample.htm
22456519a6997deb8cef38ae459444d7b3d902f6c9217ee81407d250293942da  UISample/Background.png
56bb6397880840af5d26bbd58b02f0f84e5a2226eb48b2e51f117965f6be5d7c  UISample/CommonGraphics.cs
a4020a3d1846b4dde2f2dd8a0ebf61fc199c5fa6d98f3896de44d993ef25f4d3  UISample/Controls/Control.cs
564df16200bea93b65668471b92c0ddeb0fe800008a54c9eadc7f7adb1b969dd  UISample/Controls/DrawContext.cs
81585d2fb8ac7b5d4d06fe8337d8f55693cc71261f7439a3bb2c93db9415e1d9  UISample/Controls/HighScorePanel.cs
2041ad490d1a2b5e3c96010a66a87e2a1f6ceca97e910228546aca6da59acb23  UISample/Controls/ImageControl.cs
77b0d9d05078193b5f693ff9ca48d518d8c4dcfdee82ca4a678e3eff7da0869f  UISample/Controls/PageFlipControl.cs
b01d6b86414699b7b3b56ff300acc96e8dc4731de6e10abffa801a13d7b347af  UISample/Controls/PageFlipTracker.cs
16818c8f4d25bec8df4e7df8a83805030500787f2ac353e0ad20e57bcabcfe93  UISample/Controls/PanelControl.cs
bc60bd9a030968d91f5bba0d9e013b8bd907b12230ff3667ea5d5b5787a8a11f  UISample/Controls/ScrollingPanelControl.cs
ed3b303066eb440c2c697549863f5a19ac17c4cb7c5637697f33759dd9ceacef  UISample/Controls/ScrollTracker.cs
bb3e616eb436e9b678e3a267fd8f143cc15eb7209ff61981546d14ceeec644f4  UISample/Controls/TextControl.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  UISample/Game.ico
1d8bd64f9b8499ff1f7f5d980d2442101823847a64dc651695a72ee13e476a4f  UISample/GameThumbnail.png
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  UISample/Properties/AppManifest.xml
ef1c006b7e2c2e25c7172617d17a7e1aa9053529f8f332137f41354a1cbae913  UISample/Properties/AssemblyInfo.cs
9b825c7547ab5062f964b69d02b8f35b3de8c14aa511d2b1dbfd2f94e9abefca  UISample/Properties/WMAppManifest.xml
274f9cb8a2410f66eaf2d7c9c4d572bb4df0844c95f76d8e80428b3cd15d762c  UISample/SampleGame.cs
78fa5b06b3dc6f8012709f04fc3c3c0c8bf035c18ccb059a57dd051e6c72a65e  UISample/ScreenManager/GameScreen.cs
df5cd73b47e562f7e1ca21d6a842567e8de3d4a744cba1b65fa67e47aaa52f40  UISample/ScreenManager/InputState.cs
ba7be982ef593fbbf0b0ab88f46f7086d6a8899a04920799713adeea1ee9062a  UISample/ScreenManager/ScreenManager.cs
7a66bd18b9f2872d8efe75c06d432cad67f1f261078dc0f23776a4e8f4f83afe  UISample/Screens/BackgroundScreen.cs
eb9bd51b118e2021ba06503545714a16d4ba1ea187a96dfe775626c0c981d837  UISample/Screens/HighScoreScreen.cs
b183f0d754b94b9300479e6ee18a6873dc292a2f2333b82a193a9cbc66660ee5  UISample/Screens/LevelSelectScreen.cs
b1cb502493ca13cc4d52c18db246215a39340b6e3e39550fbfbcb621d85a49d9  UISample/Screens/LoadingScreen.cs
33fef28dcef02e30ed0920f76ca30f72ff1ec5887c6cfc88fe0560b2ab40ab9c  UISample/Screens/MainMenuScreen.cs
f4156dd1d09dd1107ece3fb2de38c343369b90690394496cf9bae24dbe46d7be  UISample/Screens/MenuEntry.cs
be5923d2dcd8fccef1406b8979a5678e1c008db02074a1c15ff3e02d97fce7bb  UISample/Screens/MenuScreen.cs
3e3cbe4c4a8f84d97027e1b9a46bee101b9c7632d6483e1acee7314b7376aa24  UISample/Screens/PlayerIndexEventArgs.cs
8ec8024c0e7cc28f234e21df78f26ddfd8e695469ae911b6de2b60e11a3a4e30  UISample/Screens/SingleControlScreen.cs
437dcfd778252df3e5ff9767487f3536d40c1f20d5ea7b248df8c698d8891779  UISample/UISample.csproj
```

## What was verified

The first frame at 2% fuzz against `cna-native-opengles3-qualified/01-main-menu.png` under `/rv/tmp/samples/SAMPLE-082-UISample_4_0/evidence/`; Escape as the exit key (`/rv/tmp/cs-samples/phone-rows-csx095/`). Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-59/UISample/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
