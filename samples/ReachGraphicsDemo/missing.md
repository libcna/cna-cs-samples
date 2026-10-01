# ReachGraphicsDemo audit — CSSAMPLE-005 ✅

## Result

**The original C# runs unmodified and every demo screen matches the C++ port.** The game and its `DataTypes` library, both verbatim, build in Debug and Release with no warnings. The menu frame differs by 11.64% (its animated background). Each of the six demo screens was opened with a click on both builds and compared: dual-texture **0.49%**, alpha-test **0.11%**; basic effect 14.88% and environment map 21.21% (the models turn), skinned effect 24.67% (the walk cycle), particles 83.29% (random). One screen per stock effect, so this row exercises `BasicEffect`, `DualTextureEffect`, `AlphaTestEffect`, `SkinnedEffect` and `EnvironmentMapEffect` end to end.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ReachGraphicsDemo_4_0` |
| Project | `ReachGraphicsDemo/ReachGraphicsDemo (Windows).csproj` with `DataTypes/DataTypes (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `XnaGraphicsDemo.Program` |
| Assembly name | `XnaGraphicsDemo` |
| Content | the tank, dude, saucer and lightmapped-scene models with their textures, the cat the particle screen spawns, the sky, the checkered ground, the fonts and the background — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `DataTypes/`) is clean.

```text
88517d0dbb54d9d263196b60e1c647f5c1e4a6600ade8acb26b48230779cb669  DataTypes/AnimationClip.cs
ace470bfd2d6e65b4f8e01be2db599d85e7f1f449c39b9b64f74431eef03d018  DataTypes/AnimationPlayer.cs
c93d6716aeff9aa80c240c31571fa2c977b9a65e4d546fe9eb6da5f5ced64f93  DataTypes/DataTypes (Phone).csproj
2a8a0417082e8a84f43397184bebd8810853eda27143aab6a9af9939553ba78d  DataTypes/DataTypes (Windows).csproj
690a2f13c812dadeb1d855be4d47b0f49280c005317c13daae77074527bfc7ee  DataTypes/Keyframe.cs
7f2e15355282d963ba107604aaf7df4047893e1958b693c858c7180ede2798f1  DataTypes/Properties/AssemblyInfo.cs
a30db20e3ff50c32901b1b3229fd0a274c852050faa1aa357f1c40698b953d7d  DataTypes/SkinningData.cs
180fc5218154029f3e98c054f73f4898736be9dc1507ec38480b7351ce803de3  ReachGraphicsDemo/AlphaDemo.cs
5a2a4bcf04fc8b38b3c5d0f3265d8c4ef97bff7294d312c0d01c78c505898dce  ReachGraphicsDemo/App.config
477d0dc05398e99aba1909a219e6752d81482719f105d4ebae50609f87c84da2  ReachGraphicsDemo/BasicDemo.cs
cd9ce3e31f79b4151f6c9ded701b77567894cadb32af861cb52da88d3f98af8a  ReachGraphicsDemo/DemoGame.cs
87d6e85b3806b62dd7f51cd3843dcca915973c4417cc6ce2504936c1b7b841c3  ReachGraphicsDemo/DualDemo.cs
335d88b3c77c2e46f0ab208039461ed94cf91eee9e4ccd439624ba2c5c1e28eb  ReachGraphicsDemo/EnvmapDemo.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  ReachGraphicsDemo/Game.ico
c5f1d8502c501db1f0ae947a2bea80b587123f98311a6c13131324bd614c9052  ReachGraphicsDemo/GameThumbnail.png
9f417ee9759d76303958c265d9d5d49dc4a33ec9d1790ac303fbccc8b3712e83  ReachGraphicsDemo.htm
a28f7f6eaa74c862a9cca31d9b8f29ae807c2e027359a5006ded1d8de4423f1a  ReachGraphicsDemo/MenuComponent.cs
a15867e1148f5e04eaf9e715b49a74a4afeebc05c8bcd365fe9fe47ba9093572  ReachGraphicsDemo/MenuEntry.cs
57e7c203ccd37bcf0d26a003531dbcfb7aa96a717d4c263e948d5eeb26c7d122  ReachGraphicsDemo/ParticleDemo.cs
75e5bdcf09b29ef128d76639a150f08bf62c353bd12842ede4bcebfa6e468f81  ReachGraphicsDemo/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  ReachGraphicsDemo/Properties/AppManifest.xml
9f4eb09abad1b5b81ec93646dd1f93766cb4ff51abfc792a36d8cced39540bbf  ReachGraphicsDemo/Properties/AssemblyInfo.cs
b923beb283085c70939f02fb8114e799c1a6867fe35ee64278e51695e35b0cae  ReachGraphicsDemo/Properties/WindowsPhoneManifest.xml
d82cecce703a26cf7f610b9645bc135ed469119541ce35ec422b2aa26e3746f7  ReachGraphicsDemo/ReachGraphicsDemo (Phone).csproj
b1190cb5b2ed8a7aa13fcc7f93412d37c5344bfe4352bc7fadbce53e7aef2cfb  ReachGraphicsDemo/ReachGraphicsDemo (Windows).csproj
7fc7dd2f8f80009b0c6959c76c37fea92e3384c849c6aace3751d07e11504c3d  ReachGraphicsDemo/SkinnedDemo.cs
6a4eed0cd9cf6ecc71dcc84ebbd0854ec9d44371e41ad267af5345b2ee1f9ac2  ReachGraphicsDemo/Sky.cs
80a1bc7c643cc4c708c77f1f103d9b75af929f7fc80ccd6751a2bc85fd009ffd  ReachGraphicsDemo/Tank.cs
53cb88d3f679c5627bb05ea24c4ae80bbdc0cff39579bc81c2a394b6df23213d  ReachGraphicsDemo/TitleMenu.cs
```

## What was verified

The menu frame and the six demo screens (`requalify.sh --xdotool 'mousemove 340 <y> mousedown 1 sleep 0.2 mouseup 1 sleep 2.5'`, `/rv/tmp/cs-samples/reachdemo-*/`) at 2% fuzz against the C++ port captured the same way, and compared by eye. Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-59/ReachGraphicsDemo/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
