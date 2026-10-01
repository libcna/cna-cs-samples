# CPUSkinning audit — CSSAMPLE-056 ✅

## Result

**The original C# runs unmodified and matches the C++ port.** The game and its `CpuSkinningDataTypes` library, both verbatim, build in Debug and Release with no warnings. It starts in GPU-skinning mode at 30 fps, as the C++ port does; the first frame differs by 9.16%, the walk cycle's phase.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/CPUSkinningSample_4_0` |
| Project | `CpuSkinningDemo/CpuSkinningDemo/CpuSkinningDemo (Windows).csproj` with `CpuSkinningDataTypes/CpuSkinningDataTypes (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `CpuSkinningDemo.CpuSkinningDemoGame` (the game class carries `Main`) |
| Assembly name | `CpuSkinningDemo` |
| Content | the dude built twice, for GPU and for CPU skinning (tagged with the library's types), its textures and the font — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `CpuSkinningDataTypes/`) is clean.

```text
ae99262d4ca8b05b46385e263428330853a88d719e3d56a90fb6dd1eca0f0adf  CpuSkinningDataTypes/Animation/AnimationClip.cs
7bfce935558bba4612dba3415eeb24f9afb2234da2ecb11319552e87930c8cee  CpuSkinningDataTypes/Animation/AnimationPlayer.cs
4a679928ac3f4beb9f52a47993893e1d8565afe327e2b6553a4b3408da02e4e1  CpuSkinningDataTypes/Animation/Keyframe.cs
344d40e64328d905eeb058150e3126b0bc5e051bd58180ee52008a4a87ad1c51  CpuSkinningDataTypes/Animation/SkinningData.cs
0082e6657079c44b131f87b7ac160091bb7af964d84686ad198fc74f7ceb480b  CpuSkinningDataTypes/CpuSkinnedModel.cs
50e35c602f24278893e1c4505bb377252d4f94a3806e7b0233c9cbcd6a0859e1  CpuSkinningDataTypes/CpuSkinnedModelPart.cs
5bc21a116d84baf731fd05fd000509151c03211259a3cf46b1cf3804e0cbb554  CpuSkinningDataTypes/CpuSkinnedModelReader.cs
a345d3c466ab41e24dcc2cd359c985c035fae2eef0218e2206784bbe949107ff  CpuSkinningDataTypes/CpuSkinningDataTypes (Phone).csproj
ef49f2a2fc83c900482540597b9e49c66db33f416961f2110b79bbf67e6e338f  CpuSkinningDataTypes/CpuSkinningDataTypes (Windows).csproj
a87e464246dc3115029b6301ff1dd8f9c10f8f126293a93cf1bc5f798eaf25b5  CpuSkinningDataTypes/CpuSkinningHelpers.cs
0f8c9261c7bd2aa33d0010a85e9e22ba40a111f9d0d3da2291608051c44bdb43  CpuSkinningDataTypes/CpuVertex.cs
b31eff7adee5974caaa98c1c1ded9e4865d2ca8f3f289f95282e4d44f299bd22  CpuSkinningDataTypes/Properties/AssemblyInfo.cs
768a93acf6c6d85eb40390c96a32d199ef4886c1fd8af440ddb00f6513ffb5fa  CpuSkinningDemo/Background.png
49708e8ad96d440c17de49893756562feea05a3e4844f500572406527c9ef7c0  CpuSkinningDemo/CpuSkinningDemoGame.cs
90914157bbad1ed840d80d189a65e15041d854471d63b88874118e66d661ce82  CpuSkinningDemo/CpuSkinningDemo (Phone).csproj
1bd105ca615b41dbce834948e34edb6e9363691f43de36b768ec3a22b37fbd11  CpuSkinningDemo/CpuSkinningDemo (Windows).csproj
16dd7acd022dc0374069dc6bc0588dc2ee9341d64b616f5ad57c6fbccb710e5b  CpuSkinningDemo/FrameRateCounter.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  CpuSkinningDemo/Game.ico
c04f3c0eb1bc2d9eacae33171ca4bac8260fb93b718aeff20f5209eb2aeef239  CpuSkinningDemo/GameThumbnail.png
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  CpuSkinningDemo/Properties/AppManifest.xml
3a0c06277d7c688db5c647a8cf20e6a4afc11e0b0b8500bfdca0ac5b0d9ced57  CpuSkinningDemo/Properties/AssemblyInfo.cs
85b3525186319c9410d98cfabe122b5597ba7e915d812b46bbeef5136293ae36  CpuSkinningDemo/Properties/WMAppManifest.xml
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way, and the two frames compared by eye. Runs against CNA.NET `590d007`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-58/CPUSkinning/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
