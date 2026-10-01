# ShipGame audit — CSSAMPLE-066 ✅

## Result

**The original C# runs unmodified and draws what the C++ port draws.** The game and its `BoxCollider` library, both verbatim, build in Debug and Release; the one warning is upstream's own comparison of a `KeyboardState` with null. It first died in its constructor: it gives `AudioEngine` `content/sounds/sounds.xgs` for `Content/Sounds/sounds.xgs`, which only a case-insensitive filesystem opens. Fixed in `../cna-cs` (CSX-096: XNA's file-taking APIs read paths as Windows did). The title frame differs by 51.60%, its animated background; title, ship and menu are the same. Quit Game (Down three times, Enter) exits 0.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ShipGame_4_0` |
| Project | `ShipGame/ShipGameWindows.csproj` with `BoxCollider/BoxColliderWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `ShipGame.ShipGameGame` |
| Assembly name | `ShipGameWindows` |
| Content | ships, level and collision models, textures, effects, fonts and the XACT audio project — official pipeline output, identical to `../cna-samples` — and the ten XML files the game reads as they are (identical to upstream) |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `BoxCollider/`) is clean.

```text
be50cde06d698eef5ee0fe208f2773be0ea4dd5524f7eb082b74f6bd7ad953a0  BoxCollider/BoxColliderWindows.csproj
da885244b69107948e274b3562afd77fef8f76bf8f2169e3d622d5154cecad85  BoxCollider/BoxColliderWindows.vstemplate
de254eaba68737c6241d04d54c52afdef7dfd77158d3105afb41f34ab38163f8  BoxCollider/BoxColliderXbox.csproj
2cc17f117fb85e206c901bdb90df1e35d264de2159e781e22fb15373c8151614  BoxCollider/BoxColliderXbox.vstemplate
dbadbaf15c264d7704f2044630cb6dc275452efa5c664621e7624264cfadb3e2  BoxCollider/CollisionBox.cs
7d8c40e1b1e6178d93bb1775e5eb012ee1f341f0b7a59010c6e09403a5cafcc1  BoxCollider/CollisionCamera.cs
d6458093dba2c029b1d1ffa78278f772c405e9e10967c0239f5930da215eb33d  BoxCollider/CollisionCameraObserver.cs
2b455503d947a3872558b41917605cfa12367ee553b246d579d9d0540236dc09  BoxCollider/CollisionCameraPerson.cs
2c869a493e982007423db8b5c06ef0aac55b42444d41cfc1163d9552bda51bc8  BoxCollider/CollisionFace.cs
62b7ef42e0fda2488c9d6a012bf5714cb4b6eb355ea75f88779cf8e93840b193  BoxCollider/CollisionMesh.cs
72d2051a7146762ea2b23a45dc5b449197dd0ad7b4f9166ff008b1047e34ac7c  BoxCollider/CollisionTree.cs
a89a45c34f5d2192062eee9905e74755053ce092f47c5d50ac3d6a50732e2ed2  BoxCollider/CollisionTreeElem.cs
d43f64a73c880770f774abb3567756d39612e390a35f2f00146489759fb5bd67  BoxCollider/CollisionTreeNode.cs
40b5e605ceaacd561ba469b38cccb9b313c5fc23275cebb4ec1009c5e45d400d  BoxCollider/Properties/AssemblyInfo.cs
31b491a9c41a9d8bd123c9608127a2cccb39c97338a1e80b6026dd077282b9a2  ShipGame/ChaseCamera.cs
39084c8280068b3d9d57917b11d61db5dd5e6f34233240fcae9ab010f383463d  ShipGame/Documentation/Ship_Game_Starter_Kit.htm
03caf30602ed3845baadb0e7d05b587b1ed68300c71c2961e3cb4aeddf5516b2  ShipGame/EntityList.cs
d1f5ffb56eb7c78440824b7d1c04f8e2339210c9433898410103ba58e292b2c3  ShipGame/FontManager.cs
e5db5f2971d43b0d101afbf870c38cd5b347d912bbd794a16b3888a58da33d4f  ShipGame/GameManager.cs
2b899df398d7295c60a8c66b47f6c1dcb00d1262b450a9d3737fff87e46a40bd  ShipGame/GameOptions.cs
b71429cd48ed2c70565fd0d2b40259b95d8fa7b19cc02ed19ee4628b156d23bb  ShipGame/Graphics/AnimSprite.cs
7ac69cf1c655b436aceec1ade0689887dd6921ea2513ce52cf04ebed1fcabcf6  ShipGame/Graphics/AnimSpriteManager.cs
24e8ebc9f2729633c6dc08b575fa5acd6d54468d3bc26077864f367794a31379  ShipGame/Graphics/BlurManager.cs
be9adf4bf7544f65dc5c8740645a825a8ff1c32fe42012d6929c7f0e19ca2acb  ShipGame/Graphics/LightList.cs
cd02f9b99c649e08b321c01162215476651557b441e9ef321534f0d1e322e6f1  ShipGame/Graphics/ParticleManager.cs
679647321992aa9d90ede4f2fe92a625e83b419742b5ad14c1c705c207e5c0ff  ShipGame/Graphics/ParticleSystem.cs
c636e57d19f005583e4450a8f262aca7bb4fc1f78fd6e0f8d7e78b7911599892  ShipGame/Graphics/Powerup.cs
f18e52f9dc60fd25f96c7e83ebb2d11057f35d98c6cafe1b1c513b1a6e04e692  ShipGame/Graphics/PowerupManager.cs
8a31a4584334d75caf72adf9c853551d6772385d235dfb93e73bdc32cb9f55c2  ShipGame/Graphics/Projectile.cs
eed7c6743526b95cb3709b8bd90bc05bec8f23c8a2f0e82427f9722ebbcba7a7  ShipGame/Graphics/ProjectileManager.cs
7b9900fc68fbc0b55a84751397fb2978e4cf43ae604bbf72a8c39ff467949575  ShipGame/InputManager.cs
5e1efdc32b6ace9f67105510b1502d2dde892a26f673507cc2bb7a063b2a6eca  ShipGame/MyShipGameWindows.vstemplate
386bfea0db8bdc80899b0664836460c7a664dcf5b9cdc8af55e2c5dda8f4be24  ShipGame/MyShipGameXbox.vstemplate
eba64b7f64901d6a623be73f051a54845abe9eacf051f9d5cfbbf630a2fb5f37  ShipGame/PlayerMovement.cs
ee3219cc8a38c808686a2f45070846c6ad5c43e4b89e34e984b4e1204e42fa58  ShipGame/PlayerShip.cs
9292dd1dc72fd771af6271e877bc647d4cc806ee1594c6b4ec4b25c67dbb9e10  ShipGame/Properties/AssemblyInfo.cs
19c9a15347689bdc57f44cc8dee089e50a58fa138be893dd380a24084e736dec  ShipGame/Screens/Screen.cs
13db7293c8241c4e010edf39efd3db218fdfb60cf20fb78d579b9d72888c9716  ShipGame/Screens/ScreenEnd.cs
82a26a92961590cf97ff5402a5b1ccc594397d9577dfc4fe6bf6ed078f236018  ShipGame/Screens/ScreenGame.cs
d42a19f5fb85b4df0ae27d7b3faef29c84b85c26f8a4e0321f58cfe04f3a774d  ShipGame/Screens/ScreenHelp.cs
d33fa957366718b6466ac1dfd50e6071ad1a4e71d9a2a4cc0ac48d30eb696bef  ShipGame/Screens/ScreenIntro.cs
999570878f6642405fdf88e755edfac6abed4361583a09880773b43dc0b7ad06  ShipGame/Screens/ScreenLevel.cs
8808fa9e5cb6ee15fb4615bdd4408fafdbc2666bef0b899f30577207c379642f  ShipGame/Screens/ScreenManager.cs
2693e3667348784aa21597826166a0be5c822e5007b73faf0b8391f85198913d  ShipGame/Screens/ScreenPlayer.cs
6e52e7875c70d3605695ab42a64d7a8cdd654e4d9b53850ae546d72a5883fa71  ShipGame/ShipGame.cs
1a390d2e23904670c1119a0a8aff6934f1ec156fd9ceec3ac5615b966f80aa07  ShipGame/ShipGame.ico
fe01773d7f7d98561d9cd835d69aa7a0988d254150b3f61d3696538cdd55a230  ShipGame/ShipGame.png
5723a397697125b7d1b38516c0ec3c03f1b549c78c1bae5a3e5d2baa520b2e53  ShipGame/ShipGameWindows.csproj
711dd64f01b3c9ad0d64c0d798f94a06e078cb0330c06390ad385c35e2230e35  ShipGame/ShipGameXbox.csproj
```

## What was verified

The title frame at 2% fuzz against the C++ port's frame captured the same way, compared by eye; the exit path with Quit Game selected and Enter as the exit key (`/rv/tmp/cs-samples/ship-exit/`). Runs against CNA.NET `a6e0c50`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-61b/ShipGame/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
