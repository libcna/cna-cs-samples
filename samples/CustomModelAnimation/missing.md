# CustomModelAnimation audit — CSSAMPLE-051 ✅

## Result

**The original C# runs unmodified and matches the C++ port** — 4 differing pixels of 384 000 with both animations playing. The game and its `CustomModelAnimationWindows` library, both verbatim, build in Debug and Release with no warnings. Both models' tags are the library's `ModelData`, read by XNA's reflective reader (the cube's rigid and root clips; the dude's skinned clip and 58-bone bind pose). The start frame shows only the HUD, in the original too; A starts the rigid animation and B the skinned one.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/CustomModelAnimation_4_0` |
| Project | `CustomModelAnimationSample/CustomModelAnimationSample/CustomModelAnimationSample.csproj` with `CustomModelAnimation/CustomModelAnimationWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `CustomAvatarAnimationSample.CustomAvatarAnimationSampleGame` (the game class carries `Main`) |
| Assembly name | `CustomModelAnimationSample` |
| Content | the animated cube and the walking dude (each tagged with the library's `ModelData`, built by the sample's processors), their textures and the font — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `CustomModelAnimation/`) is clean.

```text
c6a561c8ffd6d6406c695e092f7072a96d172e849bffde92750d3810a763cf0e  CustomModelAnimation/CustomModelAnimationWindows.csproj
f9d0cb98ba33a40622bcd27319449559a5cd61186987d6244d1233d8ac67c73f  CustomModelAnimation/CustomModelAnimationXbox.csproj
a01638cdf1aa6133fc4e18b528de57d0c35718636ae3e03a525665b945784a94  CustomModelAnimation/ModelAnimationClip.cs
ac4fcb5c4238d55d1c9f0f98e15bc480e3053835384b587ba2c19746ce39af11  CustomModelAnimation/ModelAnimationPlayerBase.cs
0d63055df8b74ea9f6bcbe326c7b7793862f208e107be11f8717a44df6508c2d  CustomModelAnimation/ModelData.cs
e67b0d54638bdd3f382dbb1cad2bf97f745f70a0f8b00002d96acb421d2845bf  CustomModelAnimation/ModelKeyframe.cs
43e0ca88ad5faee2970cac280e7907c1d8082774914f2ca9783678b86c01d5b0  CustomModelAnimation/Properties/AssemblyInfo.cs
ae5ed0e8172d054b00b824a683d879b1f46ec4960f6897cab19104fe5c322b48  CustomModelAnimation/RigidAnimationPlayer.cs
88ddc54452a7c1ab502fdb74c4eb2dd4e483fa7039f0c7b2db17a604f45eb1f2  CustomModelAnimation/RootAnimationPlayer.cs
6fc15de681ba19d133cc1798601de27df4e8e9668917d369ccdd50c212878d1b  CustomModelAnimation/SkinnedAnimationPlayer.cs
71e1ee9ee41262710635c1ebcdfa0d756a41935ebcff558a5d5227b4fe58acd2  CustomModelAnimationSample/CustomModelAnimationSample.cs
b4061b44086b7b40cf9b5169edfc88815a3cd6931f570e36c79c7e8be1e5a1ec  CustomModelAnimationSample/CustomModelAnimationSample.csproj
dbdc793885cd44ba7ad9776f67d1b3eb04d26356c30e8fb8eb0720af5e22e632  CustomModelAnimationSample/CustomModelAnimationSampleXbox.csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  CustomModelAnimationSample/Game.ico
3cd2cfcac93c3a0dcc5ceab63ad57e3b5afd0a1dcc722428e66c51031d79d0ed  CustomModelAnimationSample/GameThumbnail.png
8ba41c957f1a3b4dbdd8e52facb60243f2c9b0c532ec1dc2e219fd69d96ed0ab  CustomModelAnimationSample/Properties/AssemblyInfo.cs
59167324824ecec9db1563b8bfefefa9fc213708d1172ef8f7606f282141f084  CustomModelRigidAndSkinnedAnimations.htm
```

## What was verified

Captured after holding A and then B on both builds (`requalify.sh --xdotool 'keydown a sleep 0.3 keyup a sleep 0.5 keydown b sleep 0.3 keyup b sleep 0.4'`; a bare `key` tap is shorter than a frame and is missed by a polled keyboard), against the C++ port's frame captured the same way (`/rv/tmp/cs-samples/gallery-batch-58e/`). Runs against CNA.NET `590d007`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-58e/CustomModelAnimation/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
