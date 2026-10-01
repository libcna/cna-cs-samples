# NetRumble audit — CSSAMPLE-062 ✅

## Result

**The original C# runs unmodified and matches the C++ port** — 1.04% on its title menu. The Windows project's sources, verbatim, build in Debug and Release with no warnings. The game lists its sound effects with the BCL, not with XNA: `new DirectoryInfo(Content.RootDirectory + @"\audio\wav")`, which Windows resolves to `Content/Audio/wav` and no other filesystem does. `NetRumble.csproj` therefore places, beside the executable, an entry named literally `Content\audio\wav` that links to that directory, so the unchanged line lists what it listed on Windows; the sounds still load through XNA's `ContentManager`. A project-file setting rather than a source edit, as `rules.md` asks. Escape opens "Exit Net Rumble?" and Enter exits 0. Signing in and the network sessions were not exercised.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/NetRumble_4_0` |
| Project | `NetRumble/NetRumbleWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `NetRumble.NetRumbleGame.Program` (nested in the game class) |
| Assembly name | `NetRumble` |
| Content | textures, effects, fonts, particles, the sound effects and the music with its `.wma` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
8d301bff657b8905505e0ee146d35aec21185524e083b3f66026a4006604e85c  NetRumble/AudioManager.cs
55be47fd1b1d8cb954da9ba894dff6b111a5fc4741b1f79b557ef894ea7de0d3  NetRumble/BatchRemovalCollection.cs
f694111ee37856f9afacbef81f006fe9a3d0dfe136ccc9de76a269a5f47524bb  NetRumble/BloomPostprocess/BloomComponent.cs
667eb3eaeaeff9e695261d34c5b5b97ed3145f6255d9187604ce02cc196a1817  NetRumble/BloomPostprocess/BloomSettings.cs
acfae14e2b39e727103a4fe1709e00317df09724cbd4d40345b84e6a1aa1890b  NetRumble/CollisionMath.cs
827bf87c955b9976f657dfbe75e2169e4e3640ec045772b7e9504eb04de8d5b6  NetRumble/Documentation/readme.htm
4ce4e03dee07914635465828ffff5e8fb6f3784b40cd19dfe423282c6749f0ce  NetRumble/Game.ico
3bd6cc56fbf1adba7c77b2052970b2d05731ee89cd03fa1b4778bf6f7b5eb56c  NetRumble/Gameplay/Asteroid.cs
63624eba5682295c9b23eb3f9729184ec9940d31db5c4677104c44d8878f26c8  NetRumble/Gameplay/CollisionManager.cs
05ed62bc04c1fcb36ec9a2c29e1ba32a5d51782847dc2a91d093777654b557d3  NetRumble/Gameplay/GameplayObject.cs
58854a7faf444c5e236f8e3a7c80041468d0a4521767dcdafda891230940eb72  NetRumble/Gameplay/PlayerData.cs
ad29f960b668e045dcfc4c8b69e527a34c2bdeaa991691322f82893c5883165c  NetRumble/Gameplay/PowerUps/DoubleLaserPowerUp.cs
4251cbb4c2eb1998618286de75d28b3d03adc87d0de24375b03473f9871b9d14  NetRumble/Gameplay/PowerUps/PowerUp.cs
0d2429209869448770ea9e506a7089e6b3b17c2e78ecef301a265d0d75c3f690  NetRumble/Gameplay/PowerUps/RocketPowerUp.cs
8804cce224c3a5e72b649c42afb5ef6c6ab159fe7d70b2bfcd8236e0301a4f25  NetRumble/Gameplay/PowerUps/TripleLaserPowerUp.cs
d4ea690c847a5b59a34c07413ee8d227f92dc427f1117d7c8d8eded75047f538  NetRumble/Gameplay/Projectiles/LaserProjectile.cs
ac651a6f0969cc75fddf456030158b1e66cf2df32885f0405ace5fc8a29f33e3  NetRumble/Gameplay/Projectiles/MineProjectile.cs
6e4d21106e145e382dee88c584f029de603b3a5923a42669c4996c735a94bfef  NetRumble/Gameplay/Projectiles/Projectile.cs
4441c4c3d549ce17a000ffb53ee0492886dc77416ecf5b2bdfdf7c57e1a24ccb  NetRumble/Gameplay/Projectiles/RocketProjectile.cs
fe86d909e169a52f797233bfff879b5fa9cf8ffbf9d46dc6514b1ddb7f11cbdb  NetRumble/Gameplay/Ship.cs
e3f92b46484e812f8346bb9c95803b7f596602ad5919ff36a4375ac709b13717  NetRumble/Gameplay/ShipInput.cs
423437dfe8ae5c3bc1f34a347ea6a40e2edf4de8fdef812d775286bcca741375  NetRumble/Gameplay/Weapons/DoubleLaserWeapon.cs
11e7a56b2f21c5d266b612f3fe5ca71f2d25729134164b829ad6e66bb14b1bf6  NetRumble/Gameplay/Weapons/LaserWeapon.cs
351d6c5bd6e8eaaf244cc57c0b7d62083719c1640ef4f33a9cd9a1f3fc0d45ea  NetRumble/Gameplay/Weapons/MineWeapon.cs
5e206fae0cf771839b2de58bcab134a0b6057bd4da00f48d6afcc5af3c012695  NetRumble/Gameplay/Weapons/RocketWeapon.cs
69a74bb3476e8ed3a3e2dface5ab84499ef6dc50e4ec2da1a6c66f9681e8831d  NetRumble/Gameplay/Weapons/TripleLaserWeapon.cs
cae86a6d483eadd3c3c45b72290436ff9467c3b17d4e71d528613c01eac41dc5  NetRumble/Gameplay/Weapons/Weapon.cs
731584e59d777ea9688fdfd726bdc468366268ac8b4171df01029ae78b06098a  NetRumble/Gameplay/World.cs
804ed9fbae1bc544839655172e0c896d1afcb78e246a896ace7ecab74df7abd4  NetRumble/GameThumbnail.png
18b7e0388217880c4b4f278955ced8b55425b655e7d6257cfb8e8a00dd62711e  NetRumble/NetRumbleGame.cs
f41d1ff56c6c73533447008172980e8599cf8a58439158a6bbe9c7aa84d68417  NetRumble/NetRumbleWindows.csproj
424b395dab7c764eb4a867cea9dbf45abe8cc205e691813b7e9d409bc8e94864  NetRumble/NetRumbleXbox.csproj
846394f8b9623bfc0c1eda9da709d7baa1b536569dc5dd98152ee623462248d0  NetRumble/OperationCompletedEventArgs.cs
4422a7a89de67745b9aeeee91886a267c1aec3095db149fd3d83ec275e7dded0  NetRumble/Properties/AssemblyInfo.cs
48efdd7c34a345339cf90f442f0dbebb0b1be4774dac9be35d7750911059cabf  NetRumble/RandomMath.cs
c9706e4593a44e41e40f9552b1fcaf9b9815a4eef3374d4cecfa9c4cea277854  NetRumble/Rendering/Particles/ParticleCache.cs
d87b0389d53e4b6cd56eac852e8d3754786543e3a8febaf04be2454ddf95fd58  NetRumble/Rendering/Particles/Particle.cs
f8379d056c72b0c2f1d7df29b16e56a8492bcbdc4f47404550d9f89c03998f68  NetRumble/Rendering/Particles/ParticleEffect.cs
fe68641ee2daac8a1d51fe7c6ed682ca88ffcf089f374f26f0bdd0587989cc38  NetRumble/Rendering/Particles/ParticleEffectManager.cs
178511d840e33300b8c2b8f1e29f96800712fdf482b31adfb89c5f6e2324935d  NetRumble/Rendering/Particles/ParticleEffectType.cs
c789fc237ddaf5f39c34914d96234675e706a3acd1267b846cc3feed9c362b4b  NetRumble/Rendering/Particles/ParticleSystem.cs
1f79c2df7fdff7051221559150ae88a2c79650253f5f8dc5a10118e79267e917  NetRumble/Rendering/Starfield.cs
d4a4ef7cec49b3e0f598ce015172d63278bcc26ff537ae663d467c65c91a136c  NetRumble/ScreenManager/GameScreen.cs
4137589f5d23f75d05ea69dcaa95331e7ed472cc542701b540d088e2c27a058b  NetRumble/ScreenManager/InputState.cs
e48176a4daa288c3d7d5f8b6b3ce9ad84705158224f8087f8561b74c77e5c86b  NetRumble/ScreenManager/LoadingScreen.cs
a924bdc44aee8bc10b5b3f02005bc6f29680b7d35caaec28af20c8c407349585  NetRumble/ScreenManager/MenuScreen.cs
01dc327d8a52664ef00a711bebe3124f384780fa99d329c874ed9cde7193e185  NetRumble/ScreenManager/MessageBoxScreen.cs
58f1e26ff7e84c6937441e91787b0706a3ba0c483f0d855cb281c66cb863d33f  NetRumble/ScreenManager/ScreenManager.cs
f04b43a171c2ed900ef7068dc3c06d20e9449d37957b7c15d4b0c0bfcfc21976  NetRumble/Screens/BackgroundScreen.cs
674501286fff38b86d6588b9b06c4aab8a67ccbe3f5b9c20d20547c74b0ad2e6  NetRumble/Screens/GameplayScreen.cs
d4e06d3efc494ca632c7ae7a6485aa5ff0c3ffab606f335d3c0ed0f230d09f1d  NetRumble/Screens/LobbyScreen.cs
86c3af75ca4282fbfc433d8ea55d6b513d2053ee37d74ccc512af26c337f2443  NetRumble/Screens/MainMenuScreen.cs
51c67b03a1b9228cf088b525fbb736b97e4f4e84ad33361eef66cc643eb04fea  NetRumble/Screens/NetworkBusyScreen.cs
13b0211cccd9fbb0f4c60146d130ee5bdcf4b7357affbec3c2aa292884ef307b  NetRumble/Screens/SearchResultsScreen.cs
```

## What was verified

The title frame at 2% fuzz against the C++ port's frame captured the same way; Escape, then Enter as the exit key (`/rv/tmp/cs-samples/netrumble-exit2/`). Runs against CNA.NET `a6e0c50`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-61d/NetRumble/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
