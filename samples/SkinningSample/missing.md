# SkinningSample audit — CSSAMPLE-054 ✅

## Result

**The original C# runs unmodified and animates the skinned model.** The game and its `SkinnedModel` library, both verbatim, build in Debug and Release with no warnings. `dude` first failed to load: its tag is the game's own type, so it is read through the managed `ContentReader`, whose table had no `SkinnedEffectReader`. Fixed in `../cna-cs` (CSX-092: every stock effect reader XNA writes into a model). The first frame differs from the C++ port by 8.15%, the walk cycle's phase at capture time.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SkinningSample_4_0` |
| Project | `SkinningSample/SkinningSampleWindows.csproj` with `SkinnedModel/SkinnedModelWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `SkinningSample.Program` |
| Assembly name | `SkinningSample` |
| Content | `dude.xnb` (a skinned `Model` tagged with the game's `SkinningData`, built by the upstream pipeline extension) and its four textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (`SkinningSample/` and `SkinnedModel/`) is clean.

```text
88517d0dbb54d9d263196b60e1c647f5c1e4a6600ade8acb26b48230779cb669  SkinnedModel/AnimationClip.cs
ace470bfd2d6e65b4f8e01be2db599d85e7f1f449c39b9b64f74431eef03d018  SkinnedModel/AnimationPlayer.cs
ec154b1868605fbd763700c265491102c2ca12101a9d70a9583bc795c9b9e11d  SkinnedModel/Background.png
690a2f13c812dadeb1d855be4d47b0f49280c005317c13daae77074527bfc7ee  SkinnedModel/Keyframe.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  SkinnedModel/Properties/AppManifest.xml
4c80662bb94862911448be1db3f301805efe90f894218cff39e0cadbd304c248  SkinnedModel/Properties/AssemblyInfo.cs
0b6d09de5ee15f9f24ae0028770c47e747dfb0324d3b50b1054f17085d2e8055  SkinnedModel/Properties/WMAppManifest.xml
f2837dc673022a3d5f014f24e5f412c31ae7abb2db14e55587c55113f8c10eb5  SkinnedModel/SkinnedModelPhone.csproj
b872d8dd1d620a34294ccadd56e4501e2407a82d49e3592a24e8d2524c7c7096  SkinnedModel/SkinnedModelWindows.csproj
7179f6ae1118e265809e1d3a81fae914dbdec62c3f076f244b7856d57c29d016  SkinnedModel/SkinnedModelXbox.csproj
a30db20e3ff50c32901b1b3229fd0a274c852050faa1aa357f1c40698b953d7d  SkinnedModel/SkinningData.cs
a9369df5bc0bbe0952089a607a6c0593ff0e327ae5684eba6aad1859b19ff5cd  Skinning.htm
29bf5d79c888b765f58ca55d30642d352e65f4429c2bc9e5d93ddac69bc268c0  SkinningSample/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  SkinningSample/Game.ico
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  SkinningSample/Properties/AppManifest.xml
9a0a8a53d2d9c2c6129a222f0499eb11e6c2cbd50e525eafcb3a5561284a2102  SkinningSample/Properties/AssemblyInfo.cs
90050cf7cc8e394366e2f14a4c713409de03b3907408c49cd8956a80ed9fc9ea  SkinningSample/Properties/WMAppManifest.xml
717d97402749bb5281d9466d8a77843793b7371a60610a81c1cd63d1ff0b82c4  SkinningSample/SkinningSample.cs
b77404531655a08b90c4ed52bbed8af5af50efbfc723ce5e03b0170083be604b  SkinningSample/SkinningSamplePhone.csproj
767ea652b4b648ec06d9cef7d569bdb45808d51e69f8e204f3520212ec416911  SkinningSample/SkinningSample.png
fefb5bf067a5009bbad9c391ed8d56b3d7d6272ba3120d8c5df47557f3211522  SkinningSample/SkinningSampleWindows.csproj
2f26d684bb3940a1483361e02fcb8a74dd62549f633db4662520f1ce4f46c479  SkinningSample/SkinningSampleXbox.csproj
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way; both show the same model, lit and textured, mid-walk. Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/SkinningSample/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
