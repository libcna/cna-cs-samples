# CardsStarterKit audit — CSSAMPLE-069 ✅

## Result

**The original C# runs unmodified and is pixel-identical to the C++ port** — 0 differing pixels of 384 000, on the title menu and again on the betting table after Play. The game and its `CardsFramework` library, both verbatim, build in Debug and Release with no warnings. On Windows the menu cancels only on the gamepad's Back button, as XNA's does, so Escape does nothing; the menu's Exit entry (Down, Down, Enter) exits 0.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/CardsStarterKit_4_0` |
| Project | `CardsGame/CardsGame/Blackjack(Windows).csproj` with `CardsFramework/CardsFramework(Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `Blackjack.Program` |
| Assembly name | `Blackjack` |
| Content | the HiDef content set (`BlackjackHiDefContent`): card and chip images, fonts and sounds — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `CardsFramework/`) is clean.

```text
ec154b1868605fbd763700c265491102c2ca12101a9d70a9583bc795c9b9e11d  CardsFramework/Background.png
8c1883af2b5b0cc1b8a99fa7e67ae0e58b30ad44d6ada133a3624010a246d1ab  CardsFramework/Cards/CardPacket.cs
5e7b3074b739bd59eceb501707896b0363c192b9fac1576e3b1b9f60db13b219  CardsFramework/CardsFramework(Windows).csproj
5c3bbfc02f2087b2e8730db00898058c3b3638e6c1c69551ebeb1322f028c2c2  CardsFramework/CardsFramework(Windows Phone).csproj
0a634c5e3393514df013c355da61ec61587633947b668811b027cd85daec4f59  CardsFramework/CardsFramework(Xbox360).csproj
84b6d573932b533b26cd1a86750a6c48095a450124b4ab0d4f0b34e0fc326e38  CardsFramework/Cards/Hand.cs
17ed02cde1055927606720b4612343c7d23bef422c1f2aa854ffadaaeae4f051  CardsFramework/Cards/TraditionalCard.cs
466910fc87e09d38bf704fed1a213f0e91f400fad88197fc21c2e060133db754  CardsFramework/Game/CardsGame.cs
43458cab16836882fbe61b13cd779131d2c16da13901cccb6569fa7e26d2adac  CardsFramework/Players/Player.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  CardsFramework/Properties/AppManifest.xml
6d8978c2159525f9776a2c57660ef82c8d0bad4d38555cd45e442c15247169da  CardsFramework/Properties/AssemblyInfo.cs
ad7d21755c012975a8432f4bf272c4a6e63b38c89030733cf00de757647aa908  CardsFramework/Properties/WMAppManifest.xml
a04e6e1e308ecb2794a30165dd49cd8a79fbd1ea084871f74f1d7e93cbfd86e9  CardsFramework/Rules/GameRule.cs
302d8d2268c8d6bd25fd7e53a480ef306a4d07f6c01952e604048bea0c1001e5  CardsFramework/UI/AnimatedCardsGameComponent.cs
bb7e357a89fcb0a40e6534552ec9dc1c6d41d949573bd05090d4226e75f04450  CardsFramework/UI/AnimatedGameComponentAnimation.cs
7315e8d920f04b7f1ca47db791da1af2270429e1babc165e4b68ec3ec39665fb  CardsFramework/UI/AnimatedGameComponent.cs
2eec65767e3e7e806e944aeccd887fd68708c3f76946e235039eb836fca3d577  CardsFramework/UI/AnimatedHandGameComponent.cs
fa3766bf9edd60934b9834022e362a2d921cec0f9c7386170a2ef874f0cb9467  CardsFramework/UI/FlipGameComponentAnimation.cs
4d4f6894d34858aa8932341f3665fbfe049d0cf225f9c9277d98666d901a2b47  CardsFramework/UI/FramesetGameComponentAnimation.cs
50755fc75a1de5142a095560614e366f85b6c95393770051bd62f39cdc4ea46d  CardsFramework/UI/GameTable.cs
4c2ecd858e859e0dd457aeea2045da1f2010ac51a52c26c73a936d0dd03143b4  CardsFramework/UI/ScaleGameComponentAnimation.cs
a3fd47db596cca29520943edaae5a96157556df36582eec5387cde935f862f16  CardsFramework/UI/TransitionGameComponentAnimation.cs
e2afd54c202b618c86a4a07b1847a7bd4673ec6dc9436253b5196c6ab4ee223a  CardsFramework/Utils/MathUtility.cs
882e8eec60e06f0be3a61a59b67aa969ea000157859f5b5bd4b61a7c57b4a2c5  CardsFramework/Utils/UIUtilty.cs
8d15870df7192571219815e014b4f9dc456012bb2e487a7e066341e11a5fdd9c  CardsGame/Background.png
4c3bb2b4cdca573def1019b540eb5f0d6487d73328d87ee364d926d554f13a7c  CardsGame/Blackjack/Game/BlackjackCardGame.cs
7c74313258777e919573f8b01a6545dab56911b8b260edba30675e534e9ce21c  CardsGame/BlackjackGame.cs
9db43f374eb645f0a49bc58141886ecc72e36c58416083b4ec6dc7dfb734f109  CardsGame/Blackjack/Misc/BetGameComponent.cs
baf7d78637b82d9cc1dc13c22ef1e8a7f1252947ec0020f1c094ad40ce4304ba  CardsGame/Blackjack/Players/BlackjackAIPlayer.cs
d9e494ec38a54d7cdf4b4d33850332c6e56c2f498e06cb5e18a1f7063cc14873  CardsGame/Blackjack/Players/BlackjackPlayer.cs
e8bb188d2aa3f2126e23a0b0164be97f3e91481e6772f586845e16f0224961a8  CardsGame/Blackjack/Rules/BlackjackGameEventArgs.cs
5d3ba3501c9680f99e0ced8ae3c3e67c6c718315bb5ed7c9b2d0d9e475d3b26f  CardsGame/Blackjack/Rules/BlackjackRule.cs
cfadffc59c76da88b522c6c11ea78c65bf5d6c4eb3ef519241dfb1260a5d51b1  CardsGame/Blackjack/Rules/BustRule.cs
92aa3ce0f1716e12b9e226d9aab7a3a70602d9904a08dfb72f4a0ada7d1a3bb7  CardsGame/Blackjack/Rules/InsuranceRule.cs
74eca571c9cf17aaa560cc07acf03014c1527ca2d3c05614927cd77265983b53  CardsGame/Blackjack/UI/BlackjackAnimatedDealerHandComponent.cs
9c9c94767f4fc30cfad62a3adbcd6dcbca74970ddd4b47a589cdd8be7ad33fe2  CardsGame/Blackjack/UI/BlackJackAnimatedPlayerHandComponent.cs
a0e756a8aecc63644cb449f5a05b21168c231ddd8fad735493a1e21323f957b8  CardsGame/Blackjack/UI/BlackJackTable.cs
854968060da5fa71d3b1da47720009e2e403de99090add9cd2d6ca1f50b49c00  CardsGame/Blackjack/UI/Button.cs
00060af5d5c4f2f14a5f093fe9e74575b4eb6c2fb7a5b708a8f844c7f80cb92d  CardsGame/Blackjack(Windows).csproj
dcf46716316736ef333febbb8eed572e8679a28c70a48d271b2c8b3e889f0c83  CardsGame/Blackjack(Windows Phone).csproj
6f4ecd900b8cf64fad367aa228b9ff261dda5f5f317d1abc140069a8620639a7  CardsGame/Blackjack(Xbox360).csproj
bc9c1b213a581bc78d8bcea5586949db5aef996a5e54f3ca5190d855465e23e0  CardsGame/Game.ico
5016dd2cb32f9c9cbb885c2884665d32f04690298c97a237ea0eefe79bb1b84f  CardsGame/GameThumbnail.png
15628ea409bf6058049b190387efc0c61e03e0bf99c70eb0cde5c13fd4bad905  CardsGame/Misc/AudioManager.cs
a4ce3fec9cd193b9c0e7d116ff52dc1e7d2d79604d53faeb0ca42a14d06a72d3  CardsGame/Misc/InputHelper.cs
bcea9444622e78caa8429641a98a7761524182e1b437e56baff586bba8976979  CardsGame/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  CardsGame/Properties/AppManifest.xml
eb76d084ea456dd5408b12edd94481ba9806789bf72e2d4ab9fd546805b6f380  CardsGame/Properties/AssemblyInfo.cs
fba8c0443fc9e6503120b7245649e0788c869c31b8bb19207c1b797e21f0f435  CardsGame/Properties/WMAppManifest.xml
85749b2f8a55f22bf8251210ed518ab56b4c02bfe1e63358566bd41ee6603c90  CardsGame/ScreenManager/GameScreen.cs
5de06d942bd554de456472f80bba35f7618395864e01e2884844968cddc067f7  CardsGame/ScreenManager/InputState.cs
3a2914282efe54ffa81fd8dbcec499844588e409a5ce8dcec8882c77206e2f8b  CardsGame/ScreenManager/MenuEntry.cs
df6d82332cc5077b1231f5c0b2091ece748d370b63eac6da9ee012fadf49716e  CardsGame/ScreenManager/MenuScreen.cs
75dc8b6f281f7192cda42acb682eef99dcfa0771eccad2282842d050a3c60fdf  CardsGame/ScreenManager/PlayerIndexEventArgs.cs
a00396f330a9c97a2d1c14cf108d95aa939dbf67e127d0043d5efcd508a2f3e5  CardsGame/ScreenManager/ScreenManager.cs
98c99c94caf46d4b761229c1c8ab8bef91270c00f4fc4ebe00b3f54bed0360a6  CardsGame/Screens/BackgroundScreen.cs
5c3b044f855b34ff9d7aa943f3563fd342be31b00e593197d48d060066929d8e  CardsGame/Screens/GameplayScreen.cs
93ec23f076946a77bc881db236917c0f900957ef2d56f1753c5963af4c0303d6  CardsGame/Screens/InstructionScreen.cs
683dc76b51c9476f7e95554506b5f04a8facfc648b04f1ed9be8e82962cb61fb  CardsGame/Screens/MainMenuScreen.cs
2b2df1ef4e8bd0b960b76f61632598f0089cd4b178778b5b9fea13f2fe0e0bff  CardsGame/Screens/OptionsMenu.cs
2ca56d85bede3e9d2fb94ed2ea493ad7dc877755656b97c42d7005cfe7b03c81  CardsGame/Screens/PauseScreen.cs
4a17267f1a9a34242a5f4431d716c5e97d8b402426cafb9100bb2ebdeaa63289  CardsStarterKit.htm
```

## What was verified

The title frame, and the table after Enter on Play (`/rv/tmp/cs-samples/cards-play/`), at 2% fuzz against the C++ port captured the same way; the exit path captured with the Exit entry selected and Enter as the exit key (`/rv/tmp/cs-samples/cards-exit/`). Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-60/CardsStarterKit/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
